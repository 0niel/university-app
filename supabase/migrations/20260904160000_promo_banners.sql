-- Backend-configurable promo banners (home + schedule placements) with a
-- native details page described by a JSON document, per-locale overrides and
-- lightweight engagement events. Content lives in core.*, clients only talk
-- to the app_api_v1 functions behind thin public wrappers.

create table core.promo_banners (
  id uuid primary key default extensions.gen_random_uuid(),
  organization_id text not null references core.organizations(id)
    on delete cascade,
  slug text not null,
  is_active boolean not null default true,
  starts_at timestamptz,
  ends_at timestamptz,
  placements text[] not null default array['home', 'schedule'],
  home_slot text not null default 'after_today',
  priority integer not null default 0,
  version integer not null default 1,
  style text not null default 'solid',
  accent_color text not null default '#FC3F1D',
  emoji text not null default '🛵',
  kicker text,
  title text not null,
  subtitle text,
  cta_label text not null default 'Подробнее',
  cta_url text not null,
  register_label text not null default 'Зарегистрироваться',
  contact_telegram text,
  allow_snooze boolean not null default true,
  snooze_hours integer not null default 72,
  allow_hide_forever boolean not null default true,
  details jsonb not null default '{}'::jsonb,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  constraint promo_banners_slug_valid
    check (slug ~ '^[a-z][a-z0-9_-]{0,63}$'),
  constraint promo_banners_placements_valid
    check (
      cardinality(placements) > 0
      and placements <@ array['home', 'schedule']
    ),
  constraint promo_banners_home_slot_valid
    check (home_slot in ('top', 'after_today', 'bottom')),
  constraint promo_banners_style_valid
    check (style in ('solid', 'tint')),
  constraint promo_banners_accent_valid
    check (accent_color ~ '^#[0-9A-Fa-f]{6}$'),
  constraint promo_banners_emoji_valid
    check (char_length(emoji) between 1 and 16),
  constraint promo_banners_kicker_valid
    check (kicker is null or char_length(btrim(kicker)) between 1 and 60),
  constraint promo_banners_title_valid
    check (char_length(btrim(title)) between 1 and 120),
  constraint promo_banners_subtitle_valid
    check (subtitle is null or char_length(subtitle) <= 240),
  constraint promo_banners_cta_label_valid
    check (char_length(btrim(cta_label)) between 1 and 40),
  constraint promo_banners_register_label_valid
    check (char_length(btrim(register_label)) between 1 and 40),
  constraint promo_banners_cta_url_valid
    check (
      cta_url ~* '^https://[^/@[:space:]]+(/[^[:space:]]*)?$'
      and cta_url !~* '^https://[^/]*@'
    ),
  constraint promo_banners_contact_telegram_valid
    check (contact_telegram is null or contact_telegram ~ '^[A-Za-z0-9_]{5,32}$'),
  constraint promo_banners_snooze_hours_valid
    check (snooze_hours between 1 and 720),
  constraint promo_banners_version_valid
    check (version >= 1),
  constraint promo_banners_details_valid
    check (jsonb_typeof(details) = 'object' and pg_column_size(details) <= 262144),
  constraint promo_banners_window_valid
    check (starts_at is null or ends_at is null or starts_at < ends_at),
  unique (organization_id, slug)
);

create index promo_banners_active_idx
on core.promo_banners (organization_id, is_active, priority desc, slug);

create trigger set_promo_banners_updated_at
before update on core.promo_banners
for each row execute function core.set_updated_at();

create table core.promo_banner_translations (
  banner_id uuid not null references core.promo_banners(id) on delete cascade,
  locale text not null,
  kicker text,
  title text,
  subtitle text,
  cta_label text,
  register_label text,
  details jsonb,
  primary key (banner_id, locale),
  constraint promo_banner_translations_locale_valid
    check (locale ~ '^[a-z]{2,3}(?:-[A-Z]{2})?$'),
  constraint promo_banner_translations_title_valid
    check (title is null or char_length(btrim(title)) between 1 and 120),
  constraint promo_banner_translations_details_valid
    check (details is null or jsonb_typeof(details) = 'object')
);

create table core.promo_banner_events (
  id bigint generated always as identity primary key,
  banner_id uuid not null references core.promo_banners(id) on delete cascade,
  user_id uuid references auth.users(id) on delete set null,
  event text not null,
  placement text,
  created_at timestamptz not null default now(),
  constraint promo_banner_events_event_valid
    check (event in (
      'impression', 'open', 'register', 'contact', 'link', 'snooze', 'hide'
    )),
  constraint promo_banner_events_placement_valid
    check (placement is null or placement in ('home', 'schedule', 'details'))
);

create index promo_banner_events_banner_idx
on core.promo_banner_events (banner_id, event, created_at desc);

alter table core.promo_banners enable row level security;
alter table core.promo_banner_translations enable row level security;
alter table core.promo_banner_events enable row level security;
revoke all on core.promo_banners from anon, authenticated;
revoke all on core.promo_banner_translations from anon, authenticated;
revoke all on core.promo_banner_events from anon, authenticated;

create or replace view core.promo_banner_stats
with (security_invoker = true) as
select
  b.organization_id,
  b.slug,
  e.event,
  count(*) as total,
  count(distinct e.user_id) as unique_users,
  min(e.created_at) as first_at,
  max(e.created_at) as last_at
from core.promo_banner_events e
join core.promo_banners b on b.id = e.banner_id
group by b.organization_id, b.slug, e.event;

create or replace function app_api_v1.get_promo_banners(
  p_organization_id text,
  p_locale text default null
)
returns jsonb
language sql
stable
security definer
set search_path = ''
as $$
  select coalesce(
    (
      select jsonb_agg(
        jsonb_build_object(
          'id', banner.id,
          'slug', banner.slug,
          'placements', to_jsonb(banner.placements),
          'homeSlot', banner.home_slot,
          'priority', banner.priority,
          'version', banner.version,
          'style', banner.style,
          'accentColor', banner.accent_color,
          'emoji', banner.emoji,
          'kicker', coalesce(translation.kicker, banner.kicker),
          'title', coalesce(translation.title, banner.title),
          'subtitle', coalesce(translation.subtitle, banner.subtitle),
          'ctaLabel', coalesce(translation.cta_label, banner.cta_label),
          'ctaUrl', banner.cta_url,
          'registerLabel', coalesce(
            translation.register_label,
            banner.register_label
          ),
          'contactTelegram', banner.contact_telegram,
          'allowSnooze', banner.allow_snooze,
          'snoozeHours', banner.snooze_hours,
          'allowHideForever', banner.allow_hide_forever,
          'details', coalesce(translation.details, banner.details)
        )
        order by banner.priority desc, banner.slug
      )
      from core.promo_banners banner
      left join lateral (
        select
          t.kicker, t.title, t.subtitle, t.cta_label, t.register_label,
          t.details
        from core.promo_banner_translations t
        where t.banner_id = banner.id
          and t.locale = nullif(btrim(p_locale), '')
        limit 1
      ) translation on true
      where banner.organization_id = p_organization_id
        and banner.is_active
        and (banner.starts_at is null or banner.starts_at <= now())
        and (banner.ends_at is null or banner.ends_at > now())
    ),
    '[]'::jsonb
  );
$$;

create or replace function app_api_v1.track_promo_banner_event(
  p_banner_id uuid,
  p_event text,
  p_placement text default null
)
returns void
language plpgsql
security definer
set search_path = ''
as $$
declare
  v_user_id uuid := (select auth.uid());
begin
  if v_user_id is null then
    return;
  end if;
  if p_event not in (
    'impression', 'open', 'register', 'contact', 'link', 'snooze', 'hide'
  ) then
    raise exception 'Unknown promo event' using errcode = '22023';
  end if;
  if not exists (
    select 1 from core.promo_banners b where b.id = p_banner_id
  ) then
    return;
  end if;
  perform core.enforce_rate_limit('promo_banner_event', 240, interval '1 hour');
  insert into core.promo_banner_events (banner_id, user_id, event, placement)
  values (
    p_banner_id,
    v_user_id,
    p_event,
    case
      when p_placement in ('home', 'schedule', 'details') then p_placement
      else null
    end
  );
end;
$$;

create or replace function public.get_promo_banners(
  p_organization_id text,
  p_locale text default null
)
returns jsonb
language sql
stable
security definer
set search_path = ''
as $$
  select app_api_v1.get_promo_banners(p_organization_id, p_locale);
$$;

create or replace function public.track_promo_banner_event(
  p_banner_id uuid,
  p_event text,
  p_placement text default null
)
returns void
language sql
security definer
set search_path = ''
as $$
  select app_api_v1.track_promo_banner_event(p_banner_id, p_event, p_placement);
$$;

revoke all on function public.get_promo_banners(text, text) from public;
grant execute on function public.get_promo_banners(text, text)
to anon, authenticated, service_role;

revoke all on function public.track_promo_banner_event(uuid, text, text)
from public;
grant execute on function public.track_promo_banner_event(uuid, text, text)
to authenticated, service_role;

insert into core.promo_banners (
  organization_id,
  slug,
  placements,
  home_slot,
  priority,
  style,
  accent_color,
  emoji,
  kicker,
  title,
  subtitle,
  cta_label,
  cta_url,
  register_label,
  contact_telegram,
  snooze_hours,
  details
) values (
  'mirea',
  'yandex-eda-courier',
  array['home', 'schedule'],
  'after_today',
  100,
  'solid',
  '#FC3F1D',
  '🛵',
  'Подработка для студентов',
  'Курьер Яндекс Еды: сам выбираешь, когда работать',
  'Выплаты каждый день, старт без опыта. Регистрация — 15 минут.',
  'Как заработать',
  'https://reg.eda.yandex.ru/?advertisement_campaign=forms_for_agents&user_invite_code=d93c6393371546e2854e955cd4daeba0&utm_content=blank',
  'Зарегистрироваться',
  'i_am_oniel',
  72,
  $json$
{
  "hero": {
    "badge": "Партнёрская программа Яндекс Еды",
    "title": "Подработка между парами — на своих условиях",
    "subtitle": "Доставляй заказы пешком, на велосипеде или самокате. Слоты от 1 часа, деньги каждый день, никакого начальника.",
    "tags": ["Без опыта", "От 16 лет", "Гибкий график", "Выплаты каждый день"]
  },
  "sections": [
    {
      "type": "facts",
      "title": "Почему это удобно студенту",
      "items": [
        {"emoji": "🕒", "label": "Слот от 1 часа", "value": "Вышел между парами или вечером — сам решаешь, когда и сколько."},
        {"emoji": "💳", "label": "Деньги каждый день", "value": "С Картой Про заработок приходит ежедневно, включая выходные."},
        {"emoji": "🚶", "label": "Пешком или на велике", "value": "Транспорт не нужен. На своём велосипеде заказы прилетают быстрее."},
        {"emoji": "🎓", "label": "Совместимо с учёбой", "value": "Самозанятость не мешает ни учёбе, ни официальной работе."}
      ]
    },
    {
      "type": "facts",
      "title": "Из чего складывается доход",
      "items": [
        {"emoji": "📍", "label": "Оплата за километр", "value": "Каждый заказ считается по дистанции маршрута."},
        {"emoji": "📦", "label": "Базовая стоимость заказа", "value": "Плюс надбавка за сложность и спрос — в часы пик заказ стоит дороже."},
        {"emoji": "⏱", "label": "Платное ожидание", "value": "Если ресторан задерживает — 3 ₽ за минуту с 8-й по 28-ю минуту."},
        {"emoji": "🛡", "label": "Минималка в плановом слоте", "value": "В плановом слоте сервис гарантирует доход за час и доплачивает до него."},
        {"emoji": "💸", "label": "Чаевые", "value": "Клиент оставляет чаевые в приложении — они целиком твои."}
      ]
    },
    {
      "type": "steps",
      "title": "Как начать",
      "items": [
        {"title": "Зарегистрируйся по ссылке", "text": "Нажми «Зарегистрироваться» внизу — анкета занимает около 15 минут."},
        {"title": "Оформи самозанятость", "text": "Приложение «Мой налог» от ФНС, вид деятельности «Курьерская доставка». Налог 4–6 % удерживается автоматически."},
        {"title": "Пройди активацию", "text": "Приходишь в курьерский центр, получаешь термосумку и форму. Первый слот — в тот же день."},
        {"title": "Выбирай слоты и зарабатывай", "text": "Свободный слот — в любое время от 1 часа. Плановый — с гарантированной минималкой."}
      ]
    },
    {
      "type": "checklist",
      "title": "Что нужно для старта",
      "items": [
        "Паспорт РФ или другой страны",
        "СНИЛС и ИНН",
        "Подтверждённая учётная запись Госуслуг или Мос.ру",
        "Смартфон на Android 8+ или iOS 15.5+ с Google Play / App Store",
        "Для Москвы — регистрация в КИС «АРТ» через Госуслуги",
        "Иностранным гражданам — нотариальный перевод паспорта и миграционная карта"
      ]
    },
    {
      "type": "faq",
      "title": "Частые вопросы",
      "items": [
        {"q": "Сколько я заработаю?", "a": "Фиксированной суммы нет: доход зависит от города, часов и количества заказов. Посмотри ориентир в калькуляторе Яндекс Еды по ссылке ниже."},
        {"q": "Это официальное трудоустройство?", "a": "Нет, это самозанятость или партнёрский договор. Зато никакого графика сверху — и можно совмещать с учёбой и работой."},
        {"q": "Нужны права или транспорт?", "a": "Пешим и велокурьерам права не нужны. Транспорт тоже не обязателен, но на своём велосипеде выше приоритет на заказы."},
        {"q": "Можно с 16 лет?", "a": "Да, с 16 до 18 лет — только по самозанятости, доставки с 8:00 до 21:00 и не больше 7 часов в день."},
        {"q": "А если я новичок и ошибусь?", "a": "На первых 7 слотах корректировки не начисляются — это период обкатки. Ошибся — укажут, но не оштрафуют."},
        {"q": "Что со страховкой?", "a": "На слоте действует бесплатное страхование: покрывает травмы и переломы на территории РФ."},
        {"q": "Можно приглашать друзей?", "a": "Да, внутри Яндекс Про есть программа «Пригласите друга» — бонус за каждого приведённого курьера."}
      ]
    },
    {
      "type": "links",
      "title": "Полезное",
      "items": [
        {"label": "Калькулятор дохода курьера", "url": "https://eda.yandex.ru/partner/rabota#calculator"},
        {"label": "Условия для курьеров на сайте Яндекс Еды", "url": "https://eda.yandex.ru/partner/rabota"}
      ]
    }
  ],
  "contact": {
    "title": "Остались вопросы?",
    "subtitle": "Напишу, помогу с регистрацией и оформлением самозанятости."
  },
  "footnote": "Партнёрская программа Яндекс Еды. Доход не фиксирован и зависит от города, часов и заказов. Регистрация по ссылке бесплатна и ни к чему не обязывает."
}
  $json$::jsonb
);
