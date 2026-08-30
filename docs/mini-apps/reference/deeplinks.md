# Диплинки и навигация

Навигация работает в обе стороны: ссылки открывают твой мини-апп (и любую
его страницу), а из мини-аппа можно открывать экраны Mirea Ninja.

## Ссылки на твой мини-апп

Каждый апп доступен по трём видам ссылок — все они нормализуются в один и
тот же экран:

| Источник | Формат |
| --- | --- |
| Кастомная схема | `mireaninja://services/apps/<slug>/run` |
| Веб-ссылка | `https://mirea.ninja/app/services/apps/<slug>/run` |
| Пуш-уведомление | поле `route` = `/services/apps/<slug>/run` |

### Ссылка на конкретную страницу

Добавь query-параметр `page` — после загрузки апп сразу откроет внутреннюю
страницу:

```
mireaninja://services/apps/study-timer/run?page=/stats
https://mirea.ninja/app/services/apps/study-timer/run?page=/stats
```

### Ссылка на каталог и форму

```
mireaninja://services/apps              // каталог мини-аппов
mireaninja://services/apps/submit       // форма публикации
```

## Из мини-аппа — в Mirea Ninja

Экшен [`openDeepLink`](/reference/actions#opendeeplink) открывает любой
экран приложения из белого списка. Локация — это путь go_router без схемы:

```json
{ "actionType": "openDeepLink", "location": "/schedule" }
```

### Полезные локации

| Локация | Экран |
| --- | --- |
| `/schedule` | Расписание |
| `/services/map` | Карта кампуса |
| `/services/free-rooms` | Свободные аудитории |
| `/services/events` | События |
| `/services/marketplace` | Маркетплейс |
| `/services/deadlines` | Дедлайны |
| `/services/apps/<slug>/run` | Другой мини-апп |
| `/feed` | Новости |
| `/profile` | Профиль |

::: warning Белый список
Разрешены только корни `/feed`, `/schedule`, `/map`, `/services`,
`/profile`, `/search` и их подпути. Локации вне списка молча игнорируются —
это защита от увода пользователя на произвольные экраны. Легаси-путь
`/info` нормализуется в `/feed`.
:::

## Навигация внутри аппа

Мини-апп может состоять из любого числа страниц. Hosted-аппы добавляют
экраны прямо в форме публикации («Добавить экран», каждый со своим путём),
remote-аппы просто отдают JSON по нужному пути. Между страницами
перемещайся экшеном `openPage` — он работает одинаково для hosted и
remote:

```json
{ "actionType": "openPage", "path": "/details", "title": "Детали" }
```

Назад — системная кнопка или экшен `pop`; `closeMiniApp` закрывает апп
целиком.

## Между мини-аппами

Экшен `openMiniApp` открывает другой опубликованный апп — сразу на нужной
странице. Это полный аналог диплинка `…/apps/<slug>/run?page=…`, только
изнутри BDUI:

```json
{ "actionType": "openMiniApp", "slug": "campus-food", "page": "/menu" }
```

## Шэринг

Комбо для кнопки «Поделиться приложением»:

```json
{
  "actionType": "share",
  "text": "Лови мини-апп: https://mirea.ninja/app/services/apps/study-timer/run"
}
```
