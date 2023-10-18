dofile_once("data/scripts/lib/utilities.lua")
dofile_once("mods/purgatory/files/scripts/utils.lua")

local entity_id = GetUpdatedEntityID()
local pos_x, pos_y = EntityGetTransform(entity_id)
local player_id = getPlayerEntity()
local owner_id = 0

local proj_comp = EntityGetFirstComponent(entity_id, "ProjectileComponent")
if (proj_comp ~= nil) then
    owner_id = ComponentGetValue2(proj_comp, "mWhoShot")
end

local damage_comp = EntityGetFirstComponent(entity_id, "DamageModelComponent")
if (damage_comp ~= nil) then
    ComponentSetValue2(damage_comp, "kill_now", true)
end

--If shot by enemy, spill gold back on the ground
if owner_id ~= player_id then
    local mat_inv_comp = EntityGetFirstComponent(entity_id, "MaterialInventoryComponent")
    if (mat_inv_comp ~= nil) then
        ComponentSetValue2(mat_inv_comp, "on_death_spill", "1")
    end
else
    --Else add it to the player's wallet

    --Get Greed Multiplier Component from Modifiers adjusting the Variable Storage Component
    local greed_multiplier = 1
    local var_stor_comps = EntityGetComponent(entity_id, "VariableStorageComponent")
    if (var_stor_comps ~= nil) then
        for i, v in ipairs(var_stor_comps) do
            local n = ComponentGetValue2(v, "name")
            if (n == "greed_multiplier_golden_field") then
                greed_multiplier = ComponentGetValue2(v, "value_int")
            end
        end
    end

    --Get the Amount of Gold
    local mat_inv_comp = EntityGetFirstComponent(entity_id, "MaterialInventoryComponent")
    local count_per_material_type = {}
    local gold_amount = 0
    if (mat_inv_comp ~= nil) then
        count_per_material_type = ComponentGetValue2(mat_inv_comp, "count_per_material_type")

        for i, v in ipairs(count_per_material_type) do
            if CellFactory_GetName(i - 1) == "gold" then
                gold_amount = v
            end
        end

        --gold_amount = count_per_material_type[125]
        --Note Priskip 18/10/23: this broke when Nolla added more material types into the beta.
        --That's what happens when you hard code an array index for the cell factory ids. :/
    end

    --Add it to player's Wallet
    local wallet_comp = EntityGetFirstComponent(player_id, "WalletComponent")
    local money_in_wallet = 0
    if (wallet_comp ~= nil) then
        money_in_wallet = ComponentGetValue2(wallet_comp, "money")
        ComponentSetValue2(wallet_comp, "money", money_in_wallet + greed_multiplier * gold_amount)
    end
end
