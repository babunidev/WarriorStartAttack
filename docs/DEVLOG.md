# WarriorStartAttack — development record

**Author:** Babuni.dev

## Retrospective examination — 2026-10-26

A Vanilla WoW 1.12.1 Warrior quality-of-life addon that starts melee auto-attack on selected offensive ability attempts. WarriorStartAttack.lua uses a whitelist of internal spell-icon paths to recognize configured Warrior actions. It deliberately starts attacks before rage checks; Intimidating Shout stops attacks. The manifest loads this one Lua file. Client-independent icon paths avoid reliance on localized spell text and missing modern spell-ID APIs; defensive/non-Warrior abilities are excluded.

The coding approach is evidenced by current source and public description, not by a complete dated original discussion. This session's AI contribution was analysis and organizing documentation. No gameplay changes or client tests were made; the original project direction remains attributed to Babuni.dev.

Test hostile/living target safeguards, rage-insufficient actions, repeat presses and stop-attack behavior in the target Vanilla client.
