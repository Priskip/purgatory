--Init file for Purgatory Game Mode

--Load Files
dofile_once("mods/purgatory/files/scripts/utils.lua")
dofile_once("mods/purgatory/files/translations/translations_utils.lua")
dofile_once("mods/purgatory/files/scripts/perks/perk_list_appends.lua")
dofile_once("mods/purgatory/files/scripts/biomes/biome_helpers.lua")
dofile_once("mods/purgatory/files/scripts/perks/perk_spawn_purgatory.lua") --temp
dofile_once("mods/purgatory/files/materials/add_void_recipes.lua") --makes recipes for endless void
dofile_once("mods/purgatory/files/scripts/debug_mode_init.lua") --for debugging

--Load Mod Settings
local ascension_level = ModSettingGet("purgatory.ascension_level")
local reset_tree_achievements = ModSettingGet("purgatory.reset_tree_achievements")
local debug_mode = ModSettingGet("purgatory.debug_mode")
local input_seed = ModSettingGet("purgatory.seed_changer") --used for detecting secret seeds
local seed_to_set = ModSettingGet("purgatory.seed_setter")

--Append and Modify Translations
append_translations("mods/purgatory/files/translations/common.csv") --Adds all the descriptors for Purgatory

--Hacking Nolla's systems (I don't get it but it works)
get_content = ModTextFileGetContent
set_content = ModTextFileSetContent
mod_lua_file_append = ModLuaFileAppend

--Append Files
ModLuaFileAppend("data/scripts/gun/gun.lua", "mods/purgatory/files/scripts/gun/gun.lua") --For adding custom trigger types
ModLuaFileAppend("data/scripts/gun/gun_actions.lua", "mods/purgatory/files/scripts/gun/gun_actions.lua") --Custom Spells
ModLuaFileAppend("data/scripts/perks/perk_list.lua", "mods/purgatory/files/scripts/perks/perk_list_appends.lua") --Custom Perks
ModLuaFileAppend("data/scripts/director_helpers.lua", "mods/purgatory/files/director_helpers_appends.lua") --Nightmare perks and wands to enemies
ModLuaFileAppend("data/entities/animals/boss_centipede/ending/sampo_start_ending_sequence.lua", "mods/purgatory/files/sampo_ending_appends.lua") --Special Sampo Endings for tree chieves
ModMaterialsFileAdd("mods/purgatory/files/materials/materials_appends.xml") --Adds materials
if not debug_mode then
    ModMagicNumbersFileAdd("mods/purgatory/files/magic_numbers.xml") --Sets the biome map
else
    ModMagicNumbersFileAdd("mods/purgatory/files/debug_magic_numbers.xml") --Sets the biome map to debug mode
end

--Custom Seed Parameters
local start_with_edit = true
if input_seed == "noedit" then
    start_with_edit = false
    seed_to_set = 0
end

--Set Custom Seed
if seed_to_set ~= 0 then
    local set_seed_xml = '<MagicNumbers WORLD_SEED="' .. tostring(seed_to_set) .. '" _DEBUG_DONT_SAVE_MAGIC_NUMBERS="1"/>'
    ModTextFileSetContent("mods/purgatory/files/set_seed.xml", set_seed_xml)
    ModMagicNumbersFileAdd("mods/purgatory/files/set_seed.xml")
end

function OnModPreInit()
    --Change Biomes Data
    AddBiomes("mods/purgatory/files/biome/biomes_to_add.xml")
    ModTextFileSetContent("data/biome/_pixel_scenes.xml", ModTextFileGetContent("mods/purgatory/files/biome/_pixel_scenes.xml")) --Overwrites the pixel scenes with purgatory's pixel scenes
    --TO DO: Since I overhauled the biomes to injection instead of outright replacement, I should do the same with the pixel scenes

    --Remove Edit Wands Everywhere if playing the no wand editting challenge run.
    if start_with_edit == false then
        remove_perk("EDIT_WANDS_EVERYWHERE")
    end

    --Reset tree achieves if needed to do.
    if reset_tree_achievements == true then
        RemoveFlagPersistent("purgatory_win")
        RemoveFlagPersistent("purgatory_win_no_edit_start")
        RemoveFlagPersistent("purgatory_great_chest_sac")
        RemoveFlagPersistent("purgatory_omega_nuke")
        ModSettingSet("purgatory.reset_tree_achievements", false)
    end

    --Modify Materials List
    --  Make Healthium Drink Only
    --  Hastium have its own tag for hastium stone to absorb
    local nxml = dofile_once("mods/purgatory/libraries/nxml.lua")
    local content = ModTextFileGetContent("data/materials.xml")
    local xml = nxml.parse(content)
    for element in xml:each_child() do
        if element.attr.name == "magic_liquid_hp_regeneration" then
            element.attr.liquid_stains = 0
        end

        if element.attr.name == "magic_liquid_faster_levitation_and_movement" then
            element.attr.tags = "[liquid],[water],[magic_liquid],[impure],[magic_faster],[magic_haste]"
        end

        if element.attr.name == "smoke" then
            element.attr.tags = "[gas],[smoke]" --Adding colored smokes and want to have all smokes have a smoke tag
        end

        if element.attr.name == "blood" then
            element.attr.tags = "[liquid],[corrodible],[soluble],[blood],[impure],[liquid_common],[food],[vampire_food]"
        --adding a tag to blood for the vampirism field
        end
    end
    ModTextFileSetContent("data/materials.xml", tostring(xml))

    --ceaseless void
    add_ceaseless_void_recipes(true)
end

function OnModInit()
end

function OnModPostInit()
end

function OnPlayerSpawned(player_entity)
    local purgatory_initiated = GameHasFlagRun("run_purgatory")

    if not purgatory_initiated then
        --Make Player Squishy
        local damagemodels = EntityGetComponent(player_entity, "DamageModelComponent")
        if (damagemodels ~= nil) then
            for i, damagemodel in ipairs(damagemodels) do
                local ascension_scale = 0.25

                local melee = tonumber(ComponentObjectGetValue(damagemodel, "damage_multipliers", "melee"))
                local projectile = tonumber(ComponentObjectGetValue(damagemodel, "damage_multipliers", "projectile"))
                local explosion = tonumber(ComponentObjectGetValue(damagemodel, "damage_multipliers", "explosion"))
                local electricity = tonumber(ComponentObjectGetValue(damagemodel, "damage_multipliers", "electricity"))
                local fire = tonumber(ComponentObjectGetValue(damagemodel, "damage_multipliers", "fire"))
                local drill = tonumber(ComponentObjectGetValue(damagemodel, "damage_multipliers", "drill"))
                local slice = tonumber(ComponentObjectGetValue(damagemodel, "damage_multipliers", "slice"))
                local ice = tonumber(ComponentObjectGetValue(damagemodel, "damage_multipliers", "ice"))
                local healing = tonumber(ComponentObjectGetValue(damagemodel, "damage_multipliers", "healing"))
                local physics_hit = tonumber(ComponentObjectGetValue(damagemodel, "damage_multipliers", "physics_hit"))
                local radioactive = tonumber(ComponentObjectGetValue(damagemodel, "damage_multipliers", "radioactive"))
                local poison = tonumber(ComponentObjectGetValue(damagemodel, "damage_multipliers", "poison"))
                local holy = tonumber(ComponentObjectGetValue(damagemodel, "damage_multipliers", "holy"))

                melee = melee * (3 + ascension_scale * ascension_level)
                projectile = projectile * (2 + ascension_scale * ascension_level)
                explosion = explosion * (2 + ascension_scale * ascension_level)
                electricity = electricity * (2 + ascension_scale * ascension_level)
                fire = fire * (2 + ascension_scale * ascension_level)
                drill = drill * (2 + ascension_scale * ascension_level)
                slice = slice * (2 + ascension_scale * ascension_level)
                ice = ice * (2 + ascension_scale * ascension_level)
                radioactive = radioactive * (2 + ascension_scale * ascension_level)
                poison = poison * (3 + ascension_scale * ascension_level)
                holy = holy * (3 + ascension_scale * ascension_level)

                ComponentObjectSetValue(damagemodel, "damage_multipliers", "melee", tostring(melee))
                ComponentObjectSetValue(damagemodel, "damage_multipliers", "projectile", tostring(projectile))
                ComponentObjectSetValue(damagemodel, "damage_multipliers", "explosion", tostring(explosion))
                ComponentObjectSetValue(damagemodel, "damage_multipliers", "electricity", tostring(electricity))
                ComponentObjectSetValue(damagemodel, "damage_multipliers", "fire", tostring(fire))
                ComponentObjectSetValue(damagemodel, "damage_multipliers", "drill", tostring(drill))
                ComponentObjectSetValue(damagemodel, "damage_multipliers", "slice", tostring(slice))
                ComponentObjectSetValue(damagemodel, "damage_multipliers", "ice", tostring(ice))
                ComponentObjectSetValue(damagemodel, "damage_multipliers", "healing", tostring(healing))
                ComponentObjectSetValue(damagemodel, "damage_multipliers", "physics_hit", tostring(physics_hit))
                ComponentObjectSetValue(damagemodel, "damage_multipliers", "radioactive", tostring(radioactive))
                ComponentObjectSetValue(damagemodel, "damage_multipliers", "poison", tostring(poison))
                ComponentObjectSetValue(damagemodel, "damage_multipliers", "holy", tostring(holy))
            end
        end

        --Give Player Edit Wands Everywhere
        if start_with_edit then
            --addPerkToPlayer("ABILITY_ACTIONS_MATERIALIZED")
            addPerkToPlayer("EDIT_WANDS_EVERYWHERE")
        else
            GameAddFlagRun("purgatory_no_edit_run")
            remove_perk("EDIT_WANDS_EVERYWHERE") --TODO Well this didn't work for some reason
        end

        --Add Flag to not repeat damage multipliers
        GameAddFlagRun("run_purgatory")

        --Give player some spark bolts and bombs in case wand RNG screws them (only in case they can edit)
        if start_with_edit == true then
            local spells_to_give_player = {
                "LIGHT_BULLET",
                "LIGHT_BULLET",
                "LIGHT_BULLET",
                "BOMB"
            }

            for i, v in ipairs(spells_to_give_player) do
                addSpellToPlayerInventory(v)
            end
        end

        --Add run flag for ascension level
        GameAddFlagRun("run_ascension_level_" .. tonumber(ascension_level))

        --Give player a script component to remove used extra lives perks (execute every 10 seconds)
        --TODO: Make this get assigned and removed with the perk
        local lua_comp = EntityAddComponent(player_entity, "LuaComponent")
        ComponentSetValue(lua_comp, "script_source_file", "mods/purgatory/files/scripts/misc/remove_spent_extra_lives_from_UI.lua")
        ComponentSetValue(lua_comp, "execute_every_n_frame", "600")

        --Give player a script component to initialize the starting wands after they have loaded in
        local lua_comp_2 = EntityAddComponent(player_entity, "LuaComponent")
        ComponentSetValue(lua_comp_2, "script_source_file", "mods/purgatory/files/scripts/misc/initialize_starting_wands_delay.lua")
        ComponentSetValue(lua_comp_2, "execute_every_n_frame", "60")
        ComponentSetValue(lua_comp_2, "remove_after_executed", "1")

        if debug_mode then
            debug_mod_init(player_entity)
        end
    end --end if not purgatory_initiated
end -- function OnPlayerSpawned(player_entity)

function OnMagicNumbersAndWorldSeedInitialized() -- this is the last point where the Mod* API is available. after this materials.xml will be loaded.
end

function OnWorldInitialized() -- This is called once the game world is initialized. Doesn't ensure any world chunks actually exist. Use OnPlayerSpawned to ensure the chunks around player have been loaded or created.
    set_biome_to_purgatory("data/biome/clouds.xml", 15, 0.5, ascension_level)
    set_biome_to_purgatory("data/biome/coalmine.xml", 3, 0.5, ascension_level)
    set_biome_to_purgatory("data/biome/coalmine_alt.xml", 3, 0.5, ascension_level)
    set_biome_to_purgatory("data/biome/crypt.xml", 15, 0.3, ascension_level)
    set_biome_to_purgatory("data/biome/desert.xml", 15, 0.5, ascension_level)
    set_biome_to_purgatory("data/biome/excavationsite.xml", 2, 0.5, ascension_level)
    set_biome_to_purgatory("data/biome/forest.xml", 15, 0.5, ascension_level)
    set_biome_to_purgatory("data/biome/fungicave.xml", 7, 0.5, ascension_level)
    set_biome_to_purgatory("data/biome/pyramid.xml", 7, 0.4, ascension_level)
    set_biome_to_purgatory("data/biome/rainforest.xml", 9, 0.5, ascension_level)
    set_biome_to_purgatory("data/biome/rainforest_open.xml", 9, 0.5, ascension_level)
    set_biome_to_purgatory("data/biome/sandcave.xml", 10, 0.4, ascension_level)
    set_biome_to_purgatory("data/biome/snowcastle.xml", 3.5, 0.5, ascension_level)
    set_biome_to_purgatory("mods/purgatory/files/biome/hiisi_forge.xml", 3.5, 0.5, ascension_level)
    set_biome_to_purgatory("data/biome/snowcave.xml", 2, 0.5, ascension_level)
    set_biome_to_purgatory("data/biome/snowcave_tunnel.xml", 7.5, 0.5, ascension_level)
    set_biome_to_purgatory("data/biome/the_end.xml", 50, 0.1, ascension_level)
    set_biome_to_purgatory("data/biome/the_sky.xml", 50, 0.1, ascension_level)
    set_biome_to_purgatory("data/biome/vault.xml", 12.5, 0.5, ascension_level)
    set_biome_to_purgatory("data/biome/vault_frozen.xml", 16, 0.25, ascension_level)
    set_biome_to_purgatory("data/biome/wandcave.xml", 16, 0.5, ascension_level)

    --tower [TODO: Mess about with this]
    for i = 2, 10, 1 do
        local biome_name = "data/biome/tower/solid_wall_tower_" .. tostring(i) .. ".xml"
        set_biome_to_purgatory(biome_name, 25, 0.2, ascension_level)
    end
end

function OnWorldPreUpdate() -- This is called every time the game is about to start updating the world
    if debug_mode then
        local id = 1
        local function new_id()
            id = id + 1
            return id
        end
        gui = gui or GuiCreate()
        GuiStartFrame(gui)

        local player_id = EntityGetWithTag("player_unit")[1]
        local x, y = EntityGetTransform(player_id)

        if GuiImageButton(gui, new_id(), 100, 0, "Button", "mods/purgatory/files/ui_gfx/debug/button_1.png") then
            --EntityIngestMaterial(player_id, CellFactory_GetType("blood"), 500)
            --EntityLoad("mods/purgatory/files/test/test_entity.xml", x, y - 30)

            local entity_id = EntityGetInRadiusWithTag(x, y, 50, "item_perk")[1] --or however you get your ent id
            local item_comp = EntityGetFirstComponent(entity_id, "ItemComponent")
            ComponentSetValue2(item_comp, "ui_description", "$your_UI_description_here")
            
        end

    --[[
        EntityIngestMaterial( entity:int, material_type:number, amount:number ) 
        [Has the same effects that would occur if 'entity' eats 'amount' number of cells of 'material_type' from the game world. 
        Use this instead of directly modifying IngestionComponent values, if possible. Might not work with non-player entities. 
        Use CellFactory_GetType() to convert a material name to material type.]
    ]]
    end
end

function OnWorldPostUpdate() -- This is called every time the game has finished updating the world
end
