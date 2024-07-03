local mq = require('mq')
require 'ImGui'

local function IsSpellBeneficial(spellName)
    local spell = mq.TLO.Spell(spellName)
    return spell and (spell.SpellType() == "Beneficial" or spell.SpellType() == "Beneficial(Group)")
end

-- TODO: check on NoRemove functionality in lua
-- local function IsSpellNoRemove(spellName)
--     local spell = mq.TLO.Spell(spellName)
--     return spell and spell.NoRemove()
-- end

-- local function IsSpellRemovable(spellName)
--     local spell = mq.TLO.Spell(spellName)
--     return spell and IsSpellBeneficial(spell) and not IsSpellNoRemove(spell)
-- end

local function RemoveLongBuffs(bReport)
    -- buff index starting at 1
    for i = 1, mq.TLO.Me.MaxBuffSlots() do
        local buffName = mq.TLO.Me.Buff(i)()
        -- skip any empty slots
        if buffName ~= nil then
            --if IsSpellRemovable(buffName) then
            if IsSpellBeneficial(buffName) then
                -- blah
                mq.cmdf('/removebuff %s', buffName)
                if bReport then
                    printf('[Remove Buffs] removing %s', buffName)
                end
            end
        end
    end
end

local function RemoveShortBuffs(bReport)
    -- buff index starting at 1
    for i = 1, mq.TLO.Me.CountSongs() do
        local buffName = mq.TLO.Me.Song(i)()
        -- skip any empty slots
        if buffName ~= nil then
            if buffName ~= nil then
                --if IsSpellRemovable(buffName) then
                if IsSpellBeneficial(buffName) then
                    mq.cmdf('/removebuff %s', buffName)
                    if bReport then
                        printf('[Remove Buffs] removing %s', buffName)
                    end
                end
            end
        end
    end
end

local function main()
    while true do
        -- if report buffs being stripped or not
        local bReport = false
        RemoveLongBuffs(bReport)
        RemoveShortBuffs(bReport)
        mq.delay('1s')
    end
end

main()
