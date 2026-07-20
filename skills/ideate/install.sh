#!/usr/bin/env bash
set -euo pipefail

SKILL_DIR="$HOME/.claude/skills/ideate"
BIN_DIR="$HOME/.local/bin"
SETTINGS="$HOME/.claude/settings.json"

# Install skill file
echo "Installing ideate skill to $SKILL_DIR..."
mkdir -p "$SKILL_DIR"
cp SKILL.md README.md "$SKILL_DIR/"

# Install scripts to ~/.local/bin
echo "Installing scripts to $BIN_DIR..."
mkdir -p "$BIN_DIR"
cp bin/idea_init.sh bin/idea_append.sh "$BIN_DIR/"
chmod +x "$BIN_DIR/idea_init.sh" "$BIN_DIR/idea_append.sh"

# Update settings.json permissions
ALLOW_INIT="Bash(idea_init.sh*)"
ALLOW_APPEND="Bash(idea_append.sh*)"

if [[ ! -f "$SETTINGS" ]]; then
  echo '{"permissions":{"allow":[]}}' > "$SETTINGS"
fi

if grep -qF "idea_init.sh" "$SETTINGS" 2>/dev/null; then
  echo "Permissions already present in $SETTINGS — skipping."
else
  if command -v node &>/dev/null; then
    node - "$SETTINGS" "$ALLOW_INIT" "$ALLOW_APPEND" <<'EOF'
const fs = require('fs');
const [,, file, entry1, entry2] = process.argv;
const cfg = JSON.parse(fs.readFileSync(file, 'utf8'));
cfg.permissions = cfg.permissions || {};
cfg.permissions.allow = cfg.permissions.allow || [];
if (!cfg.permissions.allow.includes(entry1)) cfg.permissions.allow.push(entry1);
if (!cfg.permissions.allow.includes(entry2)) cfg.permissions.allow.push(entry2);
fs.writeFileSync(file, JSON.stringify(cfg, null, 2) + '\n');
EOF
    echo "Permissions added to $SETTINGS."
  elif command -v python3 &>/dev/null; then
    python3 - "$SETTINGS" "$ALLOW_INIT" "$ALLOW_APPEND" <<'EOF'
import sys, json
file, e1, e2 = sys.argv[1], sys.argv[2], sys.argv[3]
with open(file) as f: cfg = json.load(f)
cfg.setdefault('permissions', {}).setdefault('allow', [])
for e in [e1, e2]:
    if e not in cfg['permissions']['allow']:
        cfg['permissions']['allow'].append(e)
with open(file, 'w') as f: json.dump(cfg, f, indent=2); f.write('\n')
EOF
    echo "Permissions added to $SETTINGS."
  else
    echo ""
    echo "WARNING: Could not update $SETTINGS automatically (node/python3 not found)."
    echo "Add these lines manually to the 'permissions.allow' array in $SETTINGS:"
    echo "  \"$ALLOW_INIT\","
    echo "  \"$ALLOW_APPEND\""
  fi
fi

# Check if ~/.local/bin is on PATH
if ! echo ":${PATH}:" | grep -q ":${BIN_DIR}:"; then
  echo ""
  echo "NOTE: $BIN_DIR is not in your PATH."
  echo "Add this line to your ~/.zshrc or ~/.bashrc, then restart your shell:"
  echo "  export PATH=\"\$HOME/.local/bin:\$PATH\""
fi

echo ""
echo "Done. Use /ideate in Claude Code to start."
