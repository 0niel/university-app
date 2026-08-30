# Настройка авторизации в Supabase (code-flow)

Проект: **`ejzybbyjwtzbibrrwrli`** · URL: `https://ejzybbyjwtzbibrrwrli.supabase.co`

Выбранная схема — **вход по коду (OTP)**: в письме приходит 6-значный код,
пользователь вводит его в приложении. Ссылок/диплинк-редиректов для входа,
регистрации и сброса пароля **не требуется** — ломаться нечему.

> Через MCP настройки Auth/писем недоступны — это только дашборд. Ниже точные
> значения для вставки. Шаблоны писем уже лежат в репозитории
> (`supabase/templates/*.html`) и подключены в `supabase/config.toml`, так что
> их можно либо вставить в дашборд вручную, либо запушить через
> `supabase config push`.

---

## 1. Authentication → Providers → Email

Открыть: `…/project/ejzybbyjwtzbibrrwrli/auth/providers`

- **Email** — включён (Enable Email provider: ON).
- **Confirm email** — **ON**. После регистрации пользователю приходит код, и он
  подтверждает почту на экране ввода кода (экран `LoginEmailConfirmationPage`).
  Без подтверждения войти по паролю нельзя.
- **Secure email change** — ON (по желанию).
- **Email OTP Expiration** — `3600` секунд (1 час, дефолт ок) или меньше для
  большей безопасности, напр. `600`.
- **Email OTP Length** — `6`.

Открыть: `…/auth/providers` → **Anonymous sign-ins**

- **Allow anonymous sign-ins** — можно **OFF**: кнопку «Войти как гость» убрали
  из UI, гостевой вход больше не вызывается. (Если планируешь вернуть — оставь ON.)

---

## 2. Authentication → URL Configuration

Открыть: `…/project/ejzybbyjwtzbibrrwrli/auth/url-configuration`

При code-flow **redirect не используется** для писем. Заполняем только для порядка
и на будущее (magic link / OAuth):

- **Site URL:**
  ```
  https://mirea.ninja
  ```
- **Redirect URLs** (Add URL, по одной) — опционально, понадобятся только если
  позже включишь magic link или OAuth-провайдеров:
  ```
  mireaninja://login-callback
  https://mirea.ninja/app/**
  ```

---

## 3. Authentication → Email Templates

Открыть: `…/project/ejzybbyjwtzbibrrwrli/auth/templates`

Для каждого шаблона вставь **Subject** и **Message body (HTML)** из файла. Тело —
содержимое соответствующего `.html` (показывает код через `{{ .Token }}`).

| Шаблон в дашборде     | Subject                                  | HTML из файла                         |
|-----------------------|------------------------------------------|---------------------------------------|
| **Magic Link**        | `Код для входа в Mirea Ninja`            | `supabase/templates/magic_link.html`  |
| **Confirm signup**    | `Подтверждение регистрации в Mirea Ninja`| `supabase/templates/confirmation.html`|
| **Reset Password**    | `Сброс пароля в Mirea Ninja`             | `supabase/templates/recovery.html`    |

Почему именно так:
- **Email OTP делит реализацию с Magic Link** — чтобы письмо входа содержало
  код, а не ссылку, в шаблоне **Magic Link** должен быть `{{ .Token }}`.
- Новым пользователям (`signInWithOtp` с `shouldCreateUser: true`) уходит
  **Confirm signup** — тоже с `{{ .Token }}`.
- Сброс пароля (`resetPasswordForEmail`) использует **Reset Password**.

> Не используй `{{ .ConfirmationURL }}` / `{{ .TokenHash }}` — это для
> ссылочного (link) сценария, а мы на кодах.

---

## 4. Что уже сделано в коде приложения

- **Фикс бага «вход создаёт аккаунт»**: вход по коду больше не создаёт
  пользователя (`signInWithOtp(shouldCreateUser: false)`). Раньше попытка войти по
  не-зарегистрированному email молча создавала недо-аккаунт (без пароля,
  неподтверждённый), который потом ломал регистрацию.
- **Подтверждение регистрации кодом**: после `signUp` приложение ведёт на экран
  ввода кода (`LoginEmailConfirmationPage`), который проверяет код через
  `verifyOTP(type: signup)` (есть фолбэк email→signup, поэтому один экран
  обслуживает и вход по коду, и подтверждение регистрации).
- **Фикс «застревания» после входа по коду**: роутер теперь уводит
  залогиненного пользователя с любого экрана auth-флоу на `/feed`.
- Шаблоны писем — в `supabase/templates/`, подключены в `config.toml`
  (`enable_confirmations = true`).

Действующие flow в приложении:
- Регистрация — `signUp` → экран кода → `verifyOTP(type: signup)` → вход.
- Вход по email+паролю — `signInWithPassword` (требует подтверждённую почту).
- Вход по коду (существующие) — `signInWithOtp(shouldCreateUser: false)` → `verifyOTP(type: email)`.
- Сброс пароля по коду — `resetPasswordForEmail` → `verifyOTP(type: recovery)` → `updateUser`.

> ⚠️ Порядок важен: код приложения и тумблер **Confirm email = ON** в дашборде
> должны совпадать. Иначе при OFF `signUp` сразу логинит, и экран кода окажется
> лишним (роутер всё равно уведёт на `/feed`, но письма с кодом не будет).

---

## (Опционально) Magic link вместо кода

Если позже решишь делать вход по ссылке в один тап — это отдельная задача:
зарегистрировать диплинк на iOS (сейчас нет, только `ninja.mirea.mireaapp`),
внести Redirect URLs (шаг 2), передавать `emailRedirectTo`, обрабатывать сессию
из ссылки (PKCE). Скажи — сделаю.
