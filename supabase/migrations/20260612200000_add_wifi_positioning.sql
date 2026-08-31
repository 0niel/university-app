-- Community Wi-Fi positioning (краудсорсный WPS для кампуса).
--
-- Сетевые геопровайдеры в РФ деградировали, а GPS в корпусах не ловит.
-- Студенты с хорошим GNSS-фиксом анонимно «обучают» базу позиций точек
-- доступа (BSSID → EMA-координаты), а в помещении позиция восстанавливается
-- RSSI-взвешенным центроидом по видимым сетям. В таблице нет ни user_id, ни
-- SSID — только агрегированные позиции BSSID, поэтому из неё нельзя
-- восстановить чьи-либо перемещения.
--
-- Слои по конвенции проекта: core-таблицы → app_api_v1 функции → тонкие
-- public-обёртки (revoke от anon, grant authenticated).

-- ── helpers ──────────────────────────────────────────────────────────────────

-- Расстояние по сфере в метрах (без PostGIS — он в проекте не включён).
create or replace function core.haversine_m(
  lat1 double precision,
  lng1 double precision,
  lat2 double precision,
  lng2 double precision
)
returns double precision
language sql
immutable
set search_path = ''
as $$
  select 2 * 6371000 * asin(
    least(1, sqrt(
      power(sin(radians(lat2 - lat1) / 2), 2)
      + cos(radians(lat1)) * cos(radians(lat2))
        * power(sin(radians(lng2 - lng1) / 2), 2)
    ))
  );
$$;

revoke all on function core.haversine_m(
  double precision, double precision, double precision, double precision
) from public, anon;

-- ── tables ───────────────────────────────────────────────────────────────────

create table core.wifi_beacons (
  bssid text primary key,
  latitude double precision not null,
  longitude double precision not null,
  -- Оценка радиуса неопределённости позиции точки (EMA разброса наблюдений).
  accuracy_m double precision not null default 150,
  observations integer not null default 1,
  -- Подряд идущие наблюдения далеко от центроида: детект переезда точки.
  drift_count smallint not null default 0,
  first_seen timestamptz not null default now(),
  last_seen timestamptz not null default now(),
  constraint wifi_beacons_bssid_format
    check (bssid ~ '^[0-9a-f]{2}(:[0-9a-f]{2}){5}$'),
  constraint wifi_beacons_lat_valid check (latitude between -90 and 90),
  constraint wifi_beacons_lng_valid check (longitude between -180 and 180),
  constraint wifi_beacons_accuracy_valid check (accuracy_m > 0)
);

create index wifi_beacons_last_seen_idx on core.wifi_beacons (last_seen);

alter table core.wifi_beacons enable row level security;
-- Никаких политик: доступ только через security definer функции ниже.
grant all on core.wifi_beacons to service_role;

-- Состояние rate-limit'а сабмитов (только таймстемп, прунится кроном).
create table core.wifi_submit_log (
  user_id uuid primary key references auth.users(id) on delete cascade,
  last_at timestamptz not null default now()
);

alter table core.wifi_submit_log enable row level security;
grant all on core.wifi_submit_log to service_role;

-- ── app_api_v1 implementation ────────────────────────────────────────────────

-- Принимает батч наблюдений: точный фикс наблюдателя + видимые точки доступа
-- [{"bssid": "aa:bb:..", "rssi": -62}, ...]. Обучает базу EMA-сглаживанием;
-- mac-адреса с локально-администрируемым битом (рандомизированные/мобильные
-- хотспоты) отбрасываются. Возвращает число обновлённых маяков.
create or replace function app_api_v1.wifi_observations_submit(
  p_latitude double precision,
  p_longitude double precision,
  p_accuracy_m double precision,
  p_aps jsonb
)
returns integer
language plpgsql
security definer
set search_path = ''
as $$
declare
  v_user_id uuid := (select auth.uid());
  v_last timestamptz;
  v_ap record;
  v_old core.wifi_beacons%rowtype;
  v_dist double precision;
  v_count integer := 0;
begin
  if v_user_id is null then
    raise exception 'Unauthorized';
  end if;

  -- Базу обучают только уверенные фиксы.
  if p_latitude is null or p_longitude is null
     or p_latitude not between -90 and 90
     or p_longitude not between -180 and 180
     or p_accuracy_m is null or p_accuracy_m <= 0 or p_accuracy_m > 100
     or p_aps is null or jsonb_typeof(p_aps) <> 'array'
     or jsonb_array_length(p_aps) = 0 then
    return 0;
  end if;

  -- Не чаще одного батча в 15 секунд на пользователя.
  select last_at into v_last
  from core.wifi_submit_log
  where user_id = v_user_id
  for update;
  if v_last is not null and v_last > now() - interval '15 seconds' then
    return 0;
  end if;
  insert into core.wifi_submit_log as l (user_id, last_at)
  values (v_user_id, now())
  on conflict (user_id) do update set last_at = now();

  for v_ap in
    select lower(trim(elem->>'bssid')) as bssid
    from jsonb_array_elements(p_aps) elem
    limit 40
  loop
    if v_ap.bssid is null
       or v_ap.bssid !~ '^[0-9a-f]{2}(:[0-9a-f]{2}){5}$' then
      continue;
    end if;
    -- Локально-администрируемые MAC (2-й hex-символ 2/6/a/e): рандомизация,
    -- мобильные хотспоты — бесполезны и засоряют базу.
    if substring(v_ap.bssid, 2, 1) in ('2', '6', 'a', 'e') then
      continue;
    end if;

    select * into v_old
    from core.wifi_beacons
    where bssid = v_ap.bssid
    for update;

    if not found then
      insert into core.wifi_beacons (bssid, latitude, longitude, accuracy_m)
      values (
        v_ap.bssid, p_latitude, p_longitude,
        greatest(40, p_accuracy_m * 2)
      )
      on conflict (bssid) do nothing;
      v_count := v_count + 1;
      continue;
    end if;

    v_dist := core.haversine_m(
      v_old.latitude, v_old.longitude, p_latitude, p_longitude
    );

    if v_dist > 1000 then
      -- Далеко от известной позиции: либо выброс, либо точка переехала.
      if v_old.drift_count >= 2 then
        update core.wifi_beacons set
          latitude = p_latitude,
          longitude = p_longitude,
          accuracy_m = greatest(40, p_accuracy_m * 2),
          observations = 1,
          drift_count = 0,
          last_seen = now()
        where bssid = v_ap.bssid;
      else
        update core.wifi_beacons set
          drift_count = drift_count + 1,
          last_seen = now()
        where bssid = v_ap.bssid;
      end if;
    else
      update core.wifi_beacons set
        latitude = latitude + 0.3 * (p_latitude - latitude),
        longitude = longitude + 0.3 * (p_longitude - longitude),
        accuracy_m = greatest(
          30, 0.7 * accuracy_m + 0.3 * (v_dist + p_accuracy_m)
        ),
        observations = least(observations + 1, 1000000),
        drift_count = 0,
        last_seen = now()
      where bssid = v_ap.bssid;
    end if;
    v_count := v_count + 1;
  end loop;

  return v_count;
end;
$$;

-- Восстанавливает позицию по видимым точкам: RSSI-взвешенный центроид
-- по маякам с >= 2 наблюдениями, не старше 270 дней. Требует совпадения
-- минимум двух маяков (как MLS), иначе null.
create or replace function app_api_v1.wifi_resolve(p_aps jsonb)
returns jsonb
language plpgsql
stable
security definer
set search_path = ''
as $$
declare
  v_user_id uuid := (select auth.uid());
  v_result jsonb;
begin
  if v_user_id is null then
    raise exception 'Unauthorized';
  end if;
  if p_aps is null or jsonb_typeof(p_aps) <> 'array'
     or jsonb_array_length(p_aps) = 0 then
    return null;
  end if;

  with aps as (
    select distinct on (bssid) bssid, rssi
    from (
      select lower(trim(elem->>'bssid')) as bssid,
             coalesce((elem->>'rssi')::int, -75) as rssi
      from jsonb_array_elements(p_aps) elem
      limit 40
    ) raw
    where bssid ~ '^[0-9a-f]{2}(:[0-9a-f]{2}){5}$'
  ),
  matched as (
    select b.latitude, b.longitude, b.accuracy_m,
           -- dBm → линейный вес: сильный сигнал = точка ближе = больший вес.
           power(10, (least(greatest(a.rssi, -100), -30) + 100) / 20.0) as w
    from aps a
    join core.wifi_beacons b on b.bssid = a.bssid
    where b.observations >= 2
      and b.last_seen > now() - interval '270 days'
  ),
  centroid as (
    select count(*) as n,
           sum(latitude * w) / nullif(sum(w), 0) as lat,
           sum(longitude * w) / nullif(sum(w), 0) as lng
    from matched
  )
  select case
    when c.n < 2 or c.lat is null then null
    else jsonb_build_object(
      'latitude', c.lat,
      'longitude', c.lng,
      'accuracyM', greatest(
        35,
        (
          select sum(
                   (core.haversine_m(m.latitude, m.longitude, c.lat, c.lng)
                    + m.accuracy_m) * m.w
                 ) / sum(m.w)
          from matched m
        )
      ),
      'matched', c.n
    )
  end
  into v_result
  from centroid c;

  return v_result;
end;
$$;

revoke all on function app_api_v1.wifi_observations_submit(
  double precision, double precision, double precision, jsonb
) from public, anon;
revoke all on function app_api_v1.wifi_resolve(jsonb) from public, anon;

-- ── public wrappers ──────────────────────────────────────────────────────────

create or replace function public.wifi_observations_submit(
  p_latitude double precision,
  p_longitude double precision,
  p_accuracy_m double precision,
  p_aps jsonb
)
returns integer
language sql
security invoker
set search_path = ''
as $$
  select app_api_v1.wifi_observations_submit(
    p_latitude, p_longitude, p_accuracy_m, p_aps
  );
$$;

create or replace function public.wifi_resolve(p_aps jsonb)
returns jsonb
language sql
stable
security invoker
set search_path = ''
as $$
  select app_api_v1.wifi_resolve(p_aps);
$$;

revoke all on function public.wifi_observations_submit(
  double precision, double precision, double precision, jsonb
) from public, anon;
revoke all on function public.wifi_resolve(jsonb) from public, anon;

grant execute on function app_api_v1.wifi_observations_submit(
  double precision, double precision, double precision, jsonb
) to authenticated;
grant execute on function app_api_v1.wifi_resolve(jsonb) to authenticated;
grant execute on function public.wifi_observations_submit(
  double precision, double precision, double precision, jsonb
) to authenticated;
grant execute on function public.wifi_resolve(jsonb) to authenticated;

-- ── maintenance ──────────────────────────────────────────────────────────────

do $$
begin
  perform cron.schedule(
    'prune-wifi-beacons',
    '37 4 * * *',
    $cron$delete from core.wifi_beacons
      where last_seen < now() - interval '365 days'$cron$
  );
  perform cron.schedule(
    'prune-wifi-submit-log',
    '41 4 * * *',
    $cron$delete from core.wifi_submit_log
      where last_at < now() - interval '30 days'$cron$
  );
exception
  when others then
    raise notice 'pg_cron unavailable, skipping wifi prune jobs';
end;
$$;
