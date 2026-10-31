---
name: launch-check
description: Audit the app before real users or customers use it — legal pages, account flows, domain/email, SEO, accessibility, backups, monitoring. Only run when the user asks for a launch check or says the app is going public.
disable-model-invocation: true
---

Run a pre-launch audit. Context from the user: $ARGUMENTS

Read SPEC.md first. Skip sections that don't apply (no accounts → skip account flows; internal tool → skip SEO) and say which you skipped.

Check each item by looking at the code, config, or live URL. Don't fix anything yet. Report a table: item, status (✅ done / ⚠️ partial / ❌ missing / n/a), and a one-line fix.

## Security and reliability
- Every non-public route has auth; ownership checks on user data (spot-check 3 routes).
- Rate limiting on login, signup, password reset, public and AI endpoints.
- `npm audit --omit=dev` clean of high/critical issues.
- No secrets in git history (`git log -p` grep for key-like strings; suggest rotating any found).
- Database backups enabled, and a restore has been tested at least once (ask the user).
- Error tracking (Sentry or similar) and uptime monitoring on `/health` are set up.
- Spend limits and billing alerts on Railway and any AI/API providers (ask the user).

## Accounts (if the app has users)
- Signup, login, logout, password reset, and email verification all work end to end.
- Users can delete their account and their data.
- Sessions expire; password reset tokens are single-use and time-limited.

## Legal and privacy (Canada / BC baseline)
- Privacy policy and terms pages exist and are linked from the footer and signup.
- Personal info collected is listed in the privacy policy, with how to request access or deletion (PIPEDA / BC PIPA).
- Cookie or analytics consent if using non-essential tracking.

## Domain and email
- Custom domain with SSL working; `www` and apex both resolve.
- If the app sends email: SPF, DKIM, and DMARC set on the sending domain.

## UX and polish
- Real 404 and 500 pages; loading, error, and empty states everywhere.
- Works on a phone and on a throttled "Slow 4G" connection.
- Basic accessibility: keyboard navigation, labels on form fields, alt text, readable contrast.
- Doesn't look template-generated: check against the `ui-design` skill (theme customized, consistent spacing, specific copy, no default AI-landing-page effects). List the 3 most generic-looking spots.
- Favicon and OG image/meta tags (title, description).
- Public sites: `sitemap.xml`, `robots.txt`, sensible page titles.
- Images optimized; static assets cached.

## Docs
- README covers what the app is, local setup, env vars, and deploy steps.

End with the top 3 items to fix first, ordered by risk.
