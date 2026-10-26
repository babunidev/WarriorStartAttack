# Warrior Start Attack

**A small Warrior quality-of-life addon for World of Warcraft Vanilla 1.12.1**

**Project creator:** Babuni.dev  
**Addon version:** 1.0.0  
**Declared interface:** `11200`  
**Implementation:** [`WarriorStartAttack.lua`](WarriorStartAttack.lua) and [`WarriorStartAttack.toc`](WarriorStartAttack.toc)  
**Documentation audit:** October 26, 2026 — source and Git history examined; **not tested in a game client**.

**Warrior Start Attack** starts regular melee auto-attacks when a Warrior attempts one of 20 configured offensive abilities and has a **living, attackable target**. It does so *before* the original action is processed, so pressing Heroic Strike with insufficient rage can still start white-weapon swings. Repeated watched presses are designed **not** to toggle off an attack that is already running.

**Intimidating Shout is the intentional exception:** its recognized icon tries to stop auto-attacking. This is an action-trigger convenience tool, not a spell-success detector, a combat rotation system, or a replacement for the player's control.

## Installing it

```text
World of Warcraft/
└── Interface/
    └── AddOns/
        └── WarriorStartAttack/
            ├── WarriorStartAttack.toc
            └── WarriorStartAttack.lua
```

Copy both files into that folder, restart WoW or reload the UI, and enable **Warrior Start Attack** in the addon list. The source prints `Warrior Start Attack loaded.` in chat when the file executes.

The addon has **no slash commands, options panel, SavedVariables, or other configuration UI**. You configure it by editing the icon tables near the start of the Lua file. The repository also has **no committed LICENSE file**; do not assume an open-source license from the presence of public code.

## How it behaves

1. The addon notices an action through **`UseAction`**, **`CastSpell`**, or **`CastSpellByName`**. It wraps each global function, checks the ability's icon, and then calls the original function.
2. If the icon is in the offensive whitelist, the player is a **Warrior**, and the target exists, is alive and is hostile/attackable, it checks whether melee auto-attack is already active.
3. If the attack appears inactive, the code calls the Vanilla API **`AttackTarget()`** once. This matters because **`AttackTarget()` toggles attack** and would switch it off if called blindly.
4. If the icon matches **Intimidating Shout**, the code instead attempts to switch off an active attack. This stop branch is not currently guarded by `IsWarrior()`; see [architecture](docs/ARCHITECTURE.md) and the [roadmap](ROADMAP.md).
5. The original action function still runs afterwards. The addon doesn't check mana/rage, success/failure, attack range or whether a cast was completed before attempting its extra attack-state change.

The auto-attack-state check scans action-bar slots **1–120** for an active **Attack** action (`IsAttackAction` and `IsCurrentAction`). If it cannot find one, it relies on a locally tracked flag updated by `PLAYER_ENTER_COMBAT`, `PLAYER_LEAVE_COMBAT`, and the addon's own attack toggles. This is a useful fallback, **not necessarily perfect evidence of active melee swings** on every client or combat situation.

## Built-in offensive whitelist

The initial and current code contains **20** icon mappings:

| | | |
| --- | --- | --- |
| Bloodthirst | Cleave | Demoralizing Shout |
| Disarm | Execute | Hamstring |
| Heroic Strike | Intercept | Mortal Strike |
| Mocking Blow | Overpower | Pummel |
| Rend | Revenge | Shield Bash |
| Slam | Sunder Armor | Taunt |
| Thunder Clap | Whirlwind | |

**Stop-attack mapping:** Intimidating Shout (`Ability_GolemThunderClap` icon).

Some of these are shouts, tactical actions or taunts rather than damaging hits; the whitelist expresses the creator's selection of **combat-initiating attempts**, not a claim that every item deals physical damage.

### Change the whitelist

Open `WarriorStartAttack.lua` and edit `offensiveIcons` or `stopAttackIcons`. Keys are the game client's internal icon texture paths, such as:

```lua
["Interface\\Icons\\Ability_Rogue_Ambush"] = true, -- Heroic Strike
```

The same icon is used across ranks of a spell, and the code avoids using translated spell names as the whitelist. For `CastSpellByName`, it uses the incoming **localized name only to find a spellbook entry**, then compares that spell's icon to the whitelist.

**Limit:** icons are **not guaranteed unique spell IDs**. Other abilities or macros sharing a recognized texture may cause an unintended match. Conversely, icon-path changes on a particular game client can prevent a match. Test changes on the actual client.

## Intended safeguards and limitations

- **Starts only for Warriors:** `StartAttackIfPossible` checks `UnitClass("player")` for `WARRIOR`.
- **Target checks:** requires `UnitExists("target")`, a living target, and `UnitCanAttack("player", "target")`.
- **Repeated triggers:** aims to avoid `AttackTarget()` when an attack is already active; whether detection works without an Attack button present is a test item.
- **Stop behavior:** triggered by Intimidating Shout icon; its current function lacks the class guard used for starting attacks.
- **No player configuration persistence:** icons are code-defined, not SavedVariables.
- **Client version:** TOC specifies interface 11200 and Lua comments specify **1.12.1 / Lua 5.0**. Function behavior on custom Vanilla servers or other eras remains unverified.
- **Compatibility with other addons:** replacing the global casting/action functions can interact with other hooks according to installation/load order.

The claim of **client-language independence** is an implementation intention supported by icon matching; it was **not** verified by testing localized clients during this review.

## Troubleshooting checklist

If the addon doesn't load, confirm the folder and filenames and look for the startup chat line. If a configured action fails to start auto-attack, check that you are playing a Warrior, have a living hostile target, and that the actual spell's icon matches a table key. If repeated presses stop combat unexpectedly, test whether a normal **Attack** action is on a bar and whether the state fallback is getting out of sync; capture actual steps and client version before proposing a fix.

## Project record

WarriorStartAttack began as a single **August 10, 2026** code upload. On **October 26, 2026**, author attribution and a short documentation scaffold were added. The present audit expands that into a portfolio-ready record without altering Lua or TOC.

For fuller context: [concept](CONCEPT.md), [development journal](docs/DEVLOG.md), [architecture](docs/ARCHITECTURE.md), [design and interaction](docs/DESIGN.md), [ability inventory](docs/CONTENT.md), [decision evidence](docs/DECISIONS.md), [verification roadmap](ROADMAP.md), [changelog](CHANGELOG.md), [collaboration attribution](docs/AI_COLLABORATION.md), and [AI/developer instructions](AGENTS.md).

**Original concept and creative direction:** Babuni.dev. **AI contribution in this audit:** research, source interpretation, editorial documentation, commit and verification. No in-game behavior was independently observed.
