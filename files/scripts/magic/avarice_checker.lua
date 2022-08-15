dofile_once("data/scripts/lib/utilities.lua")
dofile_once("mods/purgatory/files/scripts/utils.lua")

local entity_id = GetUpdatedEntityID()
local x, y = EntityGetTransform(entity_id)

local flash = EntityGetInRadiusWithTag(x, y, 16, "small_friend")
local player = EntityGetInRadiusWithTag(x, y, 16, "player_unit")
local big_friend = EntityGetInRadiusWithTag(x, y, 16, "big_friend")
local sun = EntityGetInRadiusWithTag(x, y, 56, "seed_e")
local sun_dark = EntityGetInRadiusWithTag(x, y, 56, "seed_f")

if (#flash > 0) then
    CreateItemActionEntity("NUKE_GIGA", x, y)
    AddFlagPersistent("card_unlocked_nukegiga")
    EntityLoad("data/entities/projectiles/deck/nuke.xml", x, y)
    AddFlagPersistent("final_secret_orb")
elseif (#big_friend > 0) then
    CreateItemActionEntity("BOMB_HOLY_GIGA", x, y)
    AddFlagPersistent("card_unlocked_bomb_holy_giga")
    EntityLoad("data/entities/projectiles/deck/nuke.xml", x, y)
    AddFlagPersistent("final_secret_orb2")
elseif GameHasFlagRun("greed_curse") and (GameHasFlagRun("greed_curse_gone") == false) and (#player > 0) then
    CreateItemActionEntity("DIVIDE_10", x, y)
    AddFlagPersistent("card_unlocked_divide")

    EntityKill(entity_id)
elseif (#player > 0) then
    local player_id = getPlayerEntity()
    local x_player, y_player = EntityGetTransform(player_id)

    local potion_ents = EntityGetInRadiusWithTag(x_player, y_player, 24, "potion")

    for i, potion in ipairs(potion_ents) do
        --Get the Amount of Liquid
        local mat_inv_comp = EntityGetFirstComponentIncludingDisabled(potion, "MaterialInventoryComponent")
        local count_per_material_type = {}
        local amount_of_material = 0

        count_per_material_type = ComponentGetValue2(mat_inv_comp, "count_per_material_type")

        for i, v in ipairs(count_per_material_type) do
            if v ~= 0 then
                amount_of_material = amount_of_material + v
                AddMaterialInventoryMaterial(potion, CellFactory_GetName(i - 1), 0)
            end
        end

        AddMaterialInventoryMaterial(potion, "diamond", amount_of_material)
    end

    local sack_ents = EntityGetInRadiusWithTag(x_player, y_player, 24, "powder_stash")

    for i, sack in ipairs(sack_ents) do
        --Get the Amount of Liquid
        local mat_inv_comp = EntityGetFirstComponentIncludingDisabled(sack, "MaterialInventoryComponent")
        local count_per_material_type = {}
        local amount_of_material = 0

        count_per_material_type = ComponentGetValue2(mat_inv_comp, "count_per_material_type")

        for i, v in ipairs(count_per_material_type) do
            if v ~= 0 then
                amount_of_material = amount_of_material + v
                AddMaterialInventoryMaterial(sack, CellFactory_GetName(i - 1), 0)
            end
        end

        AddMaterialInventoryMaterial(sack, "diamond", amount_of_material)
    end
end

if #sun > 0 then
    local light_sun_sacced = GameHasFlagRun("light_sun_sacced_to_avarice")
    if light_sun_sacced == false then
        --Add Flag that Light Sun has been sacced to avarice
        GameAddFlagRun("light_sun_sacced_to_avarice")

        --Kill Light Sun
        for i, v in ipairs(sun) do
            EntityKill(v)
        end

        --Display Event Text
        if GameHasFlagRun("dark_sun_sacced_to_avarice") then
            GamePrintImportant("$log_sac_light_sun_avarice_second", "$logdesc_sac_light_sun_avarice_second")
        else
            GamePrintImportant("$log_sac_light_sun_avarice_first", "$logdesc_sac_light_sun_avarice_first")

            --Reload Avarice Diamond
            LoadPixelScene("data/biome_impl/greed_treasure.png", "", x - 255, y - 248, "data/biome_impl/greed_treasure_background.png", true)
            EntityLoad("mods/purgatory/files/entities/buildings/avarice_checker.xml", x, y)
        end

        --Play Sound
        GameTriggerMusicFadeOutAndDequeueAll(3.0)
        GameTriggerMusicEvent("music/oneshot/dark_01", true, x, y)

        --Remove sun in moon tag
        RemoveFlagPersistent("moon_is_sun")
    end

    EntityKill(entity_id)
end

if #sun_dark > 0 then
    local dark_sun_sacced = GameHasFlagRun("dark_sun_sacced_to_avarice")
    if dark_sun_sacced == false then
        --Add Flag that Dark Sun has been sacced to avarice
        GameAddFlagRun("dark_sun_sacced_to_avarice")

        --Kill Dark Sun
        for i, v in ipairs(sun_dark) do
            EntityKill(v)
        end

        --Display Event Text
        if GameHasFlagRun("light_sun_sacced_to_avarice") then
            GamePrintImportant("$log_sac_dark_sun_avarice_second", "$logdesc_sac_dark_sun_avarice_second")
        else
            GamePrintImportant("$log_sac_dark_sun_avarice_first", "$logdesc_sac_dark_sun_avarice_first")

            --Reload Avarice Diamond
            LoadPixelScene("data/biome_impl/greed_treasure.png", "", x - 255, y - 248, "data/biome_impl/greed_treasure_background.png", true)
            EntityLoad("mods/purgatory/files/entities/buildings/avarice_checker.xml", x, y)
        end

        --Play Sound
        GameTriggerMusicFadeOutAndDequeueAll(3.0)
        GameTriggerMusicEvent("music/oneshot/dark_01", true, x, y)

        --Remove sun in moon tag
        RemoveFlagPersistent("darkmoon_is_darksun")
    end

    EntityKill(entity_id)
end

if (GameHasFlagRun("light_sun_sacced_to_avarice") and GameHasFlagRun("dark_sun_sacced_to_avarice")) then
    CreateItemActionEntity("OMEGA_NUKE", x, y)
    AddFlagPersistent("purgatory_omega_nuke")
end
