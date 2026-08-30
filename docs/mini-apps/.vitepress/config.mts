import { defineConfig } from 'vitepress'

export default defineConfig({
  lang: 'ru-RU',
  title: 'Mini Apps',
  description:
    'Платформа мини-приложений Mirea Ninja — документация для разработчиков',
  head: [
    ['meta', { name: 'theme-color', content: '#7c5cff' }],
    ['link', { rel: 'preconnect', href: 'https://fonts.googleapis.com' }],
    [
      'link',
      { rel: 'preconnect', href: 'https://fonts.gstatic.com', crossorigin: '' },
    ],
    [
      'link',
      {
        rel: 'stylesheet',
        href:
          'https://fonts.googleapis.com/css2?family=Geist:wght@400;500;600;700&family=Geist+Mono:wght@400;500;600&display=swap',
      },
    ],
  ],
  themeConfig: {
    siteTitle: '🥷 Mini Apps',
    nav: [
      { text: 'Старт', link: '/guide/quickstart' },
      { text: 'Справочник', link: '/reference/widgets' },
      { text: 'Бэкенд', link: '/reference/backend' },
    ],
    sidebar: [
      {
        text: 'Начало',
        items: [
          { text: 'Быстрый старт', link: '/guide/quickstart' },
          { text: 'Публикация и модерация', link: '/guide/publishing' },
        ],
      },
      {
        text: 'Справочник',
        items: [
          { text: 'Виджеты', link: '/reference/widgets' },
          { text: 'Экшены', link: '/reference/actions' },
          { text: 'Логика и выражения', link: '/reference/logic' },
          { text: 'Возможности устройства', link: '/reference/device' },
          { text: 'Состояние и хранилище', link: '/reference/state-storage' },
          { text: 'Диплинки и навигация', link: '/reference/deeplinks' },
        ],
      },
      {
        text: 'Бэкенд',
        items: [
          { text: 'Свой сервер и прокси', link: '/reference/backend' },
          { text: 'Деплой на Yandex Cloud', link: '/reference/yandex-deploy' },
          { text: 'HTTP API: деплой и пуши', link: '/reference/http-api' },
        ],
      },
    ],
    search: {
      provider: 'local',
      options: {
        translations: {
          button: { buttonText: 'Поиск', buttonAriaLabel: 'Поиск' },
          modal: {
            noResultsText: 'Ничего не нашлось',
            resetButtonTitle: 'Сбросить',
            footer: {
              selectText: 'выбрать',
              navigateText: 'навигация',
              closeText: 'закрыть',
            },
          },
        },
      },
    },
    outline: { label: 'На этой странице', level: [2, 3] },
    docFooter: { prev: 'Назад', next: 'Дальше' },
    darkModeSwitchLabel: 'Тема',
    sidebarMenuLabel: 'Меню',
    returnToTopLabel: 'Наверх',
    lastUpdated: { text: 'Обновлено' },
    footer: {
      message: 'Работает на Stac',
      copyright: 'Mirea Ninja Mini Apps Platform',
    },
  },
})
