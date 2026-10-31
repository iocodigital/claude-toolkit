---
name: security-baseline
description: How to implement auth, ownership checks, rate limiting, CORS, secure headers, logging, error tracking, and safe error responses in a Hono API. Use when building the walking skeleton, adding middleware, adding or changing routes, or touching auth, sessions, or user data.
---

The always-on rules (default-deny auth, never read `.env`) live in the project's CLAUDE.md. This skill is how to implement them.

## Auth
- **Default-deny.** Apply the auth middleware to the whole API, then explicitly exempt public routes in one visible list (e.g. `/health`, login, signup, password reset request). Don't attach auth route by route.
- **Ownership:** "logged in" isn't enough. Services take the current user id and scope every query by it (`where userId = currentUser`). Return 404 (not 403) for another user's resource so ids can't be probed.
- Passwords: use a vetted library (e.g. Argon2/bcrypt via a well-known package) or a hosted auth provider. Never roll your own crypto.
- Sessions/tokens: httpOnly, secure, sameSite cookies; sessions expire; reset and verification tokens are single-use and time-limited.

## Health route
`GET /health` returns `{ success: true, data: { status: "ok" } }`, no auth, no DB writes. `/deploy` and uptime monitoring use it.

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
