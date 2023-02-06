dofile_once("data/scripts/lib/utilities.lua")
dofile_once("mods/purgatory/files/scripts/utils.lua")

local entity_id = GetUpdatedEntityID()

local is_potion = EntityHasTag(entity_id, "potion")
local is_sack = EntityHasTag(entity_id, "powder_stash")

--Get Barrel size of potion/sack
local material_sucker_comp = EntityGetFirstComponentIncludingDisabled(entity_id, "MaterialSuckerComponent")
local barrel_size = ComponentGetValue2(material_sucker_comp, "barrel_size")

--Build display text
local display_text = "If you see this, priskip made a booboo"
if is_potion then
    display_text = GameTextGetTranslatedOrNot("$item_description_potion_part_1") .. tostring(barrel_size) .. GameTextGetTranslatedOrNot("$item_description_potion_part_2")
end
if is_sack then
    display_text = GameTextGetTranslatedOrNot("$item_description_powder_stash_part_1") .. tostring(barrel_size) .. GameTextGetTranslatedOrNot("$item_description_powder_stash_part_2")
end

--Update description
local item_comp = EntityGetFirstComponentIncludingDisabled(entity_id, "ItemComponent")
ComponentSetValue2(item_comp, "ui_description", display_text)