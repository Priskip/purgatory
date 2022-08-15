dofile_once("data/scripts/lib/utilities.lua")

local entity_id = GetUpdatedEntityID()

local hit_box_comp = EntityGetFirstComponentIncludingDisabled(entity_id, "HitboxComponent")
EntitySetComponentIsEnabled(entity_id, hit_box_comp, true)

--GamePrint("Enabled Hit Box")