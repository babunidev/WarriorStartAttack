# WarriorStartAttack — creative and technical development journal

**Creator and creative director:** Babuni.dev  
**Prepared:** October 26, 2026 from committed source, README, manifest and dated Git patches. This is a **retrospective reconstruction**, not a transcript of the creator's conversations.

## A practical frustration becomes a small interface idea

The project rests on a very particular experience of playing a Warrior in old World of Warcraft: the player presses an offensive ability to begin engaging an enemy, but that ability may not execute yet. The most concrete case preserved in the original README is **Heroic Strike with insufficient rage**. The player already decided to attack; nevertheless, the character may need a separate auto-attack activation before normal swings begin.

WarriorStartAttack attempts to remove that extra repetitive step. It makes the player's ordinary offensive input serve a second, tightly scoped function: start white-weapon auto-attacking a living, hostile target, even if the chosen ability doesn't fire. This is an interaction and convenience idea by **Babuni.dev**. The assistant documenting it later did not invent that goal.

The source makes clear that the addon is not a rotation engine. It doesn't pick the next spell, decide whom to target, or simulate combat. It reacts to an action the player initiated and then lets the original game function process the action as normal. That narrowness is part of what makes it distinctive as a usable, minimal addon rather than a large UI project.

## The August 10, 2026 first upload

The repository was created on **August 10, 2026** and received the commit **`b1f1ea1`** (“Add files via upload”). That commit already contained its core **160-line Lua file**, a version **1.0.0** manifest, and a practical short README. There is **only one visible functional upload** in the inspected history, so we cannot tell whether earlier local prototypes, experiments or debugging conversations preceded it.

The initial Lua selected **20** offensive abilities by their internal client icons, including Heroic Strike, Bloodthirst, Sunder Armor, Rend, Pummel, Taunt and Whirlwind. It also specified a special stop-action icon for **Intimidating Shout**. The author did not ask the addon to start attacking on every interaction; the whitelist establishes boundaries around which inputs imply engagement.

That choice matters more in the old client than it would appear at first. As the source comments explain, Vanilla's `CastSpell` receives a spellbook slot, not a modern spell ID for addon lookup. The code therefore intercepts three places where a spell action may be attempted—`UseAction`, `CastSpell`, `CastSpellByName`—and turns each into a texture lookup. For a `/cast` macro it uses the localized spell name to locate the spellbook entry and **then** uses its internal icon for inclusion in the table.

The benefit is that individual spell ranks and localized client spell labels need not each be stored in a handcrafted language whitelist. The price is that icon textures are not unique spell identities: the program may match two abilities sharing artwork. That is a source-supported technical limitation, not an observed player bug.

## Making a toggle act like a one-way start action

The second problem is subtler. The 1.12 API `AttackTarget()` is a **toggle**, not a guaranteed one-way “start.” The simple solution of calling it on every Heroic Strike press would sometimes undo exactly what the player wanted: if melee auto-attack was already active, pressing an offensive button could stop it.

To avoid that, the addon first scans action-bar slots **1 through 120** for a visible Attack action that the client marks both an attack action and current. If it finds one, it assumes auto-attacking already exists and doesn't toggle. If it doesn't find one, it uses a local `attackActive` flag. That flag changes when this addon toggles the attack and in response to `PLAYER_ENTER_COMBAT` and `PLAYER_LEAVE_COMBAT`.

The difference between being **in combat** and **actively swinging a weapon** deserves attention. The source uses combat events as a fallback, but they don't independently prove that an auto-attack is running. If the player has no Attack action on a bar, or if another addon changes attack state, the local flag could become inaccurate. Because the addon is working with a toggle, wrong state detection could produce unwanted behavior. No actual in-game failure was reported or reproduced in this audit.

## The meaningful stop-action exception

Intimidating Shout is on a different list, `stopAttackIcons`. When a recognized shout input is attempted, the addon checks attack state and may call `AttackTarget()` to **stop** the swing. That is an explicit part of the source's intended player experience, not an accidental omitted offensive skill.

A technical nuance surfaced during this documentation review: the **start** function checks that the player is a Warrior, but the **stop** function does not. The hooked action functions are global; on a non-Warrior using a matching icon, the stop logic could also run. The creator hasn't approved changing this behavior in this session. The prudent next step is an actual target-client test, followed by a decision, rather than silently broadening the work from documentation to code modification.

## October 26, 2026 — the addon becomes an accessible project record

After the August implementation, the next visible changes were documentary. On October 26, **`7ab499e`** changed the TOC author field from `Local` to **Babuni.dev**, **`87d7f76`** updated README credit, **`eeb0274`** created a basic concept/roadmap/changelog/architecture/decision/development structure, and **`11ed38e`** linked those documents from the README.

Those commits improved attribution and discoverability without changing the original combat logic. The current pass extends that work into a publishable narrative, a precise description of the three API hooks and their behavior, the full source-based ability inventory, and a reproducible test plan. It also records the lack of a committed license instead of assuming one.

**What the creator established:** the minimal Warrior auto-attack convenience feature, selected icons and Intimidating Shout behavior reflected by the source and original description. **What AI contributed in this session:** Git/source research, technical interpretation, writing and committing documentation. **What was not done:** gameplay modification, new features, live-client testing, assumed acceptance of suggested corrections or reconstructing nonexistent private chat records.

## The next chapter should be measured in game

Does insufficient-rage Heroic Strike really start melee auto-attacks on the creator's exact client? Are repeated presses safe without a visible Attack button? Does Intimidating Shout stop reliably? What happens on a non-Warrior or when icons overlap? These questions define the next meaningful verification milestone.

The site's portfolio can eventually tell both halves: why an apparently tiny Warrior quality-of-life idea was worth building, and what it took to work within the old client while respecting the creator's intent and the actual testing limits.
