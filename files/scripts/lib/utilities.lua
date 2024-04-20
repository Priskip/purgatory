--Utils for Purgatory
dofile_once("data/scripts/lib/utilities.lua")
dofile_once("data/scripts/perks/perk.lua")
dofile_once("data/scripts/perks/perk_list.lua")

-- Returns player
function getPlayerEntity()
    local players = EntityGetWithTag("player_unit")
    if #players == 0 then
        return
    end
    return players[1]
end

-- Returns player's x,y
function getPlayerCoords()
    local player = getPlayerEntity()
    return EntityGetTransform(player)
end

--Gives a perk to the player without the notification.
function addPerkToPlayer(perk_id)
    local player_entity = getPlayerEntity()
    local x, y = getPlayerCoords()

    --Create Perk to pick up
    local perk_entity = perk_spawn(x, y, perk_id)

    --Pick up Perk
    --function perk_pickup( entity_item, entity_who_picked, item_name, do_cosmetic_fx, kill_other_perks, no_perk_entity_ ) from data/scripts/perks/perk.lua
    perk_pickup(perk_entity, player_entity, nil, false, false)
end

--For giving the player starting spells
function addSpellToPlayerInventory(spell_id)
    local player_entity = getPlayerEntity()
    local x, y = getPlayerCoords()
    local action_entity = CreateItemActionEntity(spell_id, x, y)

    local full_inventory = nil
    local player_child_entities = EntityGetAllChildren(player_entity)
    if player_child_entities ~= nil then
        for i, child_entity in ipairs(player_child_entities) do
            if EntityGetName(child_entity) == "inventory_full" then
                full_inventory = child_entity
                break
            end
        end
    end

    if full_inventory ~= nil then
        EntitySetComponentsWithTagEnabled(action_entity, "enabled_in_world", false)
        EntityAddChild(full_inventory, action_entity)
    end
end

function getRandomFromList(target)
    local rnd = Random(1, #target)

    return tostring(target[rnd])
end

--Set Biomes to Purgatory
function setBiomeToPurgatory(biome_name, hp_scale, attack_speed, ascension_level)
    local ascension_scale_hp = 0.1
    local adjusted_hp_scale = hp_scale + ascension_scale_hp * ascension_level
    local adjusted_attack_speed_scale = attack_speed / (ascension_level + 1)

    BiomeSetValue(biome_name, "game_enemy_hp_scale", adjusted_hp_scale)
    BiomeSetValue(biome_name, "game_enemy_attack_speed", adjusted_attack_speed_scale)
end

--TO DO: find all the places I've rewritten this function and delete it
function in_range(num, lower, upper)
    if num >= lower and num <= upper then
        return true
    else
        return false
    end
end

-- returns currently active wand id, or returns -1 if it is not a wand
function getHeldWandID()
    local i2c_id = EntityGetFirstComponentIncludingDisabled(getPlayerEntity(), "Inventory2Component")
    local wand_id = ComponentGetValue2(i2c_id, "mActiveItem")
    if (EntityHasTag(wand_id, "wand")) then
        return wand_id
    else
        return -1
    end
end

-- returns maximum mana active wand has
function getHeldWandMaxMana()
    local mana_max = 0
    local active_wand_id = getHeldWandID()
    if (active_wand_id ~= -1) then
        local ac_id = EntityGetFirstComponentIncludingDisabled(active_wand_id, "AbilityComponent")
        mana_max = ComponentGetValue2(ac_id, "mana_max")
    end
    return mana_max
end

-- returns current mana active wand has
function getHeldWandCurrentMana()
    local mana = 0
    local active_wand_id = getHeldWandID()
    if (active_wand_id ~= -1) then
        local ac_id = EntityGetFirstComponentIncludingDisabled(active_wand_id, "AbilityComponent")
        mana = ComponentGetValue2(ac_id, "mana")
    end
    return mana
end

--Spawn Potion of a specific material type
function spawnPotionWithMaterialType(x, y, material, amount)
    local potion_ent = EntityLoad("mods/purgatory/files/entities/items/pickup/specific_potion.xml", x, y)
    AddMaterialInventoryMaterial(potion_ent, material, amount)
    --TODO Make this support Extra Potion Capacity perk in case I add that thing back
end

--Returns a Random Value between a and b in target format {a, b}
function getRandomWithinRange(target)
    local minval = target[1]
    local maxval = target[2]

    return Random(minval, maxval)
end

--Counts the number of times the string "seeker" appears in the string "target"
function findAmountOfStringsInString(target, seeker)
    local cond = true
    local count = 0

    while cond do
        local i, j = string.find(target, seeker)
        if i == nil then
            cond = false
        else
            target = string.gsub(target, seeker, "", 1)
            count = count + 1
        end
    end

    return count
end

--Round number to nearest int
function roundToInt(num)
    return math.floor(num + 0.5)
end

--Variable Storage Helpers
function variableStorageGetValue(entity_id, type, name)
    local var_stor_comps = EntityGetComponent(entity_id, "VariableStorageComponent")
    local value = nil
    --types
    if type == "STRING" then
        type = "value_string"
    elseif type == "INT" then
        type = "value_int"
    elseif type == "BOOL" then
        type = "value_bool"
    elseif type == "FLOAT" then
        type = "value_float"
    else
        type = nil
        --print('Purgatory: variableStorageGetValue(entity_id, type, name) incorrect type given. Must be either "STRING", "INT", "BOOL", or "FLOAT"')
    end

    if (var_stor_comps ~= nil) then
        for i, v in ipairs(var_stor_comps) do
            local n = ComponentGetValue2(v, "name")
            if (n == name) then
                value = ComponentGetValue2(v, type)
            end
        end
    else
        --print("Purgatory: variableStorageGetValue(entity_id, type, name) Entity has no variable storage components")
    end

    return value
end

function variableStorageSetValue(entity_id, type, name, value)
    local var_stor_comps = EntityGetComponent(entity_id, "VariableStorageComponent")
    --types
    if type == "STRING" then
        type = "value_string"
    elseif type == "INT" then
        type = "value_int"
    elseif type == "BOOL" then
        type = "value_bool"
    elseif type == "FLOAT" then
        type = "value_float"
    else
        type = nil
        --print('Purgatory: variableStorageSetValue(entity_id, type, name) incorrect type given. Must be either "STRING", "INT", "BOOL", or "FLOAT"')
        return nil
    end

    if (var_stor_comps ~= nil) then
        for i, v in ipairs(var_stor_comps) do
            local n = ComponentGetValue2(v, "name")
            if (n == name) then
                ComponentSetValue2(v, type, value)
            end
        end
    else
        --print("Purgatory: variableStorageSetValue(entity_id, type, name) Entity has no variable storage components")
    end
end

--Functions for getting items from player's inventory (Thank you Horscht!)
function isItem(entity)
    local ability_component = EntityGetFirstComponentIncludingDisabled(entity, "AbilityComponent")
    local ending_mc_guffin_component = EntityGetFirstComponentIncludingDisabled(entity, "EndingMcGuffinComponent")
    return (not ability_component) or ending_mc_guffin_component or ComponentGetValue2(ability_component, "use_gun_script") == false
end

function getInventory()
    local player = EntityGetWithTag("player_unit")[1]
    if player then
        for i, child in ipairs(EntityGetAllChildren(player) or {}) do
            if EntityGetName(child) == "inventory_quick" then
                return child
            end
        end
    end
end

function getHeldItems()
    local inventory = getInventory()
    local items = {}
    if inventory then
        for i, item in ipairs(EntityGetAllChildren(inventory) or {}) do
            if isItem(item) then
                table.insert(items, item)
            end
        end
    end
    return items
end

--makes the first letter in a string a capital letter
function firstLetterToUpper(str)
    return (str:gsub("^%l", string.upper))
end

--Returns the distance between and the angle between two entities
--Useful for pointing something from ent 1 to ent 2
--phi is returned in radians from 0 to 2pi (instead of -pi to pi)
--gotten by taking phi(a) = atan(sin(a)/cos(a)) and applying an LTI shift 2phi((a-pi)/2)+pi
function getRandPhi(x1, y1, x2, y2)
    local dx = x2 - x1
    local dy = y2 - y1

    local r = math.sqrt(dx ^ 2 + dy ^ 2)

    local phi = -2 * math.atan((dy / r) / (1 - dx / r)) + math.pi

    if dx / r == 1 then
        phi = 0 --freakin' edge cases man
    --lim atan(x) x --> inf = pi/2 thus phi = 0
    end

    return r, phi
end

--Split a string separated by a specific character into a table
function splitStringOnCharIntoTable(string, char)
    local list = {}
    for w in (string .. char):gmatch("([^" .. char .. "]*)" .. char) do
        table.insert(list, w)
    end
    return list
end

--Assemble a table of values into a single string split by a specific character
function tableToCharSeperatedString(list, char)
    local string = ""
    for i, v in ipairs(list) do
        string = string .. v
        if i ~= #list then
            string = string .. char
        end
    end
    return string
end

--Applies a polar shift to an entity
--phi must be between -pi to pi
function entityApplyPolarTransform(entity_id, r, phi)
    local dx = r * math.cos(phi)
    local dy = r * math.sin(phi)

    local x, y = EntityGetTransform(entity_id)

    EntitySetTransform(entity_id, x + dx, y + dy)
end

--Return the first index with the given value (or nil if not found).
function findElementInTable(array, value)
    for i, v in ipairs(array) do
        if v == value then
            return i
        end
    end
    return nil
end

--Returns true or false if a table has a value
function isInTable(table, value)
    local output = false
    for i, v in ipairs(table) do
        if v == value then
            output = true
            break
        end
    end
    return output
end

--Returns a list of entities with name specified with a radius of x and y
--tag is optional - if provided, will only search entities in area with said tag
function getEntityInRadiusWithName(x, y, radius, name, tag)
    local entities = {}
    local entities_with_name = {}

    if tag == nil then
        entities = EntityGetInRadius(x, y, radius)
    else
        entities = EntityGetInRadiusWithTag(x, y, radius, tag)
    end

    for i, v in ipairs(entities) do
        local ent_name = EntityGetName(v)
        if ent_name == name then
            table.insert(entities_with_name, 1, v)
        end
    end

    return entities_with_name
end

--Sticks two tables together
function concatenateTables(t1, t2)
    local conc_table = t1
    for i, v in ipairs(t2) do
        conc_table[#conc_table + 1] = v
    end
    return conc_table
end

--Returns either "m+kb" or "ctrl" depending on what the user is using and what the value of ModSettingGet("purgatory.input_device") is.
function getDisplayType()
    local draw_type = ModSettingGet("purgatory.input_device")
    DETECTED_INPUT_TYPE = DETECTED_INPUT_TYPE or "nothing detected"

    if draw_type == "auto" then
        if DETECTED_INPUT_TYPE ~= "m_kb" then
            for i = 1, 7 do
                if InputIsMouseButtonJustDown(i) then
                    DETECTED_INPUT_TYPE = "m_kb"
                    break
                end
            end
        end

        if DETECTED_INPUT_TYPE ~= "ctrl" then
            for i = 1, 56 do
                if InputIsJoystickButtonJustDown(0, i) then
                    DETECTED_INPUT_TYPE = "ctrl"
                    break
                end
            end
        end

        return DETECTED_INPUT_TYPE
    else
        return draw_type
    end
end