# Warrior Start Attack

**Author:** Babuni.dev

A minimal World of Warcraft **1.12.1 (Vanilla)** addon for Warriors. When you use a configured offensive ability, it starts melee auto-attack if you have a living hostile target.

This happens when you attempt the action, before the client checks its rage cost. For example, clicking `Heroic Strike` with insufficient rage will still start normal melee swings. Repeated presses do not stop auto-attack. `Intimidating Shout` is the exception: it explicitly stops auto-attack.

## Install

Copy the entire `WarriorStartAttack` folder to:

`World of Warcraft\\Interface\\AddOns\\WarriorStartAttack`

Restart the game or reload the UI. Enable **Warrior Start Attack** on the character-select AddOns screen.

## Client languages

The addon works across client languages. Vanilla 1.12.1 does **not** provide addons with server spell IDs: `CastSpell` receives a spellbook slot, not a spell ID. Therefore the addon identifies abilities by their internal icon paths, which are the same in every localized client.

## Customize

The icon whitelist is near the top of `WarriorStartAttack.lua`. Add an ability's internal icon path if you want it to start attack too.

The addon deliberately uses a whitelist, so defensive abilities and non-Warrior spells do not start combat.
