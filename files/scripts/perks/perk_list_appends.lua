dofile("data/scripts/lib/utilities.lua")
dofile_once("mods/purgatory/files/scripts/perks/perk_order.lua")

--                                --
-- -- HELPER FUNCTIONS SECTION -- --
--                                --

function round_to_nearest_int(num)
	return math.floor(num + 0.5)
end

--                            --
-- -- MODIFY PERKS SECTION -- --
--                            --

--Function for modifying existing perks
function modify_existing_perk(perk_id, parameter_to_modify, new_value)
	for i, perk in ipairs(perk_list) do
		if perk.id == perk_id then
			perk[parameter_to_modify] = new_value
			break
		end
	end
end

--Modifying Existing Perks
modify_existing_perk("PROTECTION_EXPLOSION", "remove_other_perks", {"EXPLODING_CORPSES"})
modify_existing_perk("PROTECTION_FIRE", "remove_other_perks", {"BLEED_OIL"})
modify_existing_perk("PROTECTION_MELEE", "remove_other_perks", {"CONTACT_DAMAGE"})
modify_existing_perk("PROTECTION_RADIOACTIVITY", "remove_other_perks", {"BLEED_GAS"})
modify_existing_perk("PROTECTION_ELECTRICITY", "remove_other_perks", {"ELECTRICITY"})

modify_existing_perk("CONTACT_DAMAGE", "remove_other_perks", {"PROTECTION_MELEE"})

modify_existing_perk("FREEZE_FIELD", "game_effect2", "PROTECTION_FREEZE")

modify_existing_perk("NO_MORE_KNOCKBACK", "game_effect2", "NO_DAMAGE_FLASH")
modify_existing_perk("NO_MORE_KNOCKBACK", "ui_description", "$perkdesc_no_more_knockback_new")

modify_existing_perk("VAMPIRISM", "ui_description", "$perkdesc_vampirism_new")
modify_existing_perk(
	"VAMPIRISM",
	"func",
	function(entity_perk_item, entity_who_picked, item_name)
		local x, y = EntityGetTransform(entity_who_picked)
		CreateItemActionEntity("VACUUM_BLOOD", x, y)

		add_halo_level(entity_who_picked, -1)
	end
)

modify_existing_perk("GLASS_CANNON", "ui_description", "$perkdesc_glass_cannon_new")
modify_existing_perk("GLASS_CANNON", "remove_other_perks", {"EXTRA_HP", "HEARTS_MORE_EXTRA_HP", "HEART_STEALER"})
modify_existing_perk(
	"GLASS_CANNON",
	"func",
	function(entity_perk_item, entity_who_picked, item_name)
		local damagemodels = EntityGetComponent(entity_who_picked, "DamageModelComponent")
		if (damagemodels ~= nil) then
			for i, damagemodel in ipairs(damagemodels) do
				local hp = tonumber(ComponentGetValue(damagemodel, "hp"))
				local max_hp = 100 / 25

				--ComponentSetValue( damagemodel, "hp", math.min( hp, max_hp ) )
				ComponentSetValue(damagemodel, "max_hp", max_hp)
				ComponentSetValue(damagemodel, "max_hp_cap", max_hp)
				ComponentSetValue(damagemodel, "hp", max_hp)
			end
		end
	end
)
modify_existing_perk(
	"GLASS_CANNON",
	"func_enemy",
	function(entity_perk_item, entity_who_picked)
		local damagemodels = EntityGetComponent(entity_who_picked, "DamageModelComponent")
		if (damagemodels ~= nil) then
			for i, damagemodel in ipairs(damagemodels) do
				local hp = tonumber(ComponentGetValue(damagemodel, "hp"))
				local max_hp = 100 / 25

				--ComponentSetValue( damagemodel, "hp", math.min( hp, max_hp ) )
				ComponentSetValue(damagemodel, "max_hp", max_hp)
				ComponentSetValue(damagemodel, "max_hp_cap", max_hp)
				ComponentSetValue(damagemodel, "hp", max_hp)
			end
		end

		EntityAddComponent(
			entity_who_picked,
			"LuaComponent",
			{
				script_shot = "data/scripts/perks/glass_cannon_enemy.lua",
				execute_every_n_frame = "-1"
			}
		)
	end
)
modify_existing_perk(
	"GLASS_CANNON",
	"func_remove",
	function(entity_who_picked)
		local damagemodels = EntityGetComponent(entity_who_picked, "DamageModelComponent")
		if (damagemodels ~= nil) then
			for i, damagemodel in ipairs(damagemodels) do
				local max_hp = tonumber(ComponentGetValue(damagemodel, "max_hp")) * 25
				ComponentSetValue(damagemodel, "max_hp_cap", 0.0)

				if (max_hp < 100) then
					ComponentSetValue(damagemodel, "max_hp", 4)
					ComponentSetValue(damagemodel, "hp", 4)
				end
			end
		end
	end
)

modify_existing_perk("MAP", "ui_name", "$perk_map_lvl_1")
modify_existing_perk("MAP", "ui_description", "$perkdesc_map_lvl_1")
modify_existing_perk("MAP", "ui_icon", "mods/purgatory/files/ui_gfx/perk_icons/map_lvl_1.png")
modify_existing_perk("MAP", "perk_icon", "mods/purgatory/files/items_gfx/perks/map_lvl_1.png")
modify_existing_perk(
	"MAP",
	"func",
	function(entity_perk_item, entity_who_picked, item_name)
		local x, y = EntityGetTransform(entity_who_picked)
		local child_id = EntityLoad("mods/purgatory/files/entities/misc/perks/map_lvl_1.xml", x, y)
		EntityAddTag(child_id, "perk_entity")
		EntityAddChild(entity_who_picked, child_id)
	end
)

modify_existing_perk("CONTACT_DAMAGE", "ui_description", "$perkdesc_contact_damage_new")
modify_existing_perk("CONTACT_DAMAGE", "game_effect", "PROTECTION_MELEE")
modify_existing_perk("CONTACT_DAMAGE", "remove_other_perks", {"PROTECTION_MELEE"})

modify_existing_perk("EXTRA_PERK", "stackable_maximum", 11)

modify_existing_perk("EXTRA_SLOTS", "ui_description", "$perkdesc_extra_slots_new")
modify_existing_perk(
	"EXTRA_SLOTS",
	"func",
	function(entity_perk_item, entity_who_picked, item_name)
		local x, y = EntityGetTransform(entity_who_picked)
		local wands = EntityGetInRadiusWithTag(x, y, 24, "wand")

		SetRandomSeed(x, y)

		for i, entity_id in ipairs(wands) do
			local root_entity = EntityGetRootEntity(entity_id)

			if (root_entity == entity_who_picked) then
				local models = EntityGetComponentIncludingDisabled(entity_id, "AbilityComponent")
				if (models ~= nil) then
					for j, model in ipairs(models) do
						local deck_capacity = tonumber(ComponentObjectGetValue(model, "gun_config", "deck_capacity"))
						local deck_capacity2 = EntityGetWandCapacity(entity_id)

						local always_casts = deck_capacity - deck_capacity2

						deck_capacity = math.min(deck_capacity + 3, math.max(25 + always_casts, deck_capacity))

						ComponentObjectSetValue(model, "gun_config", "deck_capacity", tostring(deck_capacity))
					end
				end
			end
		end
	end
)

modify_existing_perk(
	"FASTER_WANDS",
	"func",
	function(entity_perk_item, entity_who_picked, item_name)
		local x, y = EntityGetTransform(entity_who_picked)
		local wands = EntityGetInRadiusWithTag(x, y, 24, "wand")

		for i, entity_id in ipairs(wands) do
			local root_entity = EntityGetRootEntity(entity_id)

			if (root_entity == entity_who_picked) then
				local models = EntityGetComponentIncludingDisabled(entity_id, "AbilityComponent")
				local item_comp = EntityGetFirstComponentIncludingDisabled(entity_id, "ItemComponent")
				local wand_name = ComponentGetValue2(item_comp, "item_name")

				if (models ~= nil) then
					for j, model in ipairs(models) do
						local reload_time = tonumber(ComponentObjectGetValue(model, "gun_config", "reload_time"))
						local cast_delay = tonumber(ComponentObjectGetValue(model, "gunaction_config", "fire_rate_wait"))
						local mana_charge_speed = ComponentGetValue2(model, "mana_charge_speed")

						local old_cast_delay = cast_delay
						local old_reload_time = reload_time
						SetRandomSeed(x + j, y - j)

						if wand_name == "$item_wand_good_1" then
							--If wand is Wand of Swiftness
							cast_delay = round_to_nearest_int(cast_delay * 0.5 - 45)
							reload_time = round_to_nearest_int(reload_time * 0.5 - 45)

							--Calculate new mana charge speed
							mana_charge_speed = mana_charge_speed + 2.5 * ((old_cast_delay - cast_delay) + (old_reload_time - reload_time))
						else
							--If wand is not Wand of Swiftness
							--Calculate new cast delay and recharge time
							if cast_delay > 60 then
								cast_delay = 60 + Random(-5, 5) --Makes huge cast delay time wands dramatically lower
							end

							if reload_time > 60 then
								reload_time = 60 + Random(-5, 5) --Makes huge recharge time wands dramatically lower
							end

							cast_delay = round_to_nearest_int(cast_delay * 0.7 - 6.4)
							reload_time = round_to_nearest_int(reload_time * 0.7 - 6.4)

							--Calculate new mana charge speed
							mana_charge_speed = mana_charge_speed + 1.5 * ((old_cast_delay - cast_delay) + (old_reload_time - reload_time))
						end
						--Set Values
						ComponentSetValue2(model, "mana_charge_speed", mana_charge_speed)
						ComponentObjectSetValue(model, "gun_config", "reload_time", tostring(reload_time))
						ComponentObjectSetValue(model, "gunaction_config", "fire_rate_wait", tostring(cast_delay))
					end
				end
			end
		end
	end
)

modify_existing_perk(
	"EXTRA_MANA",
	"func",
	function(entity_perk_item, entity_who_picked, item_name)
		local wand = find_the_wand_held(entity_who_picked)
		local x, y = EntityGetTransform(entity_who_picked)

		SetRandomSeed(entity_who_picked, wand)

		if (wand ~= NULL_ENTITY) then
			local comp = EntityGetFirstComponentIncludingDisabled(wand, "AbilityComponent")

			if (comp ~= nil) then
				local mana_max = ComponentGetValue2(comp, "mana_max")
				local mana_charge_speed = ComponentGetValue2(comp, "mana_charge_speed")
				local deck_capacity = ComponentObjectGetValue(comp, "gun_config", "deck_capacity")
				local deck_capacity2 = EntityGetWandCapacity(wand)
				local always_casts = math.max(0, deck_capacity - deck_capacity2)
				local spells_per_cast = tonumber(ComponentObjectGetValue(comp, "gun_config", "actions_per_round"))

				local old_deck_capacity = deck_capacity2
				deck_capacity2 = math.max(1, math.floor(deck_capacity2 * 0.5))

				local delta_deck_cap = old_deck_capacity - deck_capacity2

				--NOTE PRISKIP: https://www.desmos.com/calculator/wfjvqa6mcy For visualising this new mana function
				local mana_to_add = round_to_nearest_int(900 * ((math.exp(0.8 * delta_deck_cap)) / (math.exp(0.8 * delta_deck_cap) + 100)) + 100)

				mana_max = mana_max + mana_to_add + Random(-50, 50)
				mana_charge_speed = mana_charge_speed + mana_to_add + Random(-50, 50)

				ComponentSetValue2(comp, "mana_max", mana_max)
				ComponentSetValue2(comp, "mana_charge_speed", mana_charge_speed)
				ComponentObjectSetValue(comp, "gun_config", "deck_capacity", deck_capacity2 + always_casts)

				--Do not allow spells/cast to excede capacity
				if spells_per_cast > deck_capacity2 then
					ComponentObjectSetValue(comp, "gun_config", "actions_per_round", math.floor(deck_capacity2))
				end

				--This pops all the spells on the wand if the new capacity is smaller than the amount of spells on the wand
				local c = EntityGetAllChildren(wand)

				if (c ~= nil) and (#c > deck_capacity2 + always_casts) then
					for i = always_casts + 1, #c do
						local v = c[i]
						local comp2 = EntityGetFirstComponentIncludingDisabled(v, "ItemActionComponent")

						if (comp2 ~= nil) and (i > deck_capacity2 + always_casts) then
							EntityRemoveFromParent(v)
							EntitySetTransform(v, x, y)

							local all = EntityGetAllComponents(v)

							for a, b in ipairs(all) do
								EntitySetComponentIsEnabled(v, b, true)
							end
						end
					end
				end
			end
		end
	end
)

modify_existing_perk(
	"EXTRA_HP",
	"func_enemy",
	function(entity_perk_item, entity_who_picked, item_name)
		local damagemodels = EntityGetComponent(entity_who_picked, "DamageModelComponent")
		if (damagemodels ~= nil) then
			for i, damagemodel in ipairs(damagemodels) do
				local old_max_hp = tonumber(ComponentGetValue(damagemodel, "max_hp"))
				local max_hp = old_max_hp * 5

				local max_hp_cap = tonumber(ComponentGetValue(damagemodel, "max_hp_cap"))
				if max_hp_cap > 0 then
					max_hp = math.min(max_hp, max_hp_cap)
				end

				local current_hp = tonumber(ComponentGetValue(damagemodel, "hp"))
				current_hp = math.min(current_hp + math.abs(max_hp - old_max_hp), max_hp)

				ComponentSetValue(damagemodel, "max_hp", max_hp)
				ComponentSetValue(damagemodel, "hp", current_hp)
			end
		end
	end
)

--                            --
-- -- REMOVE PERKS SECTION -- --
--                            --

-- Remove Perks from perk_list
function remove_perk(perk_name)
	local key_to_perk = nil
	for key, perk in pairs(perk_list) do
		if (perk.id == perk_name) then
			key_to_perk = key
		end
	end

	if (key_to_perk ~= nil) then
		table.remove(perk_list, key_to_perk)
	end
end

remove_perk("INVISIBILITY")
remove_perk("PERSONAL_LASER") --Changed to a passive spell
remove_perk("MOVEMENT_FASTER") --Combined into HASTE
remove_perk("FASTER_LEVITATION") --Combined into HASTE

--                         --
-- -- ADD PERKS SECTION -- --
--                         --

--Add Perks to the perk pool
perks_to_add = {
	{
		id = "HASTE",
		ui_name = "$perk_faster_speed",
		ui_description = "$perkdesc_faster_speed",
		ui_icon = "mods/purgatory/files/ui_gfx/perk_icons/faster_speed.png",
		perk_icon = "mods/purgatory/files/items_gfx/perks/faster_speed.png",
		stackable = STACKABLE_YES,
		not_in_default_perk_pool = true,
		func = function(entity_perk_item, entity_who_picked, item_name)
			LoadGameEffectEntityTo(entity_who_picked, "mods/purgatory/files/entities/misc/effect_faster_speed.xml")
		end,
		func_remove = function(entity_who_picked)
			--Remove effect
			local children = EntityGetAllChildren(entity_who_picked)
			for i, child in ipairs(children) do
				if EntityGetName(child) == "purgatory_faster_speed" then
					EntityKill(child)
				end
			end
		end
	},
	{
		id = "LOW_GRAVITY",
		ui_name = "$perk_low_gravity",
		ui_description = "$perkdesc_low_gravity",
		ui_icon = "data/ui_gfx/perk_icons/low_gravity.png",
		perk_icon = "data/items_gfx/perks/low_gravity.png",
		stackable = STACKABLE_YES,
		stackable_is_rare = true,
		usable_by_enemies = true,
		not_in_default_perk_pool = false,
		func = function(entity_perk_item, entity_who_picked, item_name)
			local models = EntityGetComponent(entity_who_picked, "CharacterPlatformingComponent")
			if (models ~= nil) then
				for i, model in ipairs(models) do
					local gravity = tonumber(ComponentGetValue(model, "pixel_gravity")) * 0.6
					ComponentSetValue(model, "pixel_gravity", gravity)
				end
			end

			if (EntityHasTag(entity_who_picked, "low_gravity") == false) then
				EntityAddTag(entity_who_picked, "low_gravity")

				EntityAddComponent(
					entity_who_picked,
					"LuaComponent",
					{
						script_source_file = "data/scripts/perks/low_gravity.lua",
						execute_every_n_frame = "80"
					}
				)
			end
		end,
		func_enemy = function(entity_perk_item, entity_who_picked)
			local models = EntityGetComponent(entity_who_picked, "CharacterPlatformingComponent")
			if (models ~= nil) then
				for i, model in ipairs(models) do
					local gravity = ComponentGetValue2(model, "pixel_gravity") * 0.6
					ComponentSetValue2(model, "pixel_gravity", gravity)
				end
			end
		end
	},
	{
		id = "HIGH_GRAVITY",
		ui_name = "$perk_high_gravity",
		ui_description = "$perkdesc_high_gravity",
		ui_icon = "data/ui_gfx/perk_icons/high_gravity.png",
		perk_icon = "data/items_gfx/perks/high_gravity.png",
		stackable = STACKABLE_YES,
		stackable_is_rare = true,
		usable_by_enemies = true,
		not_in_default_perk_pool = false,
		func = function(entity_perk_item, entity_who_picked, item_name)
			local models = EntityGetComponent(entity_who_picked, "CharacterPlatformingComponent")
			if (models ~= nil) then
				for i, model in ipairs(models) do
					local gravity = tonumber(ComponentGetValue(model, "pixel_gravity")) * 1.4
					ComponentSetValue(model, "pixel_gravity", gravity)
				end
			end

			if (EntityHasTag(entity_who_picked, "high_gravity") == false) then
				EntityAddTag(entity_who_picked, "high_gravity")

				EntityAddComponent(
					entity_who_picked,
					"LuaComponent",
					{
						script_source_file = "data/scripts/perks/high_gravity.lua",
						execute_every_n_frame = "80"
					}
				)
			end
		end,
		func_enemy = function(entity_perk_item, entity_who_picked)
			local models = EntityGetComponent(entity_who_picked, "CharacterPlatformingComponent")
			if (models ~= nil) then
				for i, model in ipairs(models) do
					local gravity = ComponentGetValue2(model, "pixel_gravity") * 1.4
					ComponentSetValue2(model, "pixel_gravity", gravity)
				end
			end
		end
	},
	{
		id = "MAP_LEVEL_2",
		ui_name = "$perk_map_lvl_2",
		ui_description = "$perkdesc_map_lvl_2",
		ui_icon = "mods/purgatory/files/ui_gfx/perk_icons/map_lvl_2.png",
		perk_icon = "mods/purgatory/files/items_gfx/perks/map_lvl_2.png",
		not_in_default_perk_pool = true,
		stackable = STACKABLE_NO,
		func = function(entity_perk_item, entity_who_picked, item_name)
			local x, y = EntityGetTransform(entity_who_picked)
			local child_id = EntityLoad("mods/purgatory/files/entities/misc/perks/map_lvl_2.xml", x, y)
			EntityAddTag(child_id, "perk_entity")
			EntityAddChild(entity_who_picked, child_id)
		end
	},
	{
		id = "MAP_LEVEL_3",
		ui_name = "$perk_map_lvl_3",
		ui_description = "$perkdesc_map_lvl_3",
		ui_icon = "mods/purgatory/files/ui_gfx/perk_icons/map_lvl_3.png",
		perk_icon = "mods/purgatory/files/items_gfx/perks/map_lvl_3.png",
		not_in_default_perk_pool = true,
		stackable = STACKABLE_NO,
		func = function(entity_perk_item, entity_who_picked, item_name)
			local x, y = EntityGetTransform(entity_who_picked)
			local child_id = EntityLoad("mods/purgatory/files/entities/misc/perks/map_lvl_3.xml", x, y)
			EntityAddTag(child_id, "perk_entity")
			EntityAddChild(entity_who_picked, child_id)
		end
	},
	{
		id = "MAP_LEVEL_4",
		ui_name = "$perk_map_lvl_4",
		ui_description = "$perkdesc_map_lvl_4",
		ui_icon = "mods/purgatory/files/ui_gfx/perk_icons/map_lvl_4.png",
		perk_icon = "mods/purgatory/files/items_gfx/perks/map_lvl_4.png",
		not_in_default_perk_pool = true,
		stackable = STACKABLE_NO,
		func = function(entity_perk_item, entity_who_picked, item_name)
			local x, y = EntityGetTransform(entity_who_picked)
			local child_id = EntityLoad("mods/purgatory/files/entities/misc/perks/map_lvl_4.xml", x, y)
			EntityAddTag(child_id, "perk_entity")
			EntityAddChild(entity_who_picked, child_id)
		end
	},
	{
		id = "ROLL_AGAIN",
		ui_name = "$perk_roll_again",
		ui_description = "$perkdesc_roll_again",
		ui_icon = "mods/purgatory/files/ui_gfx/perk_icons/roll_again.png",
		perk_icon = "mods/purgatory/files/items_gfx/perks/roll_again.png",
		not_in_default_perk_pool = true,
		stackable = STACKABLE_YES,
		func = function(entity_perk_item, entity_who_picked, item_name)
			GlobalsSetValue("TEMPLE_PERK_REROLL_COUNT", tostring(0))
		end
	},
	{
		id = "PROTECTION_FREEZE",
		ui_name = "$perk_protection_freeze",
		ui_description = "$perkdesc_protection_freeze",
		ui_icon = "data/ui_gfx/perk_icons/protection_freeze.png",
		perk_icon = "data/items_gfx/perks/protection_freeze.png",
		game_effect = "PROTECTION_FREEZE",
		remove_other_perks = {"CRYO_BLOOD"},
		usable_by_enemies = true
	},
	{
		id = "HEART_STEALER",
		ui_name = "$perk_heart_stealer",
		ui_description = "$perkdesc_heart_stealer",
		ui_icon = "mods/purgatory/files/ui_gfx/perk_icons/heart_stealer.png",
		perk_icon = "mods/purgatory/files/items_gfx/perks/heart_stealer.png",
		stackable = STACKABLE_NO,
		func = function(entity_perk_item, entity_who_picked, item_name, pickup_count)
			if (pickup_count <= 1) then
				EntityAddComponent(
					entity_who_picked,
					"LuaComponent",
					{
						_tags = "perk_component",
						script_source_file = "mods/purgatory/files/scripts/perks/heart_stealer.lua",
						execute_every_n_frame = "20"
					}
				)
			end

			add_halo_level(entity_who_picked, -1)
		end
	},
	{
		id = "CRYO_BLOOD",
		ui_name = "$perk_cryo_blood",
		ui_description = "$perkdesc_cryo_blood",
		ui_icon = "mods/purgatory/files/ui_gfx/perk_icons/cryo_blood.png",
		perk_icon = "mods/purgatory/files/items_gfx/perks/cryo_blood.png",
		stackable = STACKABLE_NO,
		usable_by_enemies = true,
		game_effect = "PROTECTION_FREEZE",
		remove_other_perks = {"PROTECTION_FREEZE"},
		func = function(entity_perk_item, entity_who_picked, item_name)
			--bleed freezing vapour
			local damagemodels = EntityGetComponent(entity_who_picked, "DamageModelComponent")
			if (damagemodels ~= nil) then
				for i, damagemodel in ipairs(damagemodels) do
					ComponentSetValue(damagemodel, "blood_material", "blood_cold_vapour")
					ComponentSetValue(damagemodel, "blood_spray_material", "blood_cold_vapour")
					ComponentSetValue(damagemodel, "blood_multiplier", "5.0")
					ComponentSetValue(damagemodel, "blood_sprite_directional", "data/particles/bloodsplatters/bloodsplatter_directional_green_$[1-3].xml")
					ComponentSetValue(damagemodel, "blood_sprite_large", "data/particles/bloodsplatters/bloodsplatter_green_$[1-3].xml")
				end
			end

			--counteract gas blood gravity
			local models = EntityGetComponent(entity_who_picked, "CharacterPlatformingComponent")
			if (models ~= nil) then
				for i, model in ipairs(models) do
					local gravity = ComponentGetValue2(model, "pixel_gravity") / 0.75
					ComponentSetValue2(model, "pixel_gravity", gravity)
				end
			end

			--update material damage models
			EntitySetDamageFromMaterial(entity_who_picked, "blood_cold_vapour", 0)
			EntitySetDamageFromMaterial(entity_who_picked, "blood_cold", 0)
		end,
		func_remove = function(entity_who_picked)
			local damagemodels = EntityGetComponent(entity_who_picked, "DamageModelComponent")
			if (damagemodels ~= nil) then
				for i, damagemodel in ipairs(damagemodels) do
					ComponentSetValue(damagemodel, "blood_material", "blood")
					ComponentSetValue(damagemodel, "blood_spray_material", "blood")
					ComponentSetValue(damagemodel, "blood_multiplier", "1.0")
					ComponentSetValue(damagemodel, "blood_sprite_directional", "")
					ComponentSetValue(damagemodel, "blood_sprite_large", "")
				end
			end

			local models = EntityGetComponent(entity_who_picked, "CharacterPlatformingComponent")
			if (models ~= nil) then
				for i, model in ipairs(models) do
					ComponentSetValue2(model, "pixel_gravity", 350)
				end
			end

			--update material damage models
			EntitySetDamageFromMaterial(entity_who_picked, "blood_cold_vapour", 0.0006)
			EntitySetDamageFromMaterial(entity_who_picked, "blood_cold", 0.0009)
		end
	},
	{
		id = "EXTRA_POTION_AND_SACK_CAPACITY",
		ui_name = "$perk_extra_potion_and_sack_capacity",
		ui_description = "$perkdesc_extra_potion_and_sack_capacity",
		ui_icon = "mods/purgatory/files/ui_gfx/perk_icons/extra_potion_and_sack_capacity.png",
		perk_icon = "mods/purgatory/files/items_gfx/perks/extra_potion_and_sack_capacity.png",
		stackable = STACKABLE_YES,
		func = function(entity_perk_item, entity_who_picked, item_name)
			--Update Global
			--barrel size = 1000 * (1 + #stacks)
			local multiplier = tonumber(GlobalsGetValue("EXTRA_POTION_AND_SACK_CAPACITY_MULTIPLIER", "1"))
			multiplier = multiplier + 1
			GlobalsSetValue("EXTRA_POTION_AND_SACK_CAPACITY_MULTIPLIER", tostring(multiplier))

			--Affect player's potions
			local inventory = {}
			local items = {}

			for i, child in ipairs(EntityGetAllChildren(entity_who_picked)) do
				if EntityGetName(child) == "inventory_quick" then
					inventory = child
					break
				end
			end

			for i, item in ipairs(EntityGetAllChildren(inventory)) do
				local ability_component = EntityGetFirstComponentIncludingDisabled(item, "AbilityComponent")
				local ending_mc_guffin_component = EntityGetFirstComponentIncludingDisabled(item, "EndingMcGuffinComponent")

				if (not ability_component) or ending_mc_guffin_component or ComponentGetValue2(ability_component, "use_gun_script") == false then
					table.insert(items, item)
				end
			end

			for i, item in ipairs(items) do
				local is_potion = EntityHasTag(item, "potion")
				local is_sack = EntityHasTag(item, "powder_stash")

				if is_potion then
					local comp = EntityGetFirstComponentIncludingDisabled(item, "MaterialSuckerComponent")
					ComponentSetValue(comp, "barrel_size", multiplier * 1000)

					--Make description reflect barrel size change.
					EntityAddComponent2(
						item,
						"LuaComponent",
						{
							_tags = "enabled_in_hand,enabled_in_world,enabled_in_inventory",
							execute_on_added = false,
							execute_every_n_frame = 5,
							remove_after_executed = true,
							script_source_file = "mods/purgatory/files/scripts/items/barrel_size_displayer.lua"
						}
					)
				end

				if is_sack then
					local comp = EntityGetFirstComponentIncludingDisabled(item, "MaterialSuckerComponent")
					ComponentSetValue(comp, "barrel_size", multiplier * 1500)

					--Make description reflect barrel size change.
					EntityAddComponent2(
						item,
						"LuaComponent",
						{
							_tags = "enabled_in_hand,enabled_in_world,enabled_in_inventory",
							execute_on_added = false,
							execute_every_n_frame = 5,
							remove_after_executed = true,
							script_source_file = "mods/purgatory/files/scripts/items/barrel_size_displayer.lua"
						}
					)
				end
			end
		end,
		func_remove = function(entity_who_picked)
			--Update Global
			local multiplier = 1
			GlobalsSetValue("EXTRA_POTION_AND_SACK_CAPACITY_MULTIPLIER", tostring(multiplier))

			--Affect player's potions
			local inventory = {}
			local items = {}

			for i, child in ipairs(EntityGetAllChildren(entity_who_picked)) do
				if EntityGetName(child) == "inventory_quick" then
					inventory = child
					break
				end
			end

			for i, item in ipairs(EntityGetAllChildren(inventory)) do
				local ability_component = EntityGetFirstComponentIncludingDisabled(item, "AbilityComponent")
				local ending_mc_guffin_component = EntityGetFirstComponentIncludingDisabled(item, "EndingMcGuffinComponent")

				if (not ability_component) or ending_mc_guffin_component or ComponentGetValue2(ability_component, "use_gun_script") == false then
					table.insert(items, item)
				end
			end

			for i, item in ipairs(items) do
				local is_potion = EntityHasTag(item, "potion")
				local is_sack = EntityHasTag(item, "powder_stash")

				if is_potion then
					local comp = EntityGetFirstComponentIncludingDisabled(item, "MaterialSuckerComponent")
					ComponentSetValue(comp, "barrel_size", multiplier * 1000)

					--Make description reflect barrel size change.
					EntityAddComponent2(
						item,
						"LuaComponent",
						{
							_tags = "enabled_in_hand,enabled_in_world,enabled_in_inventory",
							execute_on_added = false,
							execute_every_n_frame = 5,
							remove_after_executed = true,
							script_source_file = "mods/purgatory/files/scripts/items/barrel_size_displayer.lua"
						}
					)
				end

				if is_sack then
					local comp = EntityGetFirstComponentIncludingDisabled(item, "MaterialSuckerComponent")
					ComponentSetValue(comp, "barrel_size", multiplier * 1500)

					--Make description reflect barrel size change.
					EntityAddComponent2(
						item,
						"LuaComponent",
						{
							_tags = "enabled_in_hand,enabled_in_world,enabled_in_inventory",
							execute_on_added = false,
							execute_every_n_frame = 5,
							remove_after_executed = true,
							script_source_file = "mods/purgatory/files/scripts/items/barrel_size_displayer.lua"
						}
					)
				end
			end
		end
	}
	--[[
	{
		id = "STRONGER_BOTTLES",
		ui_name = "$perk_stronger_bottles",
		ui_description = "$perkdesc_stronger_bottles",
		ui_icon = "mods/purgatory/files/ui_gfx/perk_icons/stronger_bottles.png",
		perk_icon = "mods/purgatory/files/items_gfx/perks/stronger_bottles.png",
		stackable = STACKABLE_NO,
		func = function(entity_perk_item, entity_who_picked, item_name)
		end,
		func_remove = function(entity_who_picked)
		end
	}
	]]
}

--Add the Perks
for i, perk in ipairs(perks_to_add) do
	table.insert(perk_list, #perk_list + 1, perk)
end

--                           --
-- -- ORDER PERKS SECTION -- --
--                           --

--Orders the perks according to mods/purgatory/files/scripts/perks/perk_order.lua
local new_perk_list = {}

for i, perk in ipairs(perk_order) do
	for j, v in ipairs(perk_list) do
		if v.id == perk then
			new_perk_list[i] = v
			table.remove(perk_list, j)
			--print(perk)
			break
		end
	end
end

--if other mods added perks
if #perk_list > 0 then
	for i, v in ipairs(perk_list) do
		table.insert(new_perk_list, #new_perk_list + 1, v)
	end
end

--set list
perk_list = new_perk_list
