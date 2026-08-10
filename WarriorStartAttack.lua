-- Warrior Start Attack - Vanilla (1.12.1 / Lua 5.0)
-- Icon paths are client-language independent. Vanilla's UI API does not expose
-- server spell IDs to addons; CastSpell receives a spellbook slot instead.

-- Add or remove ability icons here.  These paths are the same in every client
-- language and apply to every rank of the ability.
local offensiveIcons = {
    ["Interface\\Icons\\Spell_Nature_BloodLust"] = true,       -- Bloodthirst
    ["Interface\\Icons\\Ability_Warrior_Cleave"] = true,        -- Cleave
    ["Interface\\Icons\\Ability_Warrior_WarCry"] = true,        -- Demoralizing Shout
    ["Interface\\Icons\\Ability_Warrior_Disarm"] = true,        -- Disarm
    ["Interface\\Icons\\INV_Sword_48"] = true,                  -- Execute
    ["Interface\\Icons\\Ability_ShockWave"] = true,             -- Hamstring
    ["Interface\\Icons\\Ability_Rogue_Ambush"] = true,          -- Heroic Strike
    ["Interface\\Icons\\Ability_Rogue_Sprint"] = true,          -- Intercept
    ["Interface\\Icons\\Ability_Warrior_SavageBlow"] = true,    -- Mortal Strike
    ["Interface\\Icons\\Ability_Warrior_PunishingBlow"] = true, -- Mocking Blow
    ["Interface\\Icons\\Ability_MeleeDamage"] = true,           -- Overpower
    ["Interface\\Icons\\INV_Gauntlets_04"] = true,              -- Pummel
    ["Interface\\Icons\\Ability_Gouge"] = true,                 -- Rend
    ["Interface\\Icons\\Ability_Warrior_Revenge"] = true,       -- Revenge
    ["Interface\\Icons\\Ability_Warrior_ShieldBash"] = true,    -- Shield Bash
    ["Interface\\Icons\\Ability_Warrior_DecisiveStrike"] = true,-- Slam
    ["Interface\\Icons\\Ability_Warrior_Sunder"] = true,        -- Sunder Armor
    ["Interface\\Icons\\Spell_Nature_Reincarnation"] = true,    -- Taunt
    ["Interface\\Icons\\Ability_ThunderClap"] = true,           -- Thunder Clap
    ["Interface\\Icons\\Ability_Whirlwind"] = true,             -- Whirlwind
}

-- These actions intentionally stop melee auto-attack instead of starting it.
local stopAttackIcons = {
    ["Interface\\Icons\\Ability_GolemThunderClap"] = true, -- Intimidating Shout
}

local function IsWarrior()
    local _, class = UnitClass("player")
    return class == "WARRIOR"
end

-- AttackTarget() toggles auto-attack.  Vanilla exposes its current state only
-- through an Attack action placed on an action bar, so check every action slot
-- first and keep combat-event state as a fallback.
local attackActive = false

local function IsAutoAttacking()
    local actionSlot = 1
    while actionSlot <= 120 do
        if IsAttackAction(actionSlot) and IsCurrentAction(actionSlot) then
            return true
        end
        actionSlot = actionSlot + 1
    end
    return attackActive
end

local function StartAttackIfPossible()
    if IsWarrior() and UnitExists("target") and not UnitIsDead("target")
       and UnitCanAttack("player", "target") and not IsAutoAttacking() then
        AttackTarget()
        attackActive = true
    end
end

local function StopAttackIfActive()
    if IsAutoAttacking() then
        AttackTarget()
        attackActive = false
    end
end

local eventFrame = CreateFrame("Frame")
eventFrame:RegisterEvent("PLAYER_ENTER_COMBAT")
eventFrame:RegisterEvent("PLAYER_LEAVE_COMBAT")
eventFrame:SetScript("OnEvent", function()
    if event == "PLAYER_ENTER_COMBAT" then
        attackActive = true
    elseif event == "PLAYER_LEAVE_COMBAT" then
        attackActive = false
    end
end)

local function IsOffensiveSpellSlot(spellSlot, bookType)
    local texture = GetSpellTexture(spellSlot, bookType)
    return texture and offensiveIcons[texture] == true
end

local function IsStopAttackSpellSlot(spellSlot, bookType)
    local texture = GetSpellTexture(spellSlot, bookType)
    return texture and stopAttackIcons[texture] == true
end

-- This runs before the client checks whether the action is usable. Vanilla
-- 1.12 does not have GetActionInfo, so inspect the action button's stable icon.
-- In particular, a Warrior with too little rage will still begin auto-attacking.
local originalUseAction = UseAction
UseAction = function(actionSlot, checkCursor, onSelf)
    local texture = GetActionTexture(actionSlot)
    if texture and stopAttackIcons[texture] == true then
        StopAttackIfActive()
    elseif texture and offensiveIcons[texture] == true then
        StartAttackIfPossible()
    end
    return originalUseAction(actionSlot, checkCursor, onSelf)
end

-- Converts a localized name from /cast or CastSpellByName into a spellbook
-- slot, then checks its language-independent icon. The name is never used as
-- an ability whitelist entry.
local function SpellNameHasIcon(spellName, iconList)
    if not spellName then
        return false
    end

    local baseName = string.gsub(spellName, "%s*%b()$", "")
    local spellSlot = 1
    local knownName = GetSpellName(spellSlot, BOOKTYPE_SPELL)

    while knownName do
        local texture = GetSpellTexture(spellSlot, BOOKTYPE_SPELL)
        if knownName == baseName and texture and iconList[texture] == true then
            return true
        end
        spellSlot = spellSlot + 1
        knownName = GetSpellName(spellSlot, BOOKTYPE_SPELL)
    end

    return false
end

local function IsOffensiveSpellName(spellName)
    return SpellNameHasIcon(spellName, offensiveIcons)
end

local function IsStopAttackSpellName(spellName)
    return SpellNameHasIcon(spellName, stopAttackIcons)
end

-- Covers spellbook clicks and action buttons that call CastSpell directly.
local originalCastSpell = CastSpell
CastSpell = function(spellSlot, bookType)
    if IsStopAttackSpellSlot(spellSlot, bookType) then
        StopAttackIfActive()
    elseif IsOffensiveSpellSlot(spellSlot, bookType) then
        StartAttackIfPossible()
    end
    return originalCastSpell(spellSlot, bookType)
end

-- Covers /cast macros and addons which use CastSpellByName.
local originalCastSpellByName = CastSpellByName
CastSpellByName = function(spellName, onSelf)
    if IsStopAttackSpellName(spellName) then
        StopAttackIfActive()
    elseif IsOffensiveSpellName(spellName) then
        StartAttackIfPossible()
    end
    return originalCastSpellByName(spellName, onSelf)
end

DEFAULT_CHAT_FRAME:AddMessage("|cff33ff99Warrior Start Attack loaded.|r")
