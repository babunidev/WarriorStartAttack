# WarriorStartAttack — instructions for AI and human developers

**Creative author and decision-maker:** Babuni.dev.  
**Purpose:** Minimal Warrior combat-input quality-of-life in Vanilla WoW 1.12.1.

## Respect the design

- A whitelisted offensive **attempt**, not a successful cast, can start white melee auto-attacks against a living hostile target.
- Repeated presses should **not turn auto-attack off**. `AttackTarget()` is a toggle; avoid blindly calling it.
- Intimidating Shout is an intentional stop-attack exception. Preserve that idea until the creator approves a behavior change.
- Use client icon paths as existing language-independent recognition, but note they aren't unique spell IDs.
- Keep the product lightweight; do not add rotation automation, targeting logic, GUI or persisted settings without explicit direction.
- No current `LICENSE` file exists; do not invent a license grant.

## Source review before editing

Read `README.md`, `CONCEPT.md`, `ROADMAP.md`, `docs/ARCHITECTURE.md`, `docs/DEVLOG.md`, `docs/DECISIONS.md` and the **actual** `WarriorStartAttack.lua`/`.toc`.

Pay special attention to:
1. `UseAction`, `CastSpell`, `CastSpellByName` are **global wrappers**; preserve argument delegation and test with other addons.
2. `IsAutoAttacking` scans **slots 1–120** for the active Attack action, falling back to a `PLAYER_ENTER_COMBAT`/`PLAYER_LEAVE_COMBAT` flag. Combat state is not necessarily identical to auto-attack activity.
3. `StartAttackIfPossible` requires Warrior, living target and attackable target; `StopAttackIfActive` **does not** check Warrior.
4. Icon-sharing across spells may produce false matches, and missing textures may prevent activation.
5. Lua 5.0 / 1.12 API behavior must be tested on the intended actual game client; do not assume modern API equivalents.
6. No network calls, SavedVariables, runtime settings or slash commands are currently present.

## Collaboration and implementation record

Record human direction and its rationale, AI alternatives/proposals, iteration/disagreements, explicit creator acceptance or rejection, source/document paths and commit, and **what was actually tested**. Distinguish source analysis from successful in-game execution.

For material changes, update relevant README, CONCEPT, ROADMAP, CHANGELOG, AGENTS, DEVLOG, DECISIONS, DESIGN, CONTENT, ARCHITECTURE and AI_COLLABORATION entries. Do not publish private conversations, credentials or unrelated player information.

The October 26, 2026 audit is **documentation only**; no gameplay code is authorized for change in this task.
