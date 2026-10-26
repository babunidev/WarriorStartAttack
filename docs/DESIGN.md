# WarriorStartAttack — player interaction and ergonomics

**Creative author:** Babuni.dev.

## Invisible until needed

WarriorStartAttack has no panel. Its design is a behavior change at the moment a player presses a familiar ability. Instead of adding another visible button or requiring the player to remember `/startattack` before each move, it uses the underlying game action to infer when normal melee swings should begin.

The hero example is a **Heroic Strike press without enough rage**. A player has shown intent to attack, even when the special ability cannot fire yet. The addon attempts to start normal swings, allowing the encounter to begin without a separate toggle. This is not a guarantee that the Heroic Strike itself will cast.

## Keep the gesture reversible

Unlike a macro that always executes `AttackTarget()`, which could turn active auto-attack off, the addon first checks for a running attack. The same recognition system has a **stop** list: Intimidating Shout asks the addon to stop auto-attacking.

This pair of interactions makes the addon feel responsive to different combat intentions. The player still chooses the ability; the addon only manages basic auto-swing state. The stated intent is that repeated uses of offensive buttons do not interrupt attack.

## The whitelist is part of the design

Twenty combat actions are recognized. The list includes not just direct blows but utility or threat-related actions (Taunt, Disarm, Demoralizing Shout and others). Their presence represents a broad “actively engaging an enemy” interpretation, while defensive buttons remain outside the table unless the user edits source.

Customization currently requires changing icon paths in Lua and reloading. That is minimal, but not an accessible configuration method for everyone. A settings menu is a possible future choice, **not a currently approved requirement**.

## Limitations of invisible feedback

If auto-attack state is misread or the player lacks a recognized Attack action on a bar, there is no UI warning; the user discovers it through combat behavior. A startup chat line confirms the Lua loaded, not that every hook was exercised.

The global stop branch currently lacks a class gate, which also matters to usability if non-Warriors install the addon. Both issues should be evaluated in the game before any design correction is declared necessary.

## Proposed usability checks, not test claims

Does the addon feel seamless at low rage? Does it avoid accidental disengagement on repeated presses? Does Intimidating Shout reliably stop and allow resumption? Is source-level icon editing sufficient for Babuni.dev's preferred audience? Preserve the creator's decision authority when evaluating alternatives.
