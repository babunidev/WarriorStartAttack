# WarriorStartAttack — creative concept

**Creative author:** Babuni.dev  
**Scope:** World of Warcraft 1.12.1 Warrior melee quality-of-life enhancement.

## Combat intent without repetitive busywork

In Vanilla WoW, an attempted Warrior ability is not always a completed attack. Rage can be insufficient; an ability can be unusable or fail. The creative premise of **Warrior Start Attack** is that choosing an aggressive move should nevertheless let the character begin **ordinary melee swings** against a living hostile target. This lets the player focus on actions and character rather than on keeping the auto-attack toggle in the correct state.

The source's example is especially clear: pressing **Heroic Strike with too little rage** should still begin regular attacks. That makes the feature fundamentally **input-driven**, not the result of parsing combat events or choosing abilities automatically.

It also avoids a common trap with the old API: `AttackTarget()` is a toggle. Calling it each time a button is pressed could undo the player's attack. The addon therefore tries to learn whether auto-attack is active before touching it. Defensive/non-offensive abilities are not indiscriminately added; a whitelist expresses which abilities have the desired meaning.

## The revealing exception

**Intimidating Shout** has a different emotional/combat function. The implementation puts its icon on a **stop-attack list**, separating “begin attacking” from “disengage swinging” behavior. This explicit exception makes the addon more than a generic auto-attack macro applied to every button.

A future portfolio entry should preserve this relationship between player intent and the two opposite behaviors. The code's current stop branch can run for any class if an icon matches; whether that is a bug or a harmless consequence requires client testing and a creator decision about expected scope.

## The 1.12 technical constraint

Vanilla's `CastSpell` API receives a **spellbook slot**, and the current code doesn't rely on server spell IDs. The solution is to resolve **language-independent icon texture paths**, including when a translated spell name is supplied through `CastSpellByName`. This is a creative technical adaptation to the older game's capabilities.

Using icons means spell ranks share recognition and translated spell labels need no whitelist entries. It also introduces a tradeoff: icon graphics are not unique identifiers. The project should not be described as guaranteed perfect across every localized or modified client without tests.

## What the project is not

There is no GUI, networking, saved preferences, automation of rotations, target selection, automatic spell casting or performance optimization model. It is a **minimal gameplay usability idea**, implemented through legacy UI functions.

The Git history supplies one initial August 2026 implementation and October documentation changes. It does **not** preserve the original brainstorming transcript or a comparative test of alternatives, so no private intentions or AI authorship claims have been invented here.
