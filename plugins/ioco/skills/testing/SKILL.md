---
name: testing
description: How to test Jeff's projects — Vitest setup, testing Hono routes with app.request(), test databases, React component tests, a Playwright smoke test, and which tests are worth writing in a small project. Use when writing or running tests, setting up a test framework, or a feature is done and needs coverage.
---

## What's worth testing (small projects)
Test what would hurt if it broke silently. In priority order:
1. **Auth and ownership:** a request without auth gets 401; user A can't read or change user B's data.
2. **Business logic in services:** calculations, state changes, rules with edge cases (empty, duplicates, limits).
3. **Validation:** bad input gets 400 with the standard error shape.
4. **One smoke test** of the main user flow, end to end.

Skip: snapshot tests, testing shadcn/library components, 100% coverage goals, tests that just repeat the implementation.
For a **Prototype** project (see SPEC.md), the smoke test alone is enough.

## Setup
- **Vitest** for everything except the browser smoke test. Root scripts: `"test": "vitest run"`, plus `"test:watch": "vitest"`.
- Tests live next to the code: `services/user.service.test.ts`, `routes/todos.test.ts`.
- CI runs `npm test`, so every test must pass without manual setup or network access.

## API tests: Hono `app.request()`
Test routes in-process with no running server:
```ts
import { app } from "../app";

it("rejects requests without auth", async () => {
  const res = await app.request("/api/todos");
  expect(res.status).toBe(401);
});

it("creates a todo", async () => {
  const res = await app.request("/api/todos", {
    method: "POST",
    headers: { "Content-Type": "application/json", Cookie: await loginAs(testUser) },
    body: JSON.stringify({ title: "Buy milk" }),
  });
  expect(res.status).toBe(201);
  expect((await res.json()).data.title).toBe("Buy milk");
});
```
Put helpers like `loginAs()` and test-data factories in `src/test/`.

## Test database
- Use a real Postgres-compatible database, not mocks of Drizzle. Options, simplest first:
  - **PGlite** (in-process Postgres via `@electric-sql/pglite` with Drizzle's PGlite driver): no Docker, fast, works in CI. Good default.
  - A local Postgres via Docker, with `DATABASE_URL` pointed at a test database.
- Run migrations before the suite; reset data between tests (truncate tables or a fresh PGlite instance per file).
- Never point tests at a production or shared database.

## Frontend tests
- Vitest + React Testing Library for components with real logic (forms, conditional states). Test from the user's view: find by role/label, click, assert what's shown.
- Mock the API at the network layer (MSW) rather than mocking TanStack Query.
- Cover loading, error, and empty states for key screens.

## Smoke test: Playwright
One test that walks the main flow in a real browser (sign up or log in → do the core thing → see the result). Run it locally and before deploys; add it to CI once the app has a stable way to start (e.g. `npm run build && npm start` with a test database).

## When a test fails
Read the failure, find the cause, and fix the code (or the test if the test was wrong, and say so). Never delete, skip, or loosen an assertion just to make the suite pass.
