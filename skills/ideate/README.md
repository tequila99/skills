# skill-ideate

Multi-session brainstorming and technical specification development for Claude Code.

Turn raw thoughts into structured technical proposals — across multiple sessions. Write ideas as they come, get targeted clarifying questions, and end up with a `proposal.md` and a concrete `techspec.md`.

## How it works

Three modes, navigated via a menu:

**Input mode** — Write whatever comes to mind. Claude asks up to 8 clarifying questions per input, adapting to everything accumulated so far. Stops early when enough is clear; offers to continue after 8 if more is needed.

**Processing mode** — Claude reads all accumulated material, fills gaps with up to 20 questions, then generates or updates `proposal.md` — a technology-agnostic spec draft. Existing content is never deleted, only enriched.

**Tech spec mode** — Scans your project for existing stack (package.json, go.mod, Cargo.toml, etc.), asks targeted technical questions, and produces `techspec.md` — a concrete spec with language, framework, database, infrastructure, and testing decisions.

Sessions are resumable: all input is saved immediately. Come back anytime with `/ideate` or `/ideate your idea name`.

Supports **English** and **Russian**. Language is detected automatically from the idea name.

## Storage

Ideas are stored inside your project under `.claude/ideate/`. Each project has its own list.

```
.claude/ideate/
  ideas-map.json          # idea registry
  your-idea-slug/
    raw_ideas.md          # all input verbatim, append-only
    proposal.md           # tech-agnostic spec draft (Mode 2)
    techspec.md           # concrete tech spec (Mode 3)
    techspec.bak.md       # backup of previous techspec before regeneration
```

## Usage

```
/ideate                       # pick from recent ideas or create new
/ideate my app idea           # open or create a specific idea
```

**Invocation name depends on how you installed:**

| Install method | Command |
|---|---|
| Standalone (install.sh) | `/ideate` |
| Plugin (Claude Code) | `/skill-ideate:ideate` |

## Installation

### Option A — Plugin install (Claude Code v2.1.142+)

```
/plugin marketplace add YOUR_GITHUB_USERNAME/skill-ideate
/plugin install skill-ideate@skill-ideate
```

Replace `YOUR_GITHUB_USERNAME` with the actual GitHub username. Skill is invoked as `/skill-ideate:ideate`.

### Option B — Standalone: Linux / macOS

```bash
git clone https://github.com/YOUR_GITHUB_USERNAME/skill-ideate
cd skill-ideate
./install.sh
```

`install.sh` does three things:
1. Copies `SKILL.md` to `~/.claude/skills/ideate/`
2. Copies helper scripts to `~/.local/bin/` and sets them executable
3. Adds the required permissions to `~/.claude/settings.json`

**macOS note:** `~/.local/bin` is not in the default PATH on macOS. If it's missing, `install.sh` will print the exact line to add to `~/.zshrc` or `~/.bashrc`.

Skill is invoked as `/ideate`.

### Option C — Standalone: Windows

Requires a bash-compatible shell (Git Bash or WSL).

1. Copy `SKILL.md` to `%USERPROFILE%\.claude\skills\ideate\`
2. Choose a directory that is on your `%PATH%` (e.g. `%USERPROFILE%\bin\`) and copy `bin\idea_init.sh` and `bin\idea_append.sh` into it
3. Add to `%USERPROFILE%\.claude\settings.json` under `permissions.allow`:
   ```json
   "Bash(idea_init.sh*)",
   "Bash(idea_append.sh*)"
   ```

Skill is invoked as `/ideate`.

### Cursor

Cursor reads skills from `~/.claude/skills/`. The standalone install (Option B) works for Cursor with no extra steps.

## Permissions

The skill uses two helper scripts to write files. Claude Code will ask for permission on first use. To pre-approve and skip the prompts, add to `~/.claude/settings.json`:

```json
{
  "permissions": {
    "allow": [
      "Bash(idea_init.sh*)",
      "Bash(idea_append.sh*)"
    ]
  }
}
```

`install.sh` adds these automatically.

## Requirements

- Claude Code (any version for standalone; v2.1.142+ for plugin install)
- Bash-compatible shell (bash or zsh)
- `node` or `python3` — used by `install.sh` to update `settings.json` automatically (optional: you can edit it manually)
