# .claude/

Project-scoped Claude Code configuration.

## Contents

- **`settings.local.json`** — permissions are set to `bypassPermissions` by default so Amila can work in this project without approving every tool call. Remove this file (or change `defaultMode`) if collaborating with someone you don't want to auto-approve.
- **`skills/`** — project skills. Each `<name>.md` is invokable by Claude or via `/skills`.
- **`commands/`** — custom slash commands. Each `<name>.md` runs when you type `/<name>`.

See `skills/README.md` and `commands/README.md` for authoring notes.
