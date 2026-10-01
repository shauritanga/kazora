# Kazora — Plan of Record

**Discover. Connect. Live.** A two-sided marketplace connecting landlords and tenants in Tanzania.

- Tenants browse **verified** residential and commercial properties (rooms, apartments, houses, offices, shops).
- Tenants pay **5,000 Tsh/month** to unlock **5 landlord contact reveals per month** (extra credits: 1,000 Tsh each).
- Landlords list properties **for free**.

This file is the single source of truth. Read it before starting work; update the progress tracker as you go.

---

## 1. Monorepo layout

| Path | What | Stack | Status |
|---|---|---|---|
| `apps/mobile` | Tenant + landlord app | Flutter ≥ 3.47, Riverpod, go_router, dio | Scaffold complete, analyzer clean |
| `apps/api` | Public REST API | NestJS, PostgreSQL 16, Redis 7, Node ≥ 20 | Controller scaffold, stub services |
| `apps/admin` | Admin panel (moderation, users, payments, stats) | React, Vite, TypeScript | Scaffold only |
| `docs/PLAN.md` | This file | — | — |

Infrastructure: `docker-compose.yml` at repo root brings up Postgres 16 + Redis 7.

---

## 2. Key decisions

| # | Decision | Rationale |
|---|---|---|
| D1 | Mobile: clean architecture, `domain` / `data` / `presentation` per feature | Testable use cases, swappable data sources, consistent feature layout |
| D2 | Mobile state: Riverpod (`flutter_riverpod`) | DI + reactive state without boilerplate |
| D3 | Mobile routing: `go_router` | Declarative, deep-link ready |
| D4 | Mobile HTTP: `dio` with a single `ApiClient` | Interceptors, timeouts, one place to map errors to `Failure` types |
| D5 | i18n: `flutter_localizations` + `intl` with `.arb` files (`lib/l10n/app_en.arb`, `app_sw.arb`), generated `AppLocalizations` | Correct plurals, locale-aware date/number formatting, and a documented path for adding languages. **All UI strings must go through `AppLocalizations` — no hardcoded strings in widgets** |
| D6 | Payments: mobile money via a **gateway adapter** in the API (`payments` module) | Operator logic (Tigo/Airtel/Vodacom STK push) never leaks into features |
| D7 | Auth: phone + OTP | No passwords; matches mobile-money identity model in Tanzania |
| D8 | API: NestJS modular monolith (modules: auth, properties, favorites, subscriptions, credits, payments, reports, admin) | One deployable, clear module boundaries, easy to split later |
| D9 | Verification: properties are `verified` only after admin approval | Trust is the product; moderation queue in admin panel |
| D10 | Contact reveal is a metered action (credits) | The monetization core; enforced server-side, never in the client |
| D11 | API data layer: TypeORM (`@nestjs/typeorm` + `pg`) + `ioredis` + `@nestjs/jwt` + `class-validator` | Standard NestJS pairing; Redis for OTP (TTL); JWT for session; validation at the boundary |
| D12 | Onboarding flow: first-run slides → role selection → phone+OTP → role-based home; **single role per account** | Role-first intent is sent at registration; dual role (tenant+landlord) is future work |

---

## 3. Business rules

| Rule | Value | Where enforced |
|---|---|---|
| Subscription price | 5,000 Tsh / month | `subscriptions` module |
| Contact credits per month | 5 | `credits` module |
| Extra credit price | 1,000 Tsh | `credits` module |
| Max listing photos | 10 | mobile `AppConfig` + API validation |
| OTP validity | 5 minutes | `auth` module |
| Landlord listing fee | Free | — |
| Reveal without credit | 402 response | `properties` module → `CreditLimitFailure` on mobile |

---

## 4. Architecture

### 4.1 Mobile (`apps/mobile`)

```
lib/
  app/            # app.dart, router/, theme/, config/
  core/           # constants, errors, extensions, network, storage, utils, widgets
  features/
    <feature>/
      domain/     # entities, repositories (contracts), usecases
      data/       # models, datasources (remote/local), repository impls
      presentation/ # providers/, screens/, widgets/
```

Features: `onboarding`, `auth`, `home`, `properties` (reference implementation),
`search`, `favorites`, `messages`, `bookings`, `notifications`, `profile`,
`landlord/{dashboard,properties,add_property,edit_property,inquiries}`.

Conventions:
- Domain layer has **no** Flutter or dio imports.
- `data` maps JSON ↔ entities; `presentation` never touches JSON.
- Errors: `Failure` sealed type (`NetworkFailure`, `ServerFailure`, `AuthorizationFailure`, `CreditLimitFailure`) mapped in `core/errors/error_handler.dart`.
- Offline: property list cached in `shared_preferences` (`LocalStorage`), fallback on network failure.
- i18n: every user-facing string lives in `lib/l10n/app_en.arb` (template) + `app_sw.arb`; access via `AppLocalizations.of(context).<key>`. After editing arb files run `flutter gen-l10n`. Locale follows the device; `supportedLocales` = [en, sw].

### 4.2 API (`apps/api`)

NestJS modules, each with controller / service / module:

| Module | Endpoints (scaffolded) |
|---|---|
| `auth` | `POST /auth/otp/request`, `POST /auth/otp/verify`, `GET /auth/me` |
| `properties` | `GET /properties`, `GET /properties/:id`, `POST /properties`, `PATCH /properties/:id`, `POST /properties/:id/contact/reveal`, `POST /properties/:id/report` |
| `favorites` | `GET /favorites`, `POST /favorites/:propertyId`, `DELETE /favorites/:propertyId`, `POST /favorites/searches` |
| `subscriptions` | `GET /subscriptions/me`, `POST /subscriptions/activate` |
| `credits` | `GET /credits/me`, `POST /credits/purchase` |
| `payments` | `POST /payments/stk-push`, `POST /payments/webhook/:gateway`, `GET /payments/history` |
| `reports` | `GET /reports`, `POST /reports/properties/:propertyId`, `PATCH /reports/:id/resolve` |
| `admin` | `GET /admin/moderation/queue`, `PATCH /admin/moderation/:propertyId/approve`, `PATCH /admin/moderation/:propertyId/reject`, `GET /admin/users`, `GET /admin/payments`, `GET /admin/stats` |

Cross-cutting: `RolesGuard` (tenant/landlord/admin), `AuditInterceptor`, `AllExceptionsFilter`.
All services are currently **stubs** — implementing real logic is Phase 2.

### 4.3 Admin (`apps/admin`)

React + Vite + TS. Screens: moderation queue (approve/reject listings), users, payments, stats. Consumes `/admin/*` endpoints.

---

## 5. Phases & progress tracker

Legend: ☐ not started · ◐ in progress · ☑ done

### Phase 1 — Foundations (mobile scaffold + API skeleton)

| Task | Status |
|---|---|
| Mobile: deps (riverpod, go_router, dio, connectivity, shared_prefs, cached_image, image_picker) | ☑ |
| Mobile: app layer (router with all routes, theme, config, environment URLs) | ☑ |
| Mobile: core layer (ApiClient, Failure mapping, LocalStorage, shared widgets) | ☑ |
| Mobile: i18n via `flutter_localizations` + `.arb` (en/sw), onboarding/auth/welcome migrated | ☑ |
| Mobile: `properties` reference feature (domain/data/presentation, cache + favorites) | ☑ |
| Mobile: all other screens scaffolded (onboarding → landlord) | ☑ |
| Mobile: `flutter analyze` clean, `flutter test` passing, `dart format` applied | ☑ |
| API: NestJS scaffold, all modules/controllers wired, guards/filters/interceptors | ☑ |
| API: docker-compose (Postgres 16 + Redis 7) | ☑ |
| Admin: Vite + React scaffold | ☑ |

### Phase 2 — Real API logic

| Task | Status |
|---|---|
| DB: TypeORM setup + `users` table (id, phone, role, timestamps) + migrations | ☐ |
| `auth`: OTP request/verify (Redis 5-min TTL, log-only in dev), find-or-create user, JWT issuance, `JwtAuthGuard` | ☐ |
| DB: remaining tables (properties, favorites, subscriptions, credits, payments, reports) | ☐ |
| `properties`: list w/ filters (type, region, price), CRUD, photo upload, verification flags | ☐ |
| `properties`: contact reveal with credit decrement (402 on empty credits) | ☐ |
| `favorites`, `subscriptions`, `credits`: real logic | ☐ |
| `storage`: `StorageService` + `LocalDiskStorage`, `POST /storage/upload`, static `/uploads/`, docker volume `kazora_uploads` | ☑ |
| `payments`: STK-push gateway adapter + webhook handling | ☐ |
| `reports` + `admin`: moderation queue, stats | ☐ |
| API tests (unit + e2e via vitest) | ☐ |

### Phase 3 — Mobile feature completion

| Task | Status |
|---|---|
| Align mobile data layer with real API contract (endpoints, DTOs, error codes) | ☐ |
| Onboarding UX: merge welcome into slides, `onboardingDone` flag, role strings → `.arb` | ☐ |
| `auth`: OTP flow wired to API, token persistence, session restore, `sessionProvider` | ☐ |
| Router: session-aware `redirect` (onboarding → role → auth → role-based home) + guard protected routes | ☐ |
| `properties`: real photos (image upload on create), region/type filter values from API | ☐ |
| `landlord`: add/edit property with photo picker, publish flow, inquiries list | ☐ |
| `favorites`: server-backed (local cache as fallback) | ☐ |
| Subscription + credits UI (pay with STK push, credit balance, purchase extras) | ☐ |
| Contact reveal flow (consume credit, reveal phone, call intent) | ☐ |
| `messages`, `bookings`, `notifications`: real implementations | ☐ |
| Complete SW/EN strings across all screens via `.arb` files (`AppLocalizations`) | ☐ |
| Error/empty/loading states per screen; offline behavior | ☐ |

### Phase 4 — Admin panel

| Task | Status |
|---|---|
| Moderation queue UI (approve/reject with reason) | ☐ |
| Users, payments, stats screens | ☐ |

### Phase 5 — Hardening & release

| Task | Status |
|---|---|
| Widget tests per feature (beyond smoke test) | ☐ |
| Lint/CI (flutter analyze + test, api lint + test) in GitHub Actions | ☐ |
| Security pass (authz on every route, rate-limit OTP, webhook signature verification) | ☐ |
| Staging environment + production release | ☐ |

---

## 6. Definition of done (per feature)

- Domain layer testable without Flutter; use cases covered by unit tests.
- API contract matched exactly (no client-side guessing of shapes).
- Loading / error / empty states handled.
- SW + EN strings present.
- `flutter analyze` and `flutter test` stay green.

## 7. Open questions

- ~~Property photo storage~~ → **Decided**: local disk behind a `StorageService` interface (`apps/api/uploads/` in dev, `/data/uploads` + docker volume `kazora_uploads` in compose). When scaling, swap in Cloudflare R2 (S3-compatible, 10 GB free, zero egress) via the same interface — no feature changes.
- OTP delivery: SMS provider (e.g., Africa's Talking) or log-only in dev? → **log-only in dev** (confirmed for onboarding); wire a real provider before release.
- Do bookings exist as a product concept, or is the tab "saved searches"? → confirm with product.
