---
name: deploy
description: Pre-flight checks and deploy to Railway. Only run when the user explicitly asks to deploy.
disable-model-invocation: true
---

Deploy the app to Railway. Target: $ARGUMENTS (default: production)

## Pre-flight (stop and report if any step fails)
1. Working tree is clean and on the expected branch (`git status`).
2. Typecheck, lint, and tests pass.
3. Build succeeds locally.
4. Any new env vars are in `.env.example` AND set in Railway (check with the Railway tools; never print secret values).
5. `npm audit --omit=dev --audit-level=high` is clean, or report what it found and ask before continuing.
6. Pending Drizzle migrations: list them and confirm with the user before they run against the target database. If any migration drops or rewrites data (drop column/table, type change, destructive backfill), confirm Railway Postgres backups are enabled and a recent backup exists first.

## Rollback plan
7. Record the currently live deployment ID and commit before deploying. This is the rollback target.
8. Note whether the migrations are backward compatible. If not, say so: rolling back the code alone won't undo them.

## Deploy
9. Deploy via the Railway connector or CLI (or push to the deploy branch if the service auto-deploys from GitHub).
10. Watch the deployment until it succeeds or fails. On failure, fetch the build/deploy logs and diagnose before retrying.

## Verify
11. Hit `GET /api/health/deep` (or the main page) on the live URL and confirm `status` is `ok`.
12. Check recent logs for errors.
13. If verification fails, offer to roll back to the deployment from step 7 (redeploy/rollback in Railway), and wait for the user's go-ahead.
14. If this was the first production deploy, remind Jeff to add the app to `iocodigital/site-monitor` (`sites.json`).
15. Report: what was deployed (commit), URL, the rollback target, and anything that looks off.
