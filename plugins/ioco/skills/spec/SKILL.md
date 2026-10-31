---
name: spec
description: Interview Jeff about a new project and write SPEC.md — what it is, project type (including Prototype), v1 features, data, auth, and design direction. Use when starting a new project, when SPEC.md is empty or still the template, or when Jeff asks to write or update the spec.
---

Write or update `SPEC.md` for this project. Starting context from Jeff: $ARGUMENTS

## How to interview
- Read the existing `SPEC.md` first. Keep anything already filled in and only ask about the gaps.
- Ask **one question at a time**, conversationally. Offer 2–4 concrete options with a recommended default when it helps ("Most apps like this use email + password. Or magic link, or no accounts at all?").
- Skip questions the earlier answers already settle. Aim for 6–10 questions total, not a form.
- Don't design the schema or architecture in detail. Rough is fine; this is the "what", not the "how".

## What to cover
1. **What it is:** one or two sentences: what it does and who it's for.
2. **Type:** API only, frontend only, full-stack, Next.js (public/SEO pages), or **Prototype**.
   - Prototype = a throwaway or one-off (a party game, a demo, an experiment) with no real users' personal data. Confirm this explicitly; it changes which rules apply.
3. **v1 features:** 3–5 max. Push back on more; move extras to "Out of scope".
4. **Out of scope for v1.**
5. **Data:** the rough tables and what's personal information.
6. **Auth:** none, email + password, OAuth, magic link.
7. **AI:** does it call a model? What for?
8. **Design direction** (skip for API-only): who's it for, what feeling, any sites they like. Then propose a direction: one brand color plus neutrals, a type pairing, corner radius, density, tone of voice. Follow the `ui-design` skill. Confirm before writing.
9. **Hosting/deadline:** anything fixed (a date it must work by, a domain, a client).

## Write it
Fill in `SPEC.md` using its existing headings (add a `## Design` and `## AI` section if relevant). Keep it under a page. Show Jeff the result and ask if anything's off. Then suggest the next step: plan the project structure and build order (don't start coding).
