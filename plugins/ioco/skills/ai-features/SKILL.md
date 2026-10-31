---
name: ai-features
description: Rules for building features that call an LLM or other AI model API (Claude, OpenAI, etc.) — key handling, spend limits, timeouts and fallbacks, token limits, prompt injection, and rate limiting. Use whenever adding, changing, or reviewing code that calls a model API.
---

## Keys and cost
- Model API keys stay server-side in env vars. The frontend never calls the model provider directly.
- Before the first deploy of an AI feature, remind Jeff to set a spend limit and billing alert on the provider account.
- Rate-limit AI endpoints per user. Consider a per-user daily cap for anything public.

## Reliability
- Every model call has a timeout. On timeout or provider error, the UI shows a friendly error state with a retry, not a crash or an endless spinner.
- Retry transient errors (429/5xx) a small number of times with backoff; don't retry 4xx validation errors.
- Stream long responses where the UX benefits.

## Limits
- Cap user input length before it reaches the model, with a clear message in the UI.
- Handle context/token-limit errors explicitly (truncate history, summarize, or tell the user), never silently.

## Prompt injection
- Treat user text, uploaded files, and fetched web content as untrusted data inside prompts. Keep instructions in the system prompt and clearly delimit user content.
- Model output never triggers privileged actions (DB writes, emails, payments, deleting things) without server-side validation, and for destructive actions, user confirmation.
- Don't put secrets or other users' data in prompts.
- Add a few test cases with injection attempts ("ignore previous instructions…") for features where it matters.

## Quality
- Keep a small set of example inputs and expected behaviours (evals) for each AI feature, and rerun them when changing prompts or models.
- Log model, latency, token usage, and errors per call (not the user's content unless needed and disclosed).
