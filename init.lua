--Init file for Purgatory Game Mode

--Load Files
dofile_once("mods/purgatory/files/scripts/utils.lua")
dofile_once("mods/purgatory/files/translations/translations_utils.lua")
dofile_once("mods/purgatory/files/scripts/perks/perk_list_appends.lua")
dofile_once("mods/purgatory/files/scripts/perks/perk_spawn_purgatory.lua") --temp
dofile_once("mods/purgatory/files/materials/add_void_recipes.lua") --makes recipes for endless void
dofile_once("mods/purgatory/files/scripts/gun/initialize_starting_wands.lua") --temp
dofile_once("mods/purgatory/files/scripts/debug_mode_init.lua") --for debugging

--Load Mod Settings
local ascension_level = ModSettingGet("purgatory.ascension_level")
local reset_tree_achievements = ModSettingGet("purgatory.reset_tree_achievements")
local debug_mode = ModSettingGet("purgatory.debug_mode")
local input_seed = ModSettingGet("purgatory.seed_changer") --used for detecting secret seeds
local seed_to_set = ModSettingGet("purgatory.seed_setter")

--Append and Modify Translations
append_translations("mods/purgatory/files/translations/common.csv") --Adds all the descriptors for Purgatory

--Append Files
ModLuaFileAppend("data/scripts/gun/gun.lua", "mods/purgatory/files/scripts/gun/gun.lua") --For adding custom trigger types
ModLuaFileAppend("data/scripts/gun/gun_actions.lua", "mods/purgatory/files/scripts/gun/gun_actions.lua") --Custom Spells
ModLuaFileAppend("data/scripts/perks/perk_list.lua", "mods/purgatory/files/scripts/perks/perk_list_appends.lua") --Custom Perks
ModLuaFileAppend("data/scripts/items/potion.lua", "mods/purgatory/files/potion_appends.lua") --Custom Potion List
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
    print("Purgatory - OnModPreInit()")

    --Change Biomes Data (Calling it this way to hopefully avoid mod restart glitches)
    ModTextFileSetContent("data/biome/_biomes_all.xml", ModTextFileGetContent("mods/purgatory/files/biome/_biomes_all.xml")) --Overwrites the biome data with purgatory's scenes
    ModTextFileSetContent("data/biome/_pixel_scenes.xml", ModTextFileGetContent("mods/purgatory/files/biome/_pixel_scenes.xml")) --Overwrites the pixel scenes with purgatory's pixel scenes

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
    end
    ModTextFileSetContent("data/materials.xml", tostring(xml))

    --ceaseless void
    add_ceaseless_void_recipes(true)
end

function OnModInit()
    print("Purgatory - OnModInit()") -- After that this is called for all mods
end

function OnModPostInit()
    print("Purgatory - OnModPostInit()") -- Then this is called for all mods
end

--On Player Spawning
function OnPlayerSpawned(player_entity)
    --GamePrint( "Purgatory - OnPlayerSpawned()")
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
    --GamePrint( "Purgatory - OnMagicNumbersAndWorldSeedInitialized()")
end

function OnWorldInitialized() -- This is called once the game world is initialized. Doesn't ensure any world chunks actually exist. Use OnPlayerSpawned to ensure the chunks around player have been loaded or created.
    --GamePrint( "Purgatory - OnWorldInitialized()")
    set_biome_to_purgatory("clouds", 15, 0.5, ascension_level)
    set_biome_to_purgatory("coalmine", 3, 0.5, ascension_level)
    set_biome_to_purgatory("coalmine_alt", 3, 0.5, ascension_level)
    set_biome_to_purgatory("crypt", 15, 0.3, ascension_level)
    set_biome_to_purgatory("desert", 15, 0.5, ascension_level)
    set_biome_to_purgatory("excavationsite", 2, 0.5, ascension_level)
    set_biome_to_purgatory("forest", 15, 0.5, ascension_level)
    set_biome_to_purgatory("fungicave", 7, 0.5, ascension_level)
    set_biome_to_purgatory("pyramid", 7, 0.4, ascension_level)
    set_biome_to_purgatory("rainforest", 9, 0.5, ascension_level)
    set_biome_to_purgatory("rainforest_open", 9, 0.5, ascension_level)
    set_biome_to_purgatory("sandcave", 10, 0.4, ascension_level)
    set_biome_to_purgatory("snowcastle", 3.5, 0.5, ascension_level)
    set_biome_to_purgatory("snowcave", 2, 0.5, ascension_level)
    set_biome_to_purgatory("snowcave_tunnel", 7.5, 0.5, ascension_level)
    set_biome_to_purgatory("the_end", 50, 0.1, ascension_level)
    set_biome_to_purgatory("the_sky", 50, 0.1, ascension_level)
    set_biome_to_purgatory("vault", 12.5, 0.5, ascension_level)
    set_biome_to_purgatory("vault_frozen", 16, 0.25, ascension_level)
    set_biome_to_purgatory("wandcave", 16, 0.5, ascension_level)

    --tower
    for i = 2, 10, 1 do
        local biome_name = "tower/solid_wall_tower_" .. tostring(i)
        set_biome_to_purgatory(biome_name, 25, 0.2, ascension_level)
    end
end

function OnWorldPreUpdate() -- This is called every time the game is about to start updating the world
    --GamePrint( "Purgatory - OnWorldPreUpdate()")

    if debug_mode then
        local id = 1
        local function new_id()
            id = id + 1
            return id
        end
        gui = gui or GuiCreate()
        GuiStartFrame(gui)

        local player_id = getPlayerEntity()
        local x, y = EntityGetTransform(player_id)

        if GuiImageButton(gui, new_id(), 50, 0, "DB 1", "mods/purgatory/files/ui_gfx/perk_icons/roll_again.png") then
            local string_to_convert = "ABCDE.FG"
            local converted_string = ""

            for char in string_to_convert:gmatch "." do
                converted_string = converted_string .. string.byte(char)
            end

            --Seeds 1-4,294,967,295

            converted_string = tonumber(converted_string) % 4294967295

            print(converted_string)
        end
    end
end

function OnWorldPostUpdate() -- This is called every time the game has finished updating the world
    --GamePrint( "Purgatory - OnWorldPostUpdate()" .. tostring(GameGetFrameNum()) )
end

--[[
GuiSlider( gui:obj, id:int, x:number, y:number, text:string, value:number, value_min:number, value_max:number, value_default:number, value_display_multiplier:number, value_formatting:string, width:number ) -> new_value:number [This is not intended to be outside mod settings menu, and might bug elsewhere.]

<PlatformShooterPlayerComponent
    center_camera_on_this_entity="1"
    aiming_reticle_distance_from_character="60"
    camera_max_distance_from_character="50"
    move_camera_with_aim="1"
    eating_area_min.x="-6"
    eating_area_max.x="6"
    eating_area_min.y="-4"
    eating_area_max.y="6"
    eating_cells_per_frame="2"
  ></PlatformShooterPlayerComponent>

GameGetCameraPos() -> x:number,y:number
GameSetCameraPos( x:number, y:number )
GameSetCameraFree( is_free:bool )
GameGetCameraBounds() -> x:number,y:number,w:number,h:number [Returns the camera rectangle. This may not be 100% pixel perfect with regards to what you see on the screen. 'x','y' = top left corner of the rectangle.]

        local plaform_shooter_player_comp = EntityGetFirstComponentIncludingDisabled(player_id, "PlatformShooterPlayerComponent")
        local camera_centered = ComponentGetValue2(plaform_shooter_player_comp, "center_camera_on_this_entity")

        if GuiImageButton(gui, new_id(), 50, 0, "DB 1", "mods/purgatory/files/ui_gfx/perk_icons/roll_again.png") then
            if camera_centered == true then
                ComponentSetValue2(plaform_shooter_player_comp, "center_camera_on_this_entity", false)
                GamePrint("camera_centered set to false")
            elseif camera_centered == false then
                ComponentSetValue2(plaform_shooter_player_comp, "center_camera_on_this_entity", true)
                GamePrint("camera_centered set to true")
            end
        end

distance = distance or 50
        distance = GuiSlider(gui, new_id(), 25, 50, "distance", distance, 0, 200, 0, 1, "", 100)

        local controls_comp = EntityGetFirstComponentIncludingDisabled(player_id, "ControlsComponent")
        local cursor_x, cursor_y = ComponentGetValue2(controls_comp, "mMousePosition")
        local x_raw, y_raw = ComponentGetValue2(controls_comp, "mMousePositionRaw")

        local left, up, w, h = GameGetCameraBounds()

        GuiText(gui, 25, 70, tostring(cursor_x))
        GuiText(gui, 25, 80, tostring(cursor_y))

        GuiText(gui, 25, 100, tostring(x_raw))
        GuiText(gui, 25, 110, tostring(y_raw))

        GuiText(gui, 25, 130, tostring(left))
        GuiText(gui, 25, 140, tostring(up))
        GuiText(gui, 25, 150, tostring(w))
        GuiText(gui, 25, 160, tostring(h))
]]
