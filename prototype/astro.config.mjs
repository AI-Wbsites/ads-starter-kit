// @ts-check
import { defineConfig } from 'astro/config';

// Prototype-only config.
// DO NOT add React/Vue/Svelte/Solid/Preact integrations — see prototype/CLAUDE.md.
export default defineConfig({
  site: 'https://example.com',
  build: {
    format: 'directory',
  },
});
