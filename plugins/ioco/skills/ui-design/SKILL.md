---
name: ui-design
description: Jeff's UI and visual design rules for avoiding the generic "vibe-coded" look — design direction, shadcn theming, spacing and type scale, contrast, copywriting, and which decorative effects to avoid. Use whenever building or changing UI, pages, landing pages, components, styling, or user-facing copy.
---

## Start with a direction
Before building UI for a new project, propose a short design direction based on SPEC.md and confirm it with Jeff:
- palette (one brand color plus neutrals), type pairing, corner radius, density, tone of voice.
Record the agreed direction in SPEC.md under a "Design" heading and follow it everywhere.

## Rules
- **Customize shadcn.** Set the project's own colors, radius, and font in the theme tokens on day one. Never ship the default zinc/slate look untouched.
- **Spacing and type scale:** use Tailwind's scale consistently (a small set, e.g. 4/6/8/12/16/24) and no more than 4–5 text sizes. No one-off pixel values.
- **Contrast:** text meets WCAG AA in light and dark mode. Dark mode means dark grey backgrounds with properly light text, not grey on grey.
- **Copy:** specific, plain copy about what the app actually does for this user. No "Supercharge / Seamless / Unlock / Elevate / Revolutionize". No emojis in headings. Avoid em dashes in UI text.
- **Hover and focus states** change something meaningful (color, background, underline), not just opacity. Visible focus rings for keyboard users.
- **Layout:** don't default to a row of 3 icon cards for features. Show the real product (screenshot, demo, example data) instead.

## Effects are opt-in
Don't add these unless Jeff asks or the agreed direction calls for one on purpose:
purple-to-blue gradients, gradient headline text, glassmorphism, grain over gradients, cursor-following glows, fade-in-on-scroll everywhere, colored-border cards, a pill badge above every hero headline.

## Fine as tools, not defaults
Lucide icons and Inter are fine. Use icons sparingly, and pick type deliberately per project instead of by default.

## States
Every data view handles loading (skeletons, not spinners everywhere), error (what happened + a retry), and empty (what this is + the first action to take). Real 404 and 500 pages.
