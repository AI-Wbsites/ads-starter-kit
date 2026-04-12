# reference/

Source material the client supplied that the new site should be based on or inspired by:

- Full HTML/CSS websites (zipped or extracted folders)
- Reference screenshots
- Brand guideline PDFs
- Competitor page captures
- Any visual/technical asset that guides design decisions

## Usage with the `extract-design-system` skill

Drop a reference site into a subfolder, e.g. `reference/acme-old-site/`. Then ask Claude to run the skill (or invoke `/extract-design-system` if a slash command has been set up):

1. Scans the reference's CSS → extracts palette, fonts, spacing, radii, shadows, motion.
2. Writes the extracted values into `design-system/tokens.css`, `typography.css`, `animations.css`.
3. Rebuilds each visible component as an Astro `.astro` file in `prototype/src/components/`.
4. Composes pages in `prototype/src/pages/` using the new components.
5. No hardcoded values survive — everything routes through tokens.

## Not for

- Client-written notes or business info — those go in `info/`.
- Final deliverable assets (logos, photos for launch) — those go into `prototype/public/` or `wordpress-theme/assets/`.

## .gitignore

This folder is **tracked** — the reference material is useful context for Claude throughout the project. Large binaries (videos, big zips) should still be added via git LFS or kept out.
