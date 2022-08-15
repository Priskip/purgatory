dofile_once("data/scripts/lib/utilities.lua")

local entity_id = GetUpdatedEntityID()
local x, y = EntityGetTransform(GetUpdatedEntityID())

local phase = 0
local projectiles_in_mem = ""
local comps = EntityGetComponent(entity_id, "VariableStorageComponent")
local max_wands_allowed = 0

if (comps ~= nil) then
    for i, v in ipairs(comps) do
        local n = ComponentGetValue2(v, "name")
        if (n == "phase") then
            phase = ComponentGetValue2(v, "value_int")
        elseif (n == "memory") then
            --print( ComponentGetValue2( v, "value_string" ) )
            projectiles_in_mem = ComponentGetValue2(v, "value_string")
        elseif (n == "max_wands_allowed") then
            max_wands_allowed = ComponentGetValue2(v, "value_int")
        end
    end
end

--pit boss's max hp is 100 (2500) in purgatory
local damagemodels = EntityGetComponent(entity_id, "DamageModelComponent")
local cur_hp = 0
local max_hp = 0

if damagemodels ~= nil then
    for i, dm in ipairs(damagemodels) do
        cur_hp = ComponentGetValue2(dm, "hp")
        max_hp = ComponentGetValue2(dm, "max_hp")
    end
end

--Number of wand's the pit boss has
local wand_ids = EntityGetInRadiusWithTag(x, y, 100, "pit_boss_wand")

--GUI
local id = 1
local function new_id()
    id = id + 1
    return id
end
gui = gui or GuiCreate()
GuiStartFrame(gui)

GuiText(gui, 20, 40, "Max HP: " .. max_hp)
GuiText(gui, 20, 50, "Current HP: " .. cur_hp)
GuiText(gui, 20, 60, "Phase: " .. phase)
GuiText(gui, 20, 70, "Memory: " .. projectiles_in_mem)
GuiText(gui, 20, 80, "Wands: " .. tostring(#wand_ids))
GuiText(gui, 20, 90, "Max Wands Allowed: " .. tostring(max_wands_allowed))

