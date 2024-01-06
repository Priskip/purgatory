dofile_once("data/scripts/lib/utilities.lua")
dofile_once("mods/purgatory/files/scripts/lib/utilities.lua")
dofile_once("data/scripts/perks/perk_list.lua")
dofile_once("data/scripts/game_helpers.lua")
dofile_once("data/scripts/perks/perk.lua")

--Dropping gold like a chest (from data/scripts/items/chest_random.lua)
function chest_load_gold_entity(entity_filename, x, y, remove_timer)
    local eid = load_gold_entity(entity_filename, x, y, remove_timer)
    local item_comp = EntityGetFirstComponent(eid, "ItemComponent")

    -- auto_pickup e.g. gold should have a delay in the next_frame_pickable, since they get gobbled up too fast by the player to see
    if item_comp ~= nil then
        if (ComponentGetValue2(item_comp, "auto_pickup")) then
            ComponentSetValue2(item_comp, "next_frame_pickable", GameGetFrameNum() + 30)
        end
    end
end

--Dropping Loot from Goal
function drop_loot(x, y, level)
    SetRandomSeed(x, GameGetFrameNum())

    --For gold drops
    local remove_gold_timer = false
    local comp_worldstate = EntityGetFirstComponent(GameGetWorldStateEntity(), "WorldStateComponent")
    if (comp_worldstate ~= nil) then
        if (ComponentGetValue2(comp_worldstate, "perk_gold_is_forever")) then
            remove_gold_timer = true
        end
    end

    if level == 1 then
        local num = Random(1, 2)

        if num == 1 then
            --random potion
            LoadPixelScene("data/biome_impl/wand_altar_vault.png", "data/biome_impl/wand_altar_vault_visual.png", x - 10,
                y - 35, "", true)
            EntityLoad("data/entities/items/pickup/potion.xml", x, y - 32)
        elseif num == 2 then
            -- Tier 2 wand
            EntityLoad("data/entities/items/wand_level_02_better.xml", x, y)
        end
    elseif level == 2 then
        local num = Random(1, 3)

        if num == 1 then
            --regular chest
            EntityLoad("data/entities/items/pickup/chest_random.xml", x, y)
        elseif num == 2 then
            --tier 3 wand
            EntityLoad("data/entities/items/wand_level_03_better.xml", x, y)
        elseif num == 3 then
            --1000 Gold
            for i = 1, 5 do
                chest_load_gold_entity("data/entities/items/pickup/goldnugget_200.xml", x + Random(-10, 10),
                    y - 4 + Random(-10, 5), remove_gold_timer)
            end
        end
    elseif level == 3 then
        local num = Random(1, 100)
        if num <= 15 then
            --random perk
            perk_spawn_random(x, y, false)
        elseif num > 15 and num <= 40 then
            --2500 gold
            chest_load_gold_entity("data/entities/items/pickup/goldnugget_1000.xml", x + Random(-10, 10),
                y - 4 + Random(-10, 5), remove_gold_timer)
            chest_load_gold_entity("data/entities/items/pickup/goldnugget_1000.xml", x + Random(-10, 10),
                y - 4 + Random(-10, 5), remove_gold_timer)
            chest_load_gold_entity("data/entities/items/pickup/goldnugget_200.xml", x + Random(-10, 10),
                y - 4 + Random(-10, 5), remove_gold_timer)
            chest_load_gold_entity("data/entities/items/pickup/goldnugget_200.xml", x + Random(-10, 10),
                y - 4 + Random(-10, 5), remove_gold_timer)
            chest_load_gold_entity("data/entities/items/pickup/goldnugget_50.xml", x + Random(-10, 10),
                y - 4 + Random(-10, 5), remove_gold_timer)
            chest_load_gold_entity("data/entities/items/pickup/goldnugget_50.xml", x + Random(-10, 10),
                y - 4 + Random(-10, 5), remove_gold_timer)
        elseif num > 40 and num <= 70 then
            -- healthium potion
            LoadPixelScene("data/biome_impl/wand_altar_vault.png", "data/biome_impl/wand_altar_vault_visual.png", x - 10,
                y - 35, "", true)
            spawn_potion_with_mat_type(x, y - 32, "magic_liquid_hp_regeneration", 1000)
        elseif num > 70 and num <= 100 then
            --tier 4 no shuf
            EntityLoad("data/entities/items/wand_unshuffle_04.xml", x, y)
        end
    elseif level == 4 then
        --Great Chest
        EntityLoad("data/entities/items/pickup/chest_random_super.xml", x, y)
    end
end

--------------------------
-- ACTUAL FUNCTION TIME --
--------------------------
function collision_trigger(colliding_entity)
    local entity_id = GetUpdatedEntityID()
    local x, y = EntityGetTransform(entity_id)

    --Get goal that skully is in
    local comps = EntityGetComponent(entity_id, "VariableStorageComponent")
    local loot_level = 0
    if (comps ~= nil) then
        for i, v in ipairs(comps) do
            local n = ComponentGetValue2(v, "name")
            if (n == "goal_level") then
                loot_level = ComponentGetValue2(v, "value_int")
            end
        end
    end

    --Summon Loot
    drop_loot(x, y, loot_level)

    --Particles! Yay!
    EntityLoad("mods/purgatory/files/entities/particles/skully_game/reward.xml", x, y - 4)

    --Kill all goals and foul lines
    local all_entities_in_range = EntityGetInRadius(x, y, 500)
    local ent_names_to_kill = {
        "skully_kicking_goal",
        "skully_kicking_foul_line",
        "skully_kicking_foul_line_black",
        "skully_kicking_skull",
        "skully_kicking_bone_small",
        "skully_kicking_bone_large",
        "skully_kicking_respawn_point",
        "skully_kicking_lantern"
    }

    for _, ent in ipairs(all_entities_in_range) do
        local name = EntityGetName(ent)
        for _, ent_name_to_kill in ipairs(ent_names_to_kill) do
            if name == ent_name_to_kill then
                EntityKill(ent)
            end
        end
    end
end
