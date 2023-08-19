dofile_once("data/scripts/lib/utilities.lua")
dofile_once("mods/purgatory/files/scripts/utils.lua")

local entity_id = GetUpdatedEntityID()

--Read Who Shot
local pcomp = EntityGetFirstComponent(entity_id, "ProjectileComponent")
local whoshot
if (pcomp ~= nil) then
    whoshot = ComponentGetValue2(pcomp, "mWhoShot")
end

if whoshot ~= nil then
    --Read Material Inventory
    local mat_inv_comp = EntityGetFirstComponentIncludingDisabled(entity_id, "MaterialInventoryComponent")
    local count_per_material_type = ComponentGetValue2(mat_inv_comp, "count_per_material_type")

    local material = ""
    local amount = 0

    for i, v in ipairs(count_per_material_type) do
        if v ~= 0 then
            material = CellFactory_GetName(i - 1)
            amount = v

            EntityIngestMaterial(whoshot, CellFactory_GetType(material), amount) --makes player eat the blood
            AddMaterialInventoryMaterial(entity_id, material, -amount) --removes material from the field's inventory comp
        end
    end
end
EntityKill(entity_id)
