insert into core.organizations (id, name, timezone)
values ('mirea', 'РТУ МИРЭА', 'Europe/Moscow')
on conflict (id) do nothing;

insert into core.organization_community_catalogs (
  organization_id,
  default_locale,
  suggestion_url
)
select 'mirea', 'ru', 'https://t.me/mirea_ninja_chat'
where exists (select 1 from core.organizations where id = 'mirea')
on conflict (organization_id) do nothing;

insert into core.organization_community_sections (
  organization_id,
  key,
  title,
  emoji,
  sort_order
)
select 'mirea', seed.key, seed.title, seed.emoji, seed.sort_order
from (
  values
    ('general', 'Общие сообщества', '💬', 0),
    ('institutes', 'Институты и кафедры', '🏛️', 10),
    ('competitive', 'Спортивное программирование', '💻', 20),
    ('sports', 'Спорт', '⚽', 30),
    ('creative', 'Творчество', '🎨', 40),
    ('science', 'Наука и технологии', '🔬', 50),
    ('volunteering', 'Волонтёрство', '🤝', 60),
    ('entertainment', 'Досуг', '🎮', 70)
) as seed(key, title, emoji, sort_order)
where exists (select 1 from core.organizations where id = 'mirea')
on conflict (organization_id, key) do nothing;

insert into core.organization_communities (
  organization_id,
  section_id,
  slug,
  title,
  description,
  destination_url,
  logo_url,
  platform,
  member_count,
  is_featured,
  is_official,
  sort_order
)
select
  'mirea',
  section.id,
  seed.slug,
  seed.title,
  seed.description,
  seed.destination_url,
  seed.logo_url,
  seed.platform,
  seed.member_count,
  seed.is_featured,
  seed.is_official,
  seed.sort_order
from (
  values
    (
      'general',
      'mirea-ninja',
      'Mirea Ninja',
      'Самый популярный неофициальный чат студентов',
      'https://t.me/mirea_ninja_chat',
      'https://sun9-65.userapi.com/impg/bvdpBQYk7glRfRkmsR-GRMMWwK2Rw3lDIuGjzQ/l4qMdaR-HBA.jpg?size=1200x1200&quality=95&sign=427e8060dea18a64efc92e8ae7ab57da&type=album',
      'telegram',
      15000,
      true,
      false,
      0
    ),
    (
      'general',
      'mirea-applicants',
      'РТУ МИРЭА Абитуриенты',
      'Официальный чат для поступающих в университет',
      'https://t.me/mirea_applicants',
      'https://sun9-65.userapi.com/impg/bvdpBQYk7glRfRkmsR-GRMMWwK2Rw3lDIuGjzQ/l4qMdaR-HBA.jpg?size=1200x1200&quality=95&sign=427e8060dea18a64efc92e8ae7ab57da&type=album',
      'telegram',
      8500,
      false,
      true,
      10
    ),
    (
      'general',
      'mirea-news',
      'РТУ МИРЭА Новости',
      'Официальный канал новостей университета',
      'https://t.me/mirea_news',
      'https://sun9-65.userapi.com/impg/bvdpBQYk7glRfRkmsR-GRMMWwK2Rw3lDIuGjzQ/l4qMdaR-HBA.jpg?size=1200x1200&quality=95&sign=427e8060dea18a64efc92e8ae7ab57da&type=album',
      'telegram',
      12000,
      true,
      true,
      20
    ),
    (
      'institutes',
      'kis',
      'Кафедра корпоративных информационных систем',
      'Кафедра корпоративных информационных систем',
      'https://vk.com/kis_it_mirea',
      'https://sun9-1.userapi.com/impg/JSVkx8BMQSKU2IR27bnX_yajk4Bvb_HMf530gg/QkoTZdc_2mM.jpg?size=500x500&quality=95&sign=6bfc16cfff772b175c927aae3e480aa8&type=album',
      'vk',
      3500,
      true,
      false,
      0
    ),
    (
      'institutes',
      'ippo',
      'Кафедра инструментального и прикладного программного обеспечения',
      'Кафедра инструментального и прикладного программного обеспечения',
      'https://vk.com/ippo_it',
      'https://sun9-21.userapi.com/impg/Sk3d5lpXhoaiHj3QZz1tt8HQKPcEaoE27WgZAw/nig2y-fcRkU.jpg?size=500x600&quality=95&sign=fa26df3e73f398f91d10029134156e5d&type=album',
      'vk',
      2800,
      false,
      false,
      10
    ),
    (
      'institutes',
      'iit',
      'ИИТ РТУ МИРЭА',
      'Институт информационных технологий',
      'https://vk.com/iit_mirea',
      'https://sun9-21.userapi.com/impg/Sk3d5lpXhoaiHj3QZz1tt8HQKPcEaoE27WgZAw/nig2y-fcRkU.jpg?size=500x600&quality=95&sign=fa26df3e73f398f91d10029134156e5d&type=album',
      'vk',
      4200,
      false,
      false,
      20
    ),
    (
      'institutes',
      'iri',
      'ИРИ РТУ МИРЭА',
      'Институт радиотехники и информатики',
      'https://vk.com/iri_mirea',
      'https://sun9-21.userapi.com/impg/Sk3d5lpXhoaiHj3QZz1tt8HQKPcEaoE27WgZAw/nig2y-fcRkU.jpg?size=500x600&quality=95&sign=fa26df3e73f398f91d10029134156e5d&type=album',
      'vk',
      3100,
      false,
      false,
      30
    ),
    (
      'competitive',
      'cp-mirea',
      'Спортивное программирование МИРЭА',
      'Соревнования и тренировки по программированию',
      'https://t.me/cp_mirea',
      'https://sun9-55.userapi.com/impg/J-OyvW6fp0ZtQ3mJKhI-OxDwPgQbCLhz_PA7bQ/CicJTono2Wk.jpg?size=1920x1920&quality=96&sign=3d4ffbf9a95a4550f203c6909a1af7cf&type=album',
      'telegram',
      1200,
      true,
      false,
      0
    ),
    (
      'competitive',
      'codeforces-mirea',
      'Codeforces MIREA',
      'Участники соревнований по программированию',
      'https://t.me/codeforces_mirea',
      'https://sun9-55.userapi.com/impg/J-OyvW6fp0ZtQ3mJKhI-OxDwPgQbCLhz_PA7bQ/CicJTono2Wk.jpg?size=1920x1920&quality=96&sign=3d4ffbf9a95a4550f203c6909a1af7cf&type=album',
      'telegram',
      850,
      false,
      false,
      10
    ),
    (
      'sports',
      'sport-mirea',
      'Спорт РТУ МИРЭА',
      'Спортивный клуб университета и новости',
      'https://vk.com/sport_mirea',
      'https://sun9-1.userapi.com/impg/JSVkx8BMQSKU2IR27bnX_yajk4Bvb_HMf530gg/QkoTZdc_2mM.jpg?size=500x500&quality=95&sign=6bfc16cfff772b175c927aae3e480aa8&type=album',
      'vk',
      5600,
      false,
      false,
      0
    ),
    (
      'sports',
      'basketball-mirea',
      'Баскетбол МИРЭА',
      'Баскетбольная команда университета',
      'https://vk.com/basketball_mirea',
      'https://sun9-1.userapi.com/impg/JSVkx8BMQSKU2IR27bnX_yajk4Bvb_HMf530gg/QkoTZdc_2mM.jpg?size=500x500&quality=95&sign=6bfc16cfff772b175c927aae3e480aa8&type=album',
      'vk',
      1400,
      false,
      false,
      10
    ),
    (
      'sports',
      'football-mirea',
      'Футбол МИРЭА',
      'Футбольная команда и турниры',
      'https://vk.com/football_mirea',
      'https://sun9-1.userapi.com/impg/JSVkx8BMQSKU2IR27bnX_yajk4Bvb_HMf530gg/QkoTZdc_2mM.jpg?size=500x500&quality=95&sign=6bfc16cfff772b175c927aae3e480aa8&type=album',
      'vk',
      2100,
      false,
      false,
      20
    ),
    (
      'creative',
      'kvn-mirea',
      'КВН РТУ МИРЭА',
      'Лига КВН университета',
      'https://vk.com/kvn_mirea',
      'https://sun9-21.userapi.com/impg/Sk3d5lpXhoaiHj3QZz1tt8HQKPcEaoE27WgZAw/nig2y-fcRkU.jpg?size=500x600&quality=95&sign=fa26df3e73f398f91d10029134156e5d&type=album',
      'vk',
      3200,
      false,
      false,
      0
    ),
    (
      'creative',
      'media-mirea',
      'Медиацентр МИРЭА',
      'Студенческое медиа и творческие проекты',
      'https://vk.com/media_mirea',
      'https://sun9-21.userapi.com/impg/Sk3d5lpXhoaiHj3QZz1tt8HQKPcEaoE27WgZAw/nig2y-fcRkU.jpg?size=500x600&quality=95&sign=fa26df3e73f398f91d10029134156e5d&type=album',
      'vk',
      1900,
      false,
      false,
      10
    ),
    (
      'creative',
      'dance-mirea',
      'Танцы МИРЭА',
      'Танцевальная студия университета',
      'https://vk.com/dance_mirea',
      'https://sun9-21.userapi.com/impg/Sk3d5lpXhoaiHj3QZz1tt8HQKPcEaoE27WgZAw/nig2y-fcRkU.jpg?size=500x600&quality=95&sign=fa26df3e73f398f91d10029134156e5d&type=album',
      'vk',
      1600,
      false,
      false,
      20
    ),
    (
      'science',
      'science-mirea',
      'Наука МИРЭА',
      'Научные проекты и исследования студентов',
      'https://vk.com/science_mirea',
      'https://sun9-55.userapi.com/impg/J-OyvW6fp0ZtQ3mJKhI-OxDwPgQbCLhz_PA7bQ/CicJTono2Wk.jpg?size=1920x1920&quality=96&sign=3d4ffbf9a95a4550f203c6909a1af7cf&type=album',
      'vk',
      2400,
      false,
      false,
      0
    ),
    (
      'science',
      'robotics-mirea',
      'Робототехника МИРЭА',
      'Команда по робототехнике и автоматизации',
      'https://vk.com/robotics_mirea',
      'https://sun9-55.userapi.com/impg/J-OyvW6fp0ZtQ3mJKhI-OxDwPgQbCLhz_PA7bQ/CicJTono2Wk.jpg?size=1920x1920&quality=96&sign=3d4ffbf9a95a4550f203c6909a1af7cf&type=album',
      'vk',
      1100,
      false,
      false,
      10
    ),
    (
      'volunteering',
      'volunteers-mirea',
      'Волонтёры МИРЭА',
      'Студенческое волонтёрское движение',
      'https://vk.com/volunteers_mirea',
      'https://sun9-1.userapi.com/impg/JSVkx8BMQSKU2IR27bnX_yajk4Bvb_HMf530gg/QkoTZdc_2mM.jpg?size=500x500&quality=95&sign=6bfc16cfff772b175c927aae3e480aa8&type=album',
      'vk',
      2700,
      false,
      false,
      0
    ),
    (
      'entertainment',
      'esports-mirea',
      'Киберспорт МИРЭА',
      'Киберспортивная команда и турниры',
      'https://vk.com/esports_mirea',
      'https://sun9-65.userapi.com/impg/bvdpBQYk7glRfRkmsR-GRMMWwK2Rw3lDIuGjzQ/l4qMdaR-HBA.jpg?size=1200x1200&quality=95&sign=427e8060dea18a64efc92e8ae7ab57da&type=album',
      'vk',
      3800,
      false,
      false,
      0
    ),
    (
      'entertainment',
      'boardgames-mirea',
      'Настолки МИРЭА',
      'Клуб настольных игр',
      'https://vk.com/boardgames_mirea',
      'https://sun9-65.userapi.com/impg/bvdpBQYk7glRfRkmsR-GRMMWwK2Rw3lDIuGjzQ/l4qMdaR-HBA.jpg?size=1200x1200&quality=95&sign=427e8060dea18a64efc92e8ae7ab57da&type=album',
      'vk',
      1500,
      false,
      false,
      10
    )
) as seed(
  section_key,
  slug,
  title,
  description,
  destination_url,
  logo_url,
  platform,
  member_count,
  is_featured,
  is_official,
  sort_order
)
join core.organization_community_sections section
  on section.organization_id = 'mirea'
  and section.key = seed.section_key
where exists (select 1 from core.organizations where id = 'mirea')
on conflict (organization_id, slug) do nothing;
