# WarriorStartAttack — supported ability and asset inventory

**Author / curator:** Babuni.dev.  
**Source:** `offensiveIcons` and `stopAttackIcons` in `WarriorStartAttack.lua`.

## 20 current offensive mappings

| Source-comment ability | Internal WoW icon texture |
| --- | --- |
| Bloodthirst | `Spell_Nature_BloodLust` |
| Cleave | `Ability_Warrior_Cleave` |
| Demoralizing Shout | `Ability_Warrior_WarCry` |
| Disarm | `Ability_Warrior_Disarm` |
| Execute | `INV_Sword_48` |
| Hamstring | `Ability_ShockWave` |
| Heroic Strike | `Ability_Rogue_Ambush` |
| Intercept | `Ability_Rogue_Sprint` |
| Mortal Strike | `Ability_Warrior_SavageBlow` |
| Mocking Blow | `Ability_Warrior_PunishingBlow` |
| Overpower | `Ability_MeleeDamage` |
| Pummel | `INV_Gauntlets_04` |
| Rend | `Ability_Gouge` |
| Revenge | `Ability_Warrior_Revenge` |
| Shield Bash | `Ability_Warrior_ShieldBash` |
| Slam | `Ability_Warrior_DecisiveStrike` |
| Sunder Armor | `Ability_Warrior_Sunder` |
| Taunt | `Spell_Nature_Reincarnation` |
| Thunder Clap | `Ability_ThunderClap` |
| Whirlwind | `Ability_Whirlwind` |

All names above are **source comments**, not runtime-translated strings. Actual matching is by full `Interface\\Icons\\...` texture path. Icon paths are game-client data **referenced** by the addon, not graphics created, extracted or redistributed by this repository.

## Stop mapping

| Source-comment ability | Internal icon |
| --- | --- |
| Intimidating Shout | `Ability_GolemThunderClap` |

The distinction between start/stop lists is functional, not cosmetic. Editing either table changes combat behavior, so tests should cover changes.

## Other authored interface text

One loading message is emitted to the game's default chat frame: `Warrior Start Attack loaded.` There are no menus, localization bundles, custom icons, images, voiceovers, new animations, scripted emotes or player-authored combat messages.

## Localization and content governance

The code intends to avoid localized strings by using texture names; the `CastSpellByName` route still checks a localized incoming name against the client spellbook before examining its icon. No language-specific text list is stored.

Before claiming coverage of a new spell, verify its client icon and whether another unrelated spell uses that texture. This review did not verify asset IDs or client spell data independently, and no new mapping was approved in the documentation session.
