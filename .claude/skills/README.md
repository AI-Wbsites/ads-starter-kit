# .claude/skills/

Project-scoped skills live here. A skill is a markdown file with frontmatter that Claude can invoke during a session.

## Adding a skill

Create `<skill-name>.md`:

```markdown
---
name: skill-name
description: One-line description — used to decide when to invoke.
---

## When to use

Describe when Claude should reach for this skill.

## What to do

Step-by-step instructions Claude follows when the skill is invoked.
```

## Candidates for this workflow

Ideas (uncreated — add when the need is real, not speculative):

- `build-prototype` — bootstrap a new section/page in `prototype/` with tokens wired up.
- `port-widget` — take an approved Astro component and produce its Elementor widget.
- `sync-tokens` — copy design-system CSS into `wordpress-theme/assets/css/`.
- `review-feedback` — parse a client reply from `info/notes/`, extract action items, append to `info/feedback.md`.
- `add-cpt` — scaffold a custom post type from the template.
