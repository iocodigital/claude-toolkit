---
name: security-baseline
description: How to implement auth, ownership checks, rate limiting, CORS, secure headers, logging, error tracking, and safe error responses in a Hono API. Use when building the walking skeleton, adding middleware, adding or changing routes, or touching auth, sessions, or user data.
---

The always-on rules (default-deny auth, never read `.env`) live in the project's CLAUDE.md. This skill is how to implement them.

**Prototype projects** (per SPEC.md) only need: secrets out of the repo, model keys server-side, and rate limits on AI or other paid endpoints. If there's a login, still use a vetted auth library. Skip the rest of this skill.

## Auth
- **Default-deny.** Apply the auth middleware to the whole API, then explicitly exempt public routes in one visible list (e.g. `/api/health`, `/api/health/deep`, login, signup, password reset request). Don't attach auth route by route.
- **Ownership:** "logged in" isn't enough. Services take the current user id and scope every query by it (`where userId = currentUser`). Return 404 (not 403) for another user's resource so ids can't be probed.
- Passwords: use a vetted library (e.g. Argon2/bcrypt via a well-known package) or a hosted auth provider. Never roll your own crypto.
- Sessions/tokens: httpOnly, secure, sameSite cookies; sessions expire; reset and verification tokens are single-use and time-limited.

## Health routes
Two public routes, matching what Jeff's site monitor (`iocodigital/site-monitor`) reads. They're the one exception to the `{ success, data }` response shape.
- `GET /api/health`: liveness. Returns `{ "status": "ok" }` with 200 and touches nothing else. Set it as the Railway service's healthcheck path.
- `GET /api/health/deep`: readiness. Checks the things that actually break (DB query, required config, data freshness if the app depends on a sync) and returns
  `{ "status": "ok" | "degraded" | "fail", "checks": { "<name>": { "status": "...", "detail": "..." } } }`,
  with HTTP 503 when `fail`. The overall status is the worst check. Details must not leak secrets or internals beyond a short reason.
CourtCalc's `/api/health/deep` is the reference implementation.

## Monitoring
Once deployed with a real domain, add the app to `sites.json` in `iocodigital/site-monitor` (see its README): an `http` check on the homepage with `expectText` from the server-sent HTML, a `health` check on `/api/health/deep`, a `cors` check if the frontend and API are on different origins, and an `http` check that a protected route returns 401. Domain/SSL checks are added automatically. Secrets for checks go in the monitor's env vars, never in `sites.json`.

## Rate limiting
Required on login, signup, password reset, any public endpoint, and any AI-backed endpoint. Key by user id when authenticated, IP otherwise. Return 429 with the standard error shape.

## CORS and headers
- CORS allows only the app's own origin(s) from an env var (e.g. `CORS_ORIGINS`). Never `*` on an API with auth or cookies.
- Use Hono's `secureHeaders()` middleware.

## Logging
- One structured line per request: method, path, status, duration, request id.
- Never log request bodies, passwords, tokens, cookies, or API keys.

## Errors
- The central error handler maps typed errors to status codes (400 validation, 401 unauthenticated, 403 forbidden, 404 not found, 409 conflict, 429 rate limited).
- In production, users never see stack traces or internal messages; log them server-side instead.
- Wire up Sentry (or similar) once the app is deployed somewhere real; DSN in env vars.

## Dependencies
- Before adding a package: say what it is and why, and check the name is real and widely used (AI tools sometimes invent package names, and lookalikes can be malicious).
- `npm audit --omit=dev` should be clean of high/critical issues before deploys.
