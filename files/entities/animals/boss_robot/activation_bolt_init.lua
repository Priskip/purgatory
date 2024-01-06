dofile_once("data/scripts/lib/utilities.lua")
dofile_once("mods/purgatory/files/scripts/lib/utilities.lua")

function init(entity_id)
    local x, y = EntityGetTransform(entity_id)

    local homing_comp = EntityGetFirstComponentIncludingDisabled(entity_id, "HomingComponent")
    local alive_turret_hotspots = EntityGetInRadiusWithTag(x, y, 1000, "mecha_turret_laser_spot")

    if #alive_turret_hotspots > 0 then
        local num = #alive_turret_hotspots
        SetRandomSeed(x, y + GameGetFrameNum())
        num = Random(1, num)

        local homing_target = alive_turret_hotspots[num]
        GamePrint(tostring(homing_target))
        ComponentSetValue2(homing_comp, "predefined_target", homing_target)
        EntitySetComponentIsEnabled(entity_id, homing_comp, true)


        target_x, target_y = EntityGetTransform(homing_target)
        EntityLoad("mods/purgatory/files/entities/misc/test.xml", target_x, target_y)
    end
end
