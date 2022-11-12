dofile_once("data/scripts/lib/utilities.lua")
dofile_once("mods/purgatory/files/scripts/utils.lua")

function collision_trigger(colliding_entity)
    local entity_id = GetUpdatedEntityID()
    local x, y = EntityGetTransform(entity_id)

    local nearby_ents = EntityGetInRadius(x, y, 300)

    for i, ent_id in ipairs(nearby_ents) do
        if EntityGetName(ent_id) == "$animal_boss_robot" then
            --This is Mecha Kolmi
            local mecha_kolmi_comps = EntityGetAllComponents(ent_id)

            for j, component in ipairs(mecha_kolmi_comps) do
                EntitySetComponentIsEnabled(ent_id, component, true) --cheating a bit and just enabling every comp here
            end

            EntityAddTag(ent_id, "music_energy_100")
        end

        if EntityHasTag(ent_id, "roboroom_mecha_turret_alive") then
            --This is a turret
            local hitbox_comp = EntityGetFirstComponentIncludingDisabled(ent_id, "HitboxComponent")
            EntitySetComponentIsEnabled(ent_id, hitbox_comp, true)
        end
    end
end

--[[
Things to enable on Mecha Kolmi "$animal_boss_robot"

PhysicsAIComponent
PathFindingGridMarkerComponent
PathFindingComponent
HitboxComponent
LuaComponent - mods/purgatory/files/scripts/boss_bars/boss_bar.lua
LuaComponent - data/entities/animals/boss_robot/state.lua

tags
music_energy_100

EntityGetName( entity_id:int ) -> name:string


Things to enable on Turrets
HitboxComponent
]]
