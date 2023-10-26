dofile_once("data/scripts/lib/utilities.lua")
dofile_once("mods/purgatory/files/scripts/utils.lua")

--[[
--Update Enemy List
local enemy_list = ModTextFileGetContent("data/ui_gfx/animal_icons/_list.txt")
enemy_list = enemy_list.."/nmimic_cactus"
ModTextFileSetContent("data/ui_gfx/animal_icons/_list.txt", enemy_list)
]]

local EnemiesToRemove = {
    --"boss_dragon" 

    --Note Priskip 26 Oct 23: Even though I remove him from the list, he still pops up at the end because his icon exists in the vanilla data folder.
    --I would need a way to remove a file from the mod api, which currently does not exist.
    --Maybe ask Olli or Petri for a ModDeleteFile() function to be made?
    --For now, keep the vanilla dragon icon on the list and add the shadow dragon's icon after his
}

local EnemiesToAdd = {
    {
        enemy_name = "mimic_cactus",
        enemy_to_place_after = "chest_leggy"
    },
    {
        enemy_name = "boss_dragon_parallel",
        enemy_to_place_after = "boss_dragon"
    },
    {
        enemy_name = "boss_dragon_fire",
        enemy_to_place_after = "boss_dragon_parallel"
    },
    {
        enemy_name = "boss_dragon_ice",
        enemy_to_place_after = "boss_dragon_fire"
    },
    {
        enemy_name = "boss_dragon_poison",
        enemy_to_place_after = "boss_dragon_ice"
    },
    {
        enemy_name = "boss_robot_parallel",
        enemy_to_place_after = "boss_robot"
    },
    {
        enemy_name = "boss_wizard_parallel",
        enemy_to_place_after = "boss_wizard"
    }

}

local EnemiesToMove = {
    {
        enemy_name = "parallel_tentacles",
        enemy_to_place_after = "boss_pit"
    }
}

--Load enemy list from file and convert into table
local EnemyListString = ModTextFileGetContent("data/ui_gfx/animal_icons/_list.txt")
local EnemyListTable = {}
for s in EnemyListString:gmatch("[^\r\n]+") do
    table.insert(EnemyListTable, s)
end



--Removes a specified enemy form enemy list.
local function RemoveFromList(enemy_to_remove)
    local success = false
    for i, enemy_in_list in ipairs(EnemyListTable) do
        if enemy_in_list == enemy_to_remove then
            table.remove(EnemyListTable, i)
            success = true
            break
        end
    end

    return success
end

--Adds an enemy to the list
local function AddToList(enemy_to_add, enemy_name_to_place_after)
    local success = false
    for i, enemy_in_list in ipairs(EnemyListTable) do
        if enemy_in_list == enemy_name_to_place_after then
            table.insert(EnemyListTable, i + 1, enemy_to_add)
            success = true
            break
        end
    end

    return success
end

--Moves an enemy in the list to a different position
local function MoveInList(enemy_name, enemy_name_to_place_after)
    local success = false
    success = RemoveFromList(enemy_name)
    success = success and AddToList(enemy_name, enemy_name_to_place_after)

    return success
end

--Updates the Enemy Lists
local function UpdateEnemyList()
    for _, v in ipairs(EnemiesToRemove) do
        RemoveFromList(v)
    end

    for _, v in ipairs(EnemiesToAdd) do
        AddToList(v.enemy_name, v.enemy_to_place_after)
    end

    for _, v in ipairs(EnemiesToMove) do
        MoveInList(v.enemy_name, v.enemy_to_place_after)
    end

    --Write to File
    EnemyListString = ""
    for _, v in ipairs(EnemyListTable) do
        EnemyListString = EnemyListString .. v ..'\n'
    end
    ModTextFileSetContent("data/ui_gfx/animal_icons/_list.txt", EnemyListString)


end

return {
    UpdateEnemyList = UpdateEnemyList
}

--[[
    EnemiesToRemove
    Regular Dragon
]]

--[[
    EnemiesToAdd
    Fire dragon
    Ice dragon
    Poison Dragon
    Cactus Mimic
    Parallel dragon
    Parallel mecha kolmi
    Parallel master
]]
