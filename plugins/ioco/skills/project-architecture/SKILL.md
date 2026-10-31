---
name: project-architecture
description: Jeff's default stack, folder structure, and coding conventions (TypeScript, Hono, Drizzle, Postgres, React, Vite, shadcn, TanStack Query, Railway). Use when scaffolding a new project, adding files or folders, choosing libraries, or planning how a feature fits into the codebase.
---

These are default conventions. If the project or request doesn't fit them, say so instead of forcing it.

## Stack (which applies when)
- **API / backend:** TypeScript (strict) + Hono + PostgreSQL + Drizzle ORM + Zod. Hosted on Railway.
- **Frontend:** Vite + React + TypeScript + Tailwind + shadcn/ui + TanStack Query + React Router + React Hook Form/Zod.
- **Use Next.js instead** only if the project needs SEO/public pages or Jeff asks for it. Then skip the separate backend.
- **Full-stack:** monorepo with `apps/api`, `apps/web`, `packages/shared`.

## Scale to the project
- Small project: start lean (routes, services, db). Add folders only when needed. No empty folders.
- Larger app: group by feature (`modules/<feature>/`) instead of one giant folder per layer.

## Backend structure (`apps/api` or root)
```
src/
  config/       env.ts (Zod-validated env vars), app config
  db/           schema.ts (Drizzle tables), index.ts (client)
  routes/       endpoint definitions only, no logic
  controllers/  parse request, call service, return response (merge into routes if trivial)
  services/     business logic, no HTTP/context objects
  middleware/   auth, error handling, logging
  validators/   Zod schemas for request input
  utils/        reusable helpers
  app.ts        Hono app setup
  server.ts     starts the server
drizzle/        generated migrations (commit these)
```

## Frontend structure (`apps/web` or root)
```
src/
  components/ui/  shadcn components (add via CLI, edit sparingly)
  components/     app-wide components (layout, nav)
  features/       one folder per feature: components, hooks, api calls
  pages/          route-level components, thin
  hooks/  lib/  types/
```

## Conventions
- Central error handler. JSON responses: `{ success: true, data }` or `{ success: false, error }`.
- Fail fast at startup if required env vars are missing (`config/env.ts` with Zod). Keep `.env.example` up to date.
- API reads port from `process.env.PORT` (Railway sets it).
- Frontend: no data fetching in `useEffect`; use TanStack Query. Handle loading, error, and empty states.
- Full-stack: shared Zod schemas/types live in `packages/shared`; use Hono's RPC client (`hc`) for typed API calls.
- Root `package.json` scripts: `typecheck`, `lint`, `test`, `build` (CI runs these). In a monorepo they fan out to each workspace.

## Walking skeleton (first build in a new project)
Frontend → API → DB → deployed on Railway, end to end, before any features. Include from day one: env validation, error handler, request logging, `/health`, auth middleware (default-deny), CORS, secure headers. See the `security-baseline` skill.
