# .claude/commands/

Project-scoped slash commands. Each file is a markdown template that Claude runs when you type `/<name>` in a session.

## Example

`.claude/commands/sync-tokens.md`:

```markdown
Copy the three design-system CSS files into the WordPress theme's assets folder:

    cp design-system/tokens.css      wordpress-theme/assets/css/tokens.css
    cp design-system/typography.css  wordpress-theme/assets/css/typography.css
    cp design-system/animations.css  wordpress-theme/assets/css/animations.css

Run this and confirm each file copied.
```

Invoke with `/sync-tokens`.
