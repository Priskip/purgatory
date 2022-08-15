dofile_once("data/scripts/lib/utilities.lua")
dofile_once("data/scripts/perks/perk.lua")

local entity_id = GetUpdatedEntityID()
local x, y = EntityGetTransform(entity_id)

local mat_suck_comp = EntityGetFirstComponent(entity_id, "MaterialSuckerComponent")
local mat_inv_comp = EntityGetFirstComponent(entity_id, "MaterialInventoryComponent")
local item_comp = EntityGetFirstComponent(entity_id, "ItemComponent")

local amount = ComponentGetValue2(mat_suck_comp, "mAmountUsed")
local max_amount = ComponentGetValue2(mat_suck_comp, "barrel_size")
local ui_desc = ComponentGetValue2(item_comp, "ui_description")

if amount / max_amount == 1 then
    if item_comp ~= nil then
        ComponentSetValue2(item_comp, "ui_description", "$itemdesc_hastestone_full")
        ui_desc = "$itemdesc_hastestone_full"
    end

    local explosions = EntityGetInRadiusWithTag(x, y, 120, "big_explosion")
    local seas = EntityGetInRadiusWithTag(x, y, 120, "sea_of_lava")
    local beams = EntityGetInRadiusWithTag(x, y, 120, "beam_from_sky")
    local nukes = EntityGetInRadiusWithTag(x, y, 120, "nuke_giga")

    if (#explosions > 0) or (#seas > 0) or (#beams > 0) or (#nukes > 0) then
        perk_spawn(x, y, "HASTE")
        EntityKill(entity_id)
    end
end
