# POS with App

Phase 1 foundation for a multi-tenant restaurant SaaS platform.

## Goals of Phase 1
- Multi-tenant architecture
- Supabase PostgreSQL foundation
- Supabase Auth setup
- Business and branch model
- Country, currency, timezone, and locale config
- Tax profile and tax rule foundation
- Row-level security and tenant isolation
- Role-based access model
- Payment provider interface layer only
- Security and access tests

## Technology stack
- Next.js
- React
- TypeScript
- Tailwind CSS
- Supabase PostgreSQL
- Supabase Auth
- Supabase Realtime
- Supabase Storage

## Local development

1. Install dependencies
   ```bash
   npm install
   ```

2. Copy the environment file
   ```bash
   cp .env.example .env.local
   ```

3. Fill in the Supabase values for:
   - `NEXT_PUBLIC_SUPABASE_URL`
   - `NEXT_PUBLIC_SUPABASE_ANON_KEY`
   - `SUPABASE_SERVICE_ROLE_KEY`

4. Run the app
   ```bash
   npm run dev
   ```

5. Run type checks and tests
   ```bash
   npm run typecheck
   npm run test:unit
   ```

## Phase 1 status
This repo contains the architectural foundation and security baseline for the SaaS platform. It does not yet include live payment integrations, POS, menu management, rider apps, or customer ordering.

## Important notes
- Browser-supplied tenant IDs are never trusted.
- Tenant access is always checked on the server and in database RLS.
- Payment providers are defined as interfaces only in this phase.
- Cash on delivery is enabled by configuration, not by hard-coded assumptions.

## Repository focus
This is the secure foundation for later phases:
- Phase 2: branches, employees, invites, staff roles
- Phase 3: menu and product management
- Phase 4: POS and order system
- Phase 5: kitchen display and realtime updates
