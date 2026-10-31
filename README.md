# claude-toolkit

My Claude Code plugin marketplace. One plugin, `ioco`, holds how I build things, so every project shares the same skills and improvements reach all of them.

## What's in `ioco`
| Skill / agent | Loads | Purpose |
| --- | --- | --- |
| `/ioco:spec` | on request | Interviews you and writes SPEC.md, including project type and design direction |
| `project-architecture` | automatically | Stack, folder structure, conventions, walking skeleton, prototype mode |
| `security-baseline` | automatically | Default-deny auth, ownership, rate limits, CORS, headers, logging, errors, deps |
| `ui-design` | automatically | Design direction, shadcn theming, spacing, contrast, copy, effects to avoid |
| `ai-features` | automatically | Keys, spend limits, timeouts/fallbacks, token limits, prompt injection, evals |
| `testing` | automatically | What to test, Vitest, Hono `app.request()`, test DB, Playwright smoke test |
| `/ioco:new-feature` | on request | Build a feature DB → API → UI |
| `/ioco:add-endpoint` | on request | Add one API endpoint |
| `/ioco:deploy` | manual only | Pre-flight, rollback plan, deploy to Railway, verify |
| `/ioco:launch-check` | manual only | Pre-launch audit before real users |
| `code-reviewer` agent | on request | Reviews a diff before committing |
| secret-check hook | every commit Claude makes | Blocks `git commit` if pending changes contain API keys, DB passwords, private keys, or `.env` files |

## Prototype mode
Mark a project as **Prototype** in SPEC.md (a party game, a demo, an experiment with no real users' data) and the skills scale down: simplest stack, no launch check, one smoke test. Secrets, server-side model keys, and spend limits still apply.

## Using it
New projects from [starter-template](https://github.com/iocodigital/starter-template) are already wired up through `.claude/settings.json`: Claude Code registers this marketplace and enables `ioco` once you trust the folder.

For an existing repo, add the same two keys to its `.claude/settings.json`:
```json
{
  "extraKnownMarketplaces": {
    "iocodigital": {
      "source": { "source": "github", "repo": "iocodigital/claude-toolkit" },
      "autoUpdate": true
    }
  },
  "enabledPlugins": { "ioco@iocodigital": true }
}
```
Or install it for yourself everywhere: `claude plugin marketplace add iocodigital/claude-toolkit`, then `claude plugin install ioco@iocodigital`.

## Where things go
- **Must always happen** (never read `.env`, default-deny auth): the project's CLAUDE.md, or enforce it with settings, hooks, or CI.
- **Knowledge for certain tasks**: a skill here.
- **Files a repo needs** (CI, `.gitignore`, settings): the starter template.

## Editing
Change a skill here, bump `version` in `plugins/ioco/.claude-plugin/plugin.json`, and push. Projects with `autoUpdate` pick it up in the background; otherwise run `/plugin` and update the marketplace.
