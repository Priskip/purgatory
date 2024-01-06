dofile_once("data/scripts/lib/utilities.lua")
dofile_once("mods/purgatory/files/scripts/lib/utilities.lua")

function damage_received(damage, desc, entity_who_caused, is_fatal)
    if desc == "$damage_healing" then
        --Reactivate Turret

        --Kill Old Turret - but save its x and y for summoning the new turret
        local broken_turret = {}
        broken_turret.id = GetUpdatedEntityID()
        broken_turret.x, broken_turret.y = EntityGetTransform(broken_turret.id)
        EntityKill(broken_turret.id)

        --Summon New Turret
        local turret = {}
        turret.id = EntityLoad("mods/purgatory/files/entities/buildings/roboroom/mecha_turret.xml", broken_turret.x, broken_turret.y)
        turret.x, turret.y = EntityGetTransform(turret.id)

        --Remove it's normal initialization script
        local init_scripts = EntityGetComponent(turret.id, "LuaComponent", "init_script")
        if init_scripts ~= nil then
            for i, comp in ipairs(init_scripts) do
                EntityRemoveComponent(turret.id, comp)
            end
        end

        --Set all the hitboxes
        local center = {}
        center.id = EntityGetClosestWithTag(turret.x, turret.y, "roboroom_center")
        center.x, center.y = EntityGetTransform(center.id)

        local r, phi = get_r_and_phi(turret.x, turret.y, center.x, center.y)
        turret.phi = phi + math.pi / 2

        EntitySetTransform(turret.id, turret.x, turret.y, turret.phi)

        local aabb_min_x, aabb_max_x, aabb_min_y, aabb_max_y = 0, 0, 0, 0

        local poi = {
            {
                x = -6.5,
                y = 9.5
            },
            {
                x = 6.5,
                y = 9.5
            },
            {
                x = -6.5,
                y = -9.5
            },
            {
                x = 6.5,
                y = -9.5
            }
        }

        for i, v in ipairs(poi) do
            v.r = math.sqrt(v.x ^ 2 + v.y ^ 2)
            v.phi = math.atan2(v.y, v.x)

            v.phi = v.phi + turret.phi
            v.x = v.r * math.cos(v.phi)
            v.y = v.r * math.sin(v.phi)
        end

        for i, v in ipairs(poi) do
            if v.x < aabb_min_x then
                aabb_min_x = v.x
            end

            if v.x > aabb_max_x then
                aabb_max_x = v.x
            end

            if v.y < aabb_min_y then
                aabb_min_y = v.y
            end

            if v.y > aabb_max_y then
                aabb_max_y = v.y
            end
        end

        aabb_min_x = aabb_min_x + 2
        aabb_max_x = aabb_max_x - 2
        aabb_min_y = aabb_min_y + 2
        aabb_max_y = aabb_max_y - 2

        local hitbox_comp = EntityGetFirstComponentIncludingDisabled(turret.id, "HitboxComponent")
        ComponentSetValue2(hitbox_comp, "aabb_min_x", aabb_min_x)
        ComponentSetValue2(hitbox_comp, "aabb_max_x", aabb_max_x)
        ComponentSetValue2(hitbox_comp, "aabb_min_y", aabb_min_y)
        ComponentSetValue2(hitbox_comp, "aabb_max_y", aabb_max_y)
        EntitySetComponentIsEnabled(turret.id, hitbox_comp, true)

        --Child Entity Position
        local children = EntityGetAllChildren(turret.id)

        for i, child in ipairs(children) do
            if EntityHasTag(child, "mecha_turret_laser_spot") then
                EntitySetTransform(child, turret.x, turret.y)
                EntityApplyPolarTransform(child, 7, phi)
            end
        end

        --Set Hp of new turret
        local damage_model_comp = EntityGetFirstComponentIncludingDisabled(turret.id, "DamageModelComponent")
        ComponentSetValue2(damage_model_comp, "hp", -damage) --Negative of damage taken because healing damage is negative (negative of a negative is a positive) [yay primary school maths!]
    else
        --Reset Damage
        local broken_turret = {}
        broken_turret.id = GetUpdatedEntityID()

        local damage_model_comp = EntityGetFirstComponentIncludingDisabled(broken_turret.id, "DamageModelComponent")
        ComponentSetValue2(damage_model_comp, "hp", 999000)
    end
end
