# WarriorStartAttack — verification plan and future choices

**Creative decision-maker:** Babuni.dev  
**Current status:** Source implementation recorded; gameplay behavior **not tested** in the 2026-10-26 documentation audit.

## Version 1.0.0 source baseline

- Manifest `Interface 11200`; one Lua file; no SavedVariables or slash configuration.
- **20** offensive icon mappings and one stop icon for Intimidating Shout.
- Wrapped `UseAction`, `CastSpell`, `CastSpellByName` to detect button/spell attempts.
- `AttackTarget()` toggle guarded by live action-bar Attack scan and combat-event fallback.
- Start guarded by Warrior class, existing target, living state and ability to attack.
- Stop path does **not** check Warrior class.
- No automated test framework or recorded live-client test outcome in this repo.

## Priority 0 — critical behavior on the intended Vanilla client

1. Install on **1.12.1** and confirm TOC loads, startup chat line appears and there are no Lua errors.
2. On a Warrior with a living **hostile/attackable target**, press whitelisted Heroic Strike at **insufficient rage** and verify ordinary swings start even if the special ability fails.
3. Repeat the same whitelisted action while already auto-attacking: verify it **doesn't toggle attacks off**.
4. Test the same input with **no target**, a **friendly** target, a **dead** target and an **unattackable** target. Record actual attack behavior.
5. Test **Intimidating Shout** while auto-attacking; verify the stop action occurs, spell attempt still passes through, and the player can resume normally.
6. Test starting an attack with a real **Attack button on an action bar**, then remove that button and repeat with **only the combat-event state flag**. Verify whether `PLAYER_ENTER_COMBAT`/`PLAYER_LEAVE_COMBAT` precisely represent active white swings.
7. Test switching targets, combat entering/leaving and any state desynchronization; record whether `AttackTarget()` is called while the client is already attacking.
8. Test non-Warrior characters using a matching attack/stop icon; verify whether the stop icon can toggle their attacks. This is **source risk**, not a proven bug report.

## Priority 1 — API, localization, and addon compatibility

9. Exercise three separate entry points: normal action-bar button (`UseAction`), spellbook click (`CastSpell`), and `/cast` or macro (`CastSpellByName`).
10. Test `CastSpellByName` with translated client spell names and rank suffixes; verify the spellbook-name resolution and icon match.
11. Check **all 20** mapped offensive icons against the intended client; confirm icon collisions don't accidentally trigger for unrelated abilities.
12. Test the Intimidating Shout icon and verify any shared-icon collisions.
13. Test along with other addons that wrap `UseAction`, `CastSpell` or `CastSpellByName` and capture the load order, errors and behavior.
14. Observe behavior when a macro invokes an API not intercepted by this addon and when icons change on custom client builds.
15. Confirm that placing/omitting an Attack action does not create unwanted reliance on the fallback flag.

## Priority 2 — release hygiene and portfolio evidence

16. Determine whether and how Babuni.dev wants the code licensed; **no LICENSE file is currently committed**.
17. Record a repeatable test environment: client build, server, character class, action-bar setup, icon mapping, exact input and observed result.
18. Capture **sanitized screenshots or a short video** of an insufficient-rage Heroic Strike successfully beginning auto-attacks only after the creator tests it.
19. Consider a minimal opt-in test harness/mocks for pure icon-selection logic, without pretending a JavaScript/Lua simulation validates WoW client API behavior.

## Creator questions — proposals, not approvals

- Should the Intimidating Shout stop path enforce `IsWarrior()` explicitly?
- Should auto-attack detection be strengthened to avoid overloading combat-state events as evidence of white swings?
- Are any whitelist entries too broad or should some abilities be added/removed?
- Should players configure icons at runtime, or is source-level minimalism part of the identity?
- Which actual 1.12-compatible variants should be supported and labeled as verified?

Nothing in this roadmap is an instruction to change code without the creator's approval. An in-repo implementation should update the journal and record actual in-game tests.
