# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What this repository is

A collection of standalone **Claude Code skills** — each one a self-contained package of instructions (a `SKILL.md`) that extends Claude Code's behavior for a specific workflow. There is no shared build system, package manager, or test suite across skills; each skill under `skills/<name>/` is developed and versioned independently.

## Repository layout

```
skills/
  study/            # single-file skill: just a SKILL.md, no installer needed
    SKILL.md
  ideate/           # multi-file skill: has its own installer, helper scripts, and plugin manifest
    SKILL.md
    README.md
    install.sh
    bin/            # helper scripts, copied to ~/.local/bin by install.sh
    scripts/        # duplicate copy of bin/ (kept in sync manually — see below)
    .claude-plugin/ # plugin.json + marketplace.json for Claude Code plugin installs
```

Two structural patterns exist side by side:
- **Simple skills** (e.g. `study`): a single `SKILL.md` with YAML frontmatter (`name`, `description`, `argument-hint`) followed by the instruction body. No installation step — just copy the file to `~/.claude/skills/<name>/SKILL.md`.
- **Complex skills** (e.g. `ideate`): ship their own `install.sh`, helper shell scripts, and a `.claude-plugin/` manifest so they can be installed either standalone or as a Claude Code plugin.

## Working on `ideate`

- `bin/idea_init.sh` and `bin/idea_append.sh` are byte-identical to `scripts/idea_init.sh` and `scripts/idea_append.sh`. `install.sh` only copies from `bin/`. If you edit one copy, mirror the change in the other (or consider whether `scripts/` should just be removed — check history/intent before deleting).
- `install.sh` does three things: copies `SKILL.md`/`README.md` into `~/.claude/skills/ideate/`, copies the two helper scripts into `~/.local/bin/` (chmod +x), and patches `~/.claude/settings.json` to allow `Bash(idea_init.sh*)` / `Bash(idea_append.sh*)` (via `node`, falling back to `python3`, falling back to printing manual instructions).
- To test `install.sh` changes: run it from `skills/ideate/` and verify `~/.claude/skills/ideate/`, `~/.local/bin/idea_*.sh`, and the `permissions.allow` entries in `~/.claude/settings.json`.
- `.claude-plugin/plugin.json` and `marketplace.json` both contain a `YOUR_GITHUB_USERNAME` placeholder in the repo URL — this is intentional templating for anyone forking the skill as their own plugin, not a bug to fix.
- The `SKILL.md` itself is a literal step-by-step interpreter spec (numbered steps, explicit bash commands, exact output strings) that Claude Code follows when the user runs `/ideate`. When editing it, preserve that level of precision — ambiguity in this file changes runtime behavior, not just documentation. Key invariants encoded there:
  - All idea storage lives under `$PROJECT_DIR/.claude/ideate/` (the *invoking* project's directory, captured once via `pwd`), never under `$HOME`.
  - `raw_ideas.md` is append-only (written through `idea_append.sh`, never truncated); `proposal.md` is fully rewritten on each update but content only grows, never shrinks; `techspec.md` is regenerated with a `.bak.md` backup of the previous version.
  - Language (`ru`/`en`) is auto-detected from the idea name and then used for all subsequent output in that session.

## Working on `study`

Single-file skill — edit `skills/study/SKILL.md` directly. It defines a Socratic-questioning mode (`/study`) with explicit rules for when to give direct answers vs. ask guiding questions, and an explicit exit condition. Keep additions consistent with that behavioral contract rather than turning it into a generic Q&A skill.

## Conventions across skills

- `SKILL.md` frontmatter requires `name` and `description`; `argument-hint` is used where the skill takes a `$ARGUMENTS` payload.
- Skill instruction bodies are written as deterministic procedures (numbered steps, explicit tool calls, literal output strings) rather than loose prose — this repo's skills are meant to produce reproducible agent behavior, not just hint at intent.
- Bilingual (RU/EN) output support, where present, is driven by auto-detection from user input, not a config flag.
