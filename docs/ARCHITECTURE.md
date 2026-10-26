# WarriorStartAttack — architecture and API behavior

**Version observed:** 1.0.0, interface 11200.  
**Code source:** `WarriorStartAttack.lua` on 2026-10-26. **Static analysis only.**

## Event and hook flow

```text
WoW player input
  |-- Action-bar button: UseAction(slot, checkCursor, onSelf)
  |      -> GetActionTexture(slot)
  |-- Spellbook action: CastSpell(spellSlot, bookType)
  |      -> GetSpellTexture(slot, bookType)
  '-- Macro / /cast / API: CastSpellByName(localizedName, onSelf)
         -> strip trailing "(...)" suffix
         -> iterate GetSpellName / GetSpellTexture across spellbook
         -> match icon for same localized spell name
               |
               v
       known stop icon? -> StopAttackIfActive()
       known offensive icon? -> StartAttackIfPossible()
       neither? -> no extra action
               |
               v
       call original WoW action/casting function
```

These wrappers are assigned **globally** at file load, so unrelated addons may interact according to load order. The code does not intercept every conceivable ability call: only these three functions and the textures/names they expose.

## Offensive gating

`StartAttackIfPossible()` calls `AttackTarget()` only if all of these source checks pass:

1. `UnitClass("player")` returns class token **WARRIOR**.
2. `UnitExists("target")` is true.
3. `UnitIsDead("target")` is false.
4. `UnitCanAttack("player", "target")` is true.
5. `IsAutoAttacking()` is false.

After calling the toggle, it immediately sets `attackActive = true`. It does **not** test range, rage, cast outcome or the presence of an ongoing swing timer. This intentional **pre-action** timing makes insufficient-rage Heroic Strike a useful example.

## Stop behavior

`StopAttackIfActive()` checks `IsAutoAttacking()` and calls the same **toggle** to stop, then sets `attackActive = false`. The sole stop icon is `Interface\\Icons\\Ability_GolemThunderClap`, annotated as **Intimidating Shout**.

Unlike starting, the stop function is **not** conditional on `IsWarrior()`. All three globally installed wrappers can therefore activate the stop path if an icon happens to match on another class. This is a source-level risk requiring actual client tests and a creator decision, **not a proven in-game bug**.

## Detecting current attacks

```text
IsAutoAttacking():
  for actionSlot = 1..120:
      if IsAttackAction(actionSlot)
         and IsCurrentAction(actionSlot):
           return true
  return attackActive
```

The boolean `attackActive` is updated by the addon when it toggles attacks, as well as through registered `PLAYER_ENTER_COMBAT` and `PLAYER_LEAVE_COMBAT` events using Vanilla's global `event` variable. That event fallback is **not the same as a guaranteed server-confirmed melee auto-attack status**. Without a visible Attack action and with other external state changes, it may be stale or too broad.

Because `AttackTarget()` is a **toggle**, the correctness of starting/stopping depends on correctly detecting the live attack state. The README describes intended behavior; a reliable client test must confirm it.

## Icon matching and localization

There are **20 true entries** in the `offensiveIcons` table, each referencing a literal internal texture path. They are used for all spell ranks with that texture. The stop table contains one icon.

`CastSpellByName` is special: it receives a possibly translated spell name. `SpellNameHasIcon` removes a parenthesized suffix, walks the spellbook using `GetSpellName`, selects entries whose name equals the supplied localized name, and only then checks their `GetSpellTexture` against the icon table. **Whitelist membership remains icon-based**, though spellbook lookup still depends on same-language name equality.

This reduces translation maintenance but can be fooled by shared/mismatched icons and should be tested with localized clients and rank syntax.

## Packaging and persistence

The TOC declares `Interface 11200`, title **Warrior Start Attack**, author **Babuni.dev**, and version **1.0.0**, loading one Lua file. There is **no SavedVariables directive**, addon frame UI, slash command, chat transmission, timer, database or external network interaction. Startup prints one status message in the default chat frame.

The game client is not present in this audit. Source analysis does not establish verified behavior on specific 1.12 custom clients or other client generations.
