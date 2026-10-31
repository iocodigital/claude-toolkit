#!/usr/bin/env bash
# PreToolUse hook (Bash): block `git commit` when pending changes contain likely secrets.
# Scans everything that could end up in the commit: staged + unstaged changes to tracked
# files and new untracked (non-ignored) files, since commands like `git add . && git commit`
# stage files after this hook runs. Exit 2 blocks the command and shows stderr to Claude.

input=$(cat)

# Only act on commands that run `git commit` (ignores e.g. `git commit-tree`).
printf '%s' "$input" | grep -Eq 'git( -C [^ ]+)? commit([^-a-z]|$)' || exit 0

git rev-parse --is-inside-work-tree >/dev/null 2>&1 || exit 0

if git rev-parse --verify -q HEAD >/dev/null; then
  base=HEAD
else
  base=4b825dc642cb6eb9a060e54bf8d69288fbee4904 # empty tree (first commit)
fi

problems=""

# 1. Real env files being committed (even if force-added past .gitignore).
env_files=$( { git diff --cached --name-only "$base"; git ls-files --others --exclude-standard; } 2>/dev/null \
  | grep -E '(^|/)\.env(\..+)?$' | grep -Ev '\.env\.(example|sample|template)$' | sort -u)
if [ -n "$env_files" ]; then
  problems+="Env file(s) about to be committed:"$'\n'"$env_files"$'\n'
fi

# 2. Secret-looking strings in added lines and new files.
patterns='AKIA[0-9A-Z]{16}'
patterns+='|sk-ant-[A-Za-z0-9_-]{20,}'
patterns+='|sk-(proj-)?[A-Za-z0-9_-]{32,}'
patterns+='|gh[pousr]_[A-Za-z0-9]{36,}|github_pat_[A-Za-z0-9_]{40,}'
patterns+='|(sk|rk)_live_[A-Za-z0-9]{20,}'
patterns+='|xox[abprs]-[A-Za-z0-9-]{10,}'
patterns+='|AIza[0-9A-Za-z_-]{35}'
patterns+='|-----BEGIN ([A-Z]+ )?PRIVATE KEY-----'
patterns+='|postgres(ql)?://[^:/ "]+:[^@ "]+@[^/ "]+'

added=$(git diff "$base" --unified=0 --no-color 2>/dev/null | grep -E '^\+[^+]' | cut -c2-)
untracked=$(git ls-files --others --exclude-standard -z 2>/dev/null \
  | xargs -0 -I{} sh -c '[ -f "$1" ] && [ $(wc -c < "$1") -lt 1000000 ] && grep -IEH "." "$1" 2>/dev/null' _ {} )

hits=$(printf '%s\n%s\n' "$added" "$untracked" | grep -Eo "$patterns" \
  | grep -Ev '@(localhost|127\.0\.0\.1|db|postgres)[:/]|:(password|pass|changeme|postgres|secret)@|\$\{' \
  | sort -u | head -5)

if [ -n "$hits" ]; then
  redacted=$(printf '%s\n' "$hits" | sed -E 's/^(.{8}).*/\1…(redacted)/')
  problems+="Possible secrets in pending changes:"$'\n'"$redacted"$'\n'
fi

[ -z "$problems" ] && exit 0

cat >&2 <<EOF
Commit blocked by the ioco secret check.
$problems
Move secrets to .env (gitignored) and reference them via config/env.ts, then try again.
If a real key was already committed or pushed anywhere, tell Jeff it needs rotating.
If this is a false positive (e.g. a documented placeholder), tell Jeff and let him commit it himself.
EOF
exit 2
