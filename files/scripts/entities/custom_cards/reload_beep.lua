dofile_once("data/scripts/lib/utilities.lua")
dofile_once("mods/purgatory/files/scripts/lib/utilities.lua")

local spell_entity_id = GetUpdatedEntityID()


local wand_id = EntityGetParent(spell_entity_id)
local ability_comp = EntityGetFirstComponentIncludingDisabled(wand_id, "AbilityComponent")
local current_mana = ComponentGetValue2(ability_comp, "mana")
local mana_max = ComponentGetValue2(ability_comp, "mana_max")

local var_storage_comp = EntityGetFirstComponentIncludingDisabled(spell_entity_id, "VariableStorageComponent")
local already_reloaded = ComponentGetValue2(var_storage_comp, "value_bool")

if (current_mana == mana_max) then
    if (not already_reloaded) then
        --play the beep and set to be fully reloaded
        --GamePrint("Fully Reloaded")
        ComponentSetValue2(var_storage_comp, "value_bool", true)

        local x, y = EntityGetTransform(spell_entity_id)
        GamePlaySound("data/audio/Desktop/ui.bank", "ui/game_resume", x, y) --TODO: make custom sound effect for this

    end
else
    if (already_reloaded) then
        ComponentSetValue2(var_storage_comp, "value_bool", false)
    end
end
