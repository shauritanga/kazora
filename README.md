# Kazora

**Discover. Connect. Live.**

A two-sided marketplace connecting landlords and tenants in Tanzania. Tenants browse verified residential and commercial properties (rooms, apartments, houses, offices, shops) and pay **5,000 Tsh/month** to unlock up to **5 landlord contact reveals per month**. Landlords list properties for free.

> Find a place you'll love.
> Discover verified properties, connect directly with landlords, and make finding your next home easier.

## Monorepo layout

| Path | What | Stack |
|---|---|---|
| `apps/mobile` | Tenant + landlord mobile app | Flutter, Riverpod, go_router |
| `apps/api` | Public REST API (auth, properties, payments, credits) | NestJS, PostgreSQL, Redis |
| `apps/admin` | Admin panel (moderation, users, payments, stats) | React, Vite, TypeScript |
| `docs/PLAN.md` | **The plan of record** — decisions, architecture, phases, progress tracker | — |

## Requirements

| Dependency | Version |
|---|---|
| Flutter | ≥ 3.47 |
| Node.js | ≥ 20 |
| Docker | ≥ 24 (for Postgres/Redis) |

## Quick start

```bash
# 1. Infrastructure (Postgres 16 + Redis 7)
docker compose up -d

# 2. API
cd apps/api
cp .env.example .env   # then fill in credentials
npm install
npm run start:dev      # http://localhost:3000

# 3. Mobile
cd apps/mobile
flutter pub get
flutter run

# 4. Admin
cd apps/admin
npm install
npm run dev            # http://localhost:5173
```

## Rules of the road

- `docs/PLAN.md` is the single source of truth. Read it before starting work; update its progress tracker as you go.
- Mobile follows the clean-architecture feature layout defined in `docs/PLAN.md` (data → domain → presentation per feature).
- Payments go through the mobile money gateway adapter — never hardcode operator logic in features.
