#!/usr/bin/env bash
# init.sh — stamp a freshly-cloned project with client-specific values.
#
# Replaces every {{PLACEHOLDER}} across the repo with answers to a few prompts.
# Idempotent-safe: refuses to run if placeholders are already gone.

set -euo pipefail

cd "$(dirname "$0")"

# --- Safety checks -----------------------------------------------------------

if ! grep -rq '{{CLIENT_NAME}}' . --include='*.md' --include='*.css' --include='*.astro' --include='*.php' --include='*.json' --include='*.mjs' --include='*.html' --include='*.js' 2>/dev/null; then
  echo "✖ No placeholders found — looks like this repo has already been initialised."
  echo "  If that's wrong, restore the original template files from git."
  exit 1
fi

if command -v git >/dev/null 2>&1 && [ -d .git ] && [ -n "$(git status --porcelain)" ]; then
  echo "⚠  Your git working tree is dirty. init.sh will modify files in place."
  read -r -p "Continue anyway? [y/N] " reply
  [[ "$reply" =~ ^[Yy]$ ]] || { echo "Aborted."; exit 1; }
fi

# --- Prompts -----------------------------------------------------------------

echo
echo "=== Stamping a new client project ==="
echo

prompt() {
  local varname="$1" prompt_text="$2" default="${3:-}" value=""
  if [ -n "$default" ]; then
    read -r -p "$prompt_text [$default]: " value
    value="${value:-$default}"
  else
    while [ -z "$value" ]; do
      read -r -p "$prompt_text: " value
    done
  fi
  printf -v "$varname" '%s' "$value"
}

to_slug() {  # lowercase, spaces/underscores → dashes, strip non [a-z0-9-]
  printf '%s' "$1" | tr '[:upper:]' '[:lower:]' | sed -E 's/[ _]+/-/g; s/[^a-z0-9-]//g; s/-+/-/g; s/^-|-$//g'
}

to_const() {  # uppercase, dashes/spaces → underscores, strip non [A-Z0-9_]
  printf '%s' "$1" | tr '[:lower:]' '[:upper:]' | sed -E 's/[ -]+/_/g; s/[^A-Z0-9_]//g; s/_+/_/g; s/^_|_$//g'
}

to_pascal() {  # dashes/underscores/spaces → PascalCase
  printf '%s' "$1" \
    | sed -E 's/[_-]+/ /g' \
    | awk '{ for (i=1;i<=NF;i++) $i=toupper(substr($i,1,1)) tolower(substr($i,2)); print }' \
    | sed -E 's/ //g; s/[^A-Za-z0-9]//g'
}

prompt CLIENT_NAME          "Client display name (e.g. Acme Corp)"
prompt THEME_NAME_DEFAULT   "Theme name (PascalCase PHP identifier, e.g. Acme)"   "$(to_pascal "$CLIENT_NAME")"
THEME_NAME="$THEME_NAME_DEFAULT"

THEME_SLUG_DEFAULT="$(to_slug "$THEME_NAME")"
prompt THEME_SLUG           "Theme slug (lowercase, kebab-case)"                  "$THEME_SLUG_DEFAULT"
THEME_SLUG="$(to_slug "$THEME_SLUG")"

prompt THEME_TEXT_DOMAIN    "Text domain (usually same as theme slug)"            "$THEME_SLUG"
THEME_CONST_PREFIX="$(to_const "$THEME_SLUG")"

prompt WIDGET_CATEGORY_NAME "Widget category display name (e.g. Acme Widgets)"    "$THEME_NAME Widgets"
prompt WIDGET_CATEGORY_SLUG "Widget category slug (lowercase, kebab-case)"        "$(to_slug "$WIDGET_CATEGORY_NAME")"
WIDGET_CATEGORY_SLUG="$(to_slug "$WIDGET_CATEGORY_SLUG")"

prompt SITE_URL             "Site URL (leave blank if unknown)"                   "https://example.com"

echo
echo "=== Review ==="
cat <<EOF
  CLIENT_NAME          = $CLIENT_NAME
  THEME_NAME           = $THEME_NAME
  THEME_SLUG           = $THEME_SLUG
  THEME_TEXT_DOMAIN    = $THEME_TEXT_DOMAIN
  THEME_CONST_PREFIX   = $THEME_CONST_PREFIX
  WIDGET_CATEGORY_NAME = $WIDGET_CATEGORY_NAME
  WIDGET_CATEGORY_SLUG = $WIDGET_CATEGORY_SLUG
  SITE_URL             = $SITE_URL
EOF
echo
read -r -p "Apply these values to every file? [y/N] " reply
[[ "$reply" =~ ^[Yy]$ ]] || { echo "Aborted."; exit 1; }

# --- Replacement -------------------------------------------------------------

# Cross-platform sed -i (GNU vs BSD)
sed_i() {
  if sed --version >/dev/null 2>&1; then
    sed -i "$@"
  else
    sed -i '' "$@"
  fi
}

sed_escape() {  # escape for use on the RIGHT side of s/// in sed
  printf '%s' "$1" | sed -E 's/[\/&|]/\\&/g'
}

replace_in_tree() {
  local placeholder="$1" value="$2"
  local value_esc
  value_esc="$(sed_escape "$value")"

  # Find files we care about (skip node_modules, .git, build output)
  find . \
    -type d \( -name node_modules -o -name .git -o -name dist -o -name .astro \) -prune -o \
    -type f \( -name '*.md' -o -name '*.css' -o -name '*.astro' -o -name '*.php' \
            -o -name '*.json' -o -name '*.mjs' -o -name '*.js' -o -name '*.html' \
            -o -name '*.txt' \) -print \
    | while read -r f; do
        if grep -q "$placeholder" "$f" 2>/dev/null; then
          sed_i "s|${placeholder}|${value_esc}|g" "$f"
        fi
      done
}

echo
echo "Applying replacements..."

replace_in_tree '{{CLIENT_NAME}}'          "$CLIENT_NAME"
replace_in_tree '{{THEME_NAME}}'           "$THEME_NAME"
replace_in_tree '{{THEME_SLUG}}'           "$THEME_SLUG"
replace_in_tree '{{THEME_TEXT_DOMAIN}}'    "$THEME_TEXT_DOMAIN"
replace_in_tree '{{THEME_CONST_PREFIX}}'   "$THEME_CONST_PREFIX"
replace_in_tree '{{WIDGET_CATEGORY_NAME}}' "$WIDGET_CATEGORY_NAME"
replace_in_tree '{{WIDGET_CATEGORY_SLUG}}' "$WIDGET_CATEGORY_SLUG"
replace_in_tree '{{SITE_URL}}'             "$SITE_URL"

echo "✓ Done."
echo
echo "Next steps:"
echo "  cd prototype && npm install && npm run dev"
echo "  Open info/questionnaire.md and send it to the client."
echo "  Edit design-system/tokens.css with the client's palette."
echo
echo "Self-delete init.sh now that it's no longer needed?"
read -r -p "[y/N] " reply
if [[ "$reply" =~ ^[Yy]$ ]]; then
  rm -- "$0"
  echo "✓ init.sh removed."
fi
