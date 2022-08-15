dofile_once("data/scripts/lib/utilities.lua")
dofile_once("data/scripts/gun/procedural/gun_procedural.lua")
dofile_once("data/scripts/gun/procedural/gun_action_utils.lua")

local entity_id = GetUpdatedEntityID()
local x, y = EntityGetTransform(entity_id)

local ability_comp = EntityGetFirstComponent(entity_id, "AbilityComponent")
local sprite_comp = EntityGetFirstComponentIncludingDisabled(entity_id, "SpriteComponent") --Get SpriteComponent
ComponentSetValue2(sprite_comp, "image_file", "mods/purgatory/files/items_gfx/starting_wand_green.xml")
ComponentSetValue2(ability_comp, "sprite_file", "mods/purgatory/files/items_gfx/starting_wand_green.xml")

local hotspot_comp = EntityGetFirstComponentIncludingDisabled(entity_id, "HotspotComponent") --Get HotspotComponent
ComponentSetValueVector2(hotspot_comp, "offset", 8, -0.5)

--This only sets the wand's sprite and action point
--Stats and Wands are applied in seperate lua script (initialize_starting_wands.lua) that affects all four starting wands