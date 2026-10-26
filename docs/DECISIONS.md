# WarriorStartAttack — decisions, tradeoffs and open alternatives

**Creator / decision authority:** Babuni.dev.  
**Evidence:** Initial August 10, 2026 source upload and October 26 documentation/attribution commits. **No original discussion transcript** in inspected materials.

## Observed implementation choices

| Design choice | Source evidence | What can be asserted |
| --- | --- | --- |
| Start attack on chosen ability **attempts** | Pre-delegation `UseAction`/`CastSpell`/`CastSpellByName` wrappers | Intentionally decoupled from ability success or rage availability |
| Protect against toggle-off | `IsAutoAttacking` before `AttackTarget` | Designed to avoid cancelling attack on repeat press; needs client test |
| Living, hostile target safeguard | `UnitExists`, `UnitIsDead`, `UnitCanAttack` | Explicit conditions for **start path** |
| Warrior-only starting | `IsWarrior()` | Implemented on starts; **not on stops** |
| Intimidating Shout stops | `stopAttackIcons` and `StopAttackIfActive` | Explicit exception to start-on-offense |
| Icons instead of translated spell names | `offensiveIcons`, `GetActionTexture`, `GetSpellTexture` | Locale-oriented design, possible shared-icon collisions |
| 1.12-era APIs | Manifest 11200, Lua globals, no `GetActionInfo` | Target declared, actual multi-client support unverified |
| Minimal configuration | Source-edited tables only | No options panel, SavedVariables, or slash commands |

## Alternatives present as engineering tradeoffs, not documented votes

A direct `AttackTarget()` on every button press would be simpler but could **stop** an active attack. The source instead scans action slots and listens to combat events. We can describe the tradeoff; we **cannot claim** a recorded conversation comparing it with a specific macro or other addon.

Using translated spell names as the whitelist would require maintaining localization; icons avoid much of that work, but create ambiguity when multiple abilities use the same icon. The current source proves the selected solution, **not** all rejected designs.

Using spell cast success rather than action intent would produce different behavior in low-rage situations. This feature deliberately favors attempt-time activation according to README and comments, but that intent is still awaiting successful game-client verification.

## Open issues and creator decisions

1. Is the **non-Warrior stop path** acceptable, or should `IsWarrior` guard it?
2. Is `PLAYER_ENTER_COMBAT` a reliable enough fallback for **auto-swing active** when no Attack action is present?
3. Which current 20 entries belong in the whitelist, particularly non-damage abilities?
4. Should source editing remain the intended method of customization?
5. What license, if any, does the creator want to publish for the repository? No `LICENSE` file exists.
6. Which client variants/languages are supported **after** actual testing?

These are pending. The October 26 documentation pass proposed **no code change** and did not infer approval of any alternative.
