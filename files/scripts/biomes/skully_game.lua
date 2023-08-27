-- default biome functions that get called if we can't find a a specific biome that works for us
CHEST_LEVEL = 0
dofile_once("data/scripts/director_helpers.lua")
dofile_once("data/scripts/biome_scripts.lua")

RegisterSpawnFunction(0xffffeedd, "init")
RegisterSpawnFunction(0xffff5b5f, "spawn_corpse")
RegisterSpawnFunction(0xffff0001, "spawn_goal_1")
RegisterSpawnFunction(0xffff0002, "spawn_goal_2")
RegisterSpawnFunction(0xffff0003, "spawn_goal_3")
RegisterSpawnFunction(0xffff0004, "spawn_goal_4")
RegisterSpawnFunction(0xffff0005, "spawn_foul_line")
RegisterSpawnFunction(0xffff0006, "spawn_lantern")

function init(x, y, w, h)
    local material_file = "mods/purgatory/files/biome_impl/skully_game/material.png"
    local visual_file = "mods/purgatory/files/biome_impl/skully_game/visual.png"
    local background_file = "mods/purgatory/files/biome_impl/skully_game/background.png"

    LoadPixelScene(material_file, visual_file, x, y, background_file, true)
end

function spawn_corpse(x, y)
    EntityLoad("mods/purgatory/files/entities/buildings/skully_game/skully.xml", x, y - 6) --original = y - 4
    EntityLoad("data/entities/props/physics_bone_01.xml", x + 8, y - 4)
    EntityLoad("data/entities/props/physics_bone_06.xml", x - 12, y - 4)
    EntityLoad("mods/purgatory/files/entities/items/books/skully_book.xml", x, y)
end

function spawn_goal_1(x, y)
    local goal = EntityLoad("mods/purgatory/files/entities/buildings/skully_game/goal.xml", x, y)

    local comps = EntityGetComponent(goal, "VariableStorageComponent")
    if (comps ~= nil) then
        for i, v in ipairs(comps) do
            local n = ComponentGetValue2(v, "name")
            if (n == "goal_level") then
                ComponentSetValue2(v, "value_int", 1)
            end
        end
    end
end

function spawn_goal_2(x, y)
    local goal = EntityLoad("mods/purgatory/files/entities/buildings/skully_game/goal.xml", x, y)

    local comps = EntityGetComponent(goal, "VariableStorageComponent")
    if (comps ~= nil) then
        for i, v in ipairs(comps) do
            local n = ComponentGetValue2(v, "name")
            if (n == "goal_level") then
                ComponentSetValue2(v, "value_int", 2)
            end
        end
    end
end

function spawn_goal_3(x, y)
    local goal = EntityLoad("mods/purgatory/files/entities/buildings/skully_game/goal.xml", x, y)

    local comps = EntityGetComponent(goal, "VariableStorageComponent")
    if (comps ~= nil) then
        for i, v in ipairs(comps) do
            local n = ComponentGetValue2(v, "name")
            if (n == "goal_level") then
                ComponentSetValue2(v, "value_int", 3)
            end
        end
    end
end

function spawn_goal_4(x, y)
    local goal = EntityLoad("mods/purgatory/files/entities/buildings/skully_game/goal.xml", x, y)

    local comps = EntityGetComponent(goal, "VariableStorageComponent")
    if (comps ~= nil) then
        for i, v in ipairs(comps) do
            local n = ComponentGetValue2(v, "name")
            if (n == "goal_level") then
                ComponentSetValue2(v, "value_int", 4)
            end
        end
    end
end

function spawn_foul_line(x, y)
    EntityLoad("mods/purgatory/files/entities/buildings/skully_game/foul_line.xml", x, y)
    --EntityLoad("mods/purgatory/files/entities/particles/skully_game/foul_line_white.xml", x+35, y+5) too visually overpowering
    EntityLoad("mods/purgatory/files/entities/particles/skully_game/foul_line_black.xml", x+35, y+5)
end

function spawn_lantern(x, y)
    EntityLoad("mods/purgatory/files/entities/props/physics/skully_lantern_01.xml", x, y)
end

--Wang gen systems (don't care about them) bite me
function spawn_small_enemies(x, y)
end

function spawn_big_enemies(x, y)
end

function spawn_items(x, y)
    return
end

function spawn_unique_enemy(x, y)
end

function spawn_lamp(x, y)
end

function spawn_props(x, y)
    return
end

function spawn_potions(x, y)
end

function spawn_shopitem(x, y)
end

function spawn_specialshop(x, y)
end

function spawn_treasure(x, y)
end

function spawn_music_machine(x, y)
end
