# WarriorStartAttack — changelog

**Project creator:** Babuni.dev. Dates below are **committed Git history**, not alleged release or playtest dates.

## 2026-10-26 — complete documentation expansion

- Rewrote the user guide, creative concept, roadmap, change history and development rules.
- Added detailed source-based architecture, interaction design, content/ability whitelist, decisions register, narrative journal and human–AI attribution.
- Clarified the **20 offensive icon mappings**, one Intimidating Shout stop icon and the three global spell/action API wrappers.
- Documented source-derived risks: attack-state fallback uncertainty, missing Warrior guard on the stop branch, icon collisions and global hook interoperability.
- Marked **in-game behavior unverified**. No Lua/TOC edits, new assets or functional changes.

## 2026-08-10 — original implementation

**Commit `b1f1ea1`** (“Add files via upload”) introduced:
- `WarriorStartAttack.lua` with a 20-icon offensive whitelist, stop-attack icon table and `AttackTarget()` control.
- Wrappers for `UseAction`, `CastSpell` and `CastSpellByName`.
- Combat enter/leave state tracking plus an action-bar Attack scan.
- README guidance for installation, client-language independence and source-level icon customization.
- `WarriorStartAttack.toc`, **interface 11200**, version **1.0.0**.

The Git tree contains **one initial functional upload**, not a documented sequence of experiments within earlier local files. Do not invent hidden versions or playtest passes from the code's finished shape.

## 2026-10-26 — credit and first documentation scaffold

- `7ab499e`: TOC author field changed from `Local` to `Babuni.dev`.
- `87d7f76`: README added creator credit.
- `eeb0274`: Initial concept, roadmap, architecture, decisions, DEVLOG, AGENTS and changelog text.
- `11ed38e`: README linked that basic documentation set.

The present pass expands that foundation. Runtime files remain at the post-credit head used at the start of this audit.

## Source of evidence

The current source, TOC, README and Git patches establish functionality **as written**. They do not establish compatibility with a particular custom server, actual localized-client results or original conversational attribution.
