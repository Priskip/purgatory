dofile("data/scripts/lib/mod_settings.lua")
dofile_once("mods/purgatory/secrets.lua")

function mod_setting_bool_custom(mod_id, gui, in_main_menu, im_id, setting)
	local value = ModSettingGetNextValue(mod_setting_get_id(mod_id, setting))
	local text = setting.ui_name .. " - " .. GameTextGet(value and "$option_on" or "$option_off")

	if GuiButton(gui, im_id, mod_setting_group_x_offset, 0, text) then
		ModSettingSetNextValue(mod_setting_get_id(mod_id, setting), not value, false)
	end

	mod_setting_tooltip(mod_id, gui, in_main_menu, setting)
end

function mod_setting_change_callback(mod_id, gui, in_main_menu, setting, old_value, new_value)
	print(tostring(new_value))
end

--Get max ascension level
local max_ascend = 0
for i = 1, 100, 1 do
	local flag = "purgatory_max_ascension_" .. tostring(i)
	local has_flag = HasFlagPersistent(flag)
	if has_flag then
		max_ascend = i
		break
	end
end

local mod_id = "purgatory"
mod_settings_version = 1
mod_settings = {
	{
		category_id = "mod_settings",
		ui_name = "Purgatory Settings",
		ui_description = "Settings for Purgatory Mod",
		settings = {
			{
				id = "ascension_level",
				ui_name = "Ascendence Level",
				ui_description = "As if Purgatory wasn't hard enough already.",
				value_default = 0,
				value_min = 0,
				value_max = max_ascend,
				value_display_multiplier = 1,
				value_display_formatting = " + $0 Ascension",
				scope = MOD_SETTING_SCOPE_NEW_GAME
			},
			{
				id = "input_device",
				ui_name = "Input Device",
				ui_description = "Changes what type of mod gui functions will be drawn.\n\nIf set to \"Auto Detect\", the game will look at your inputs and figure out what you're using.\n\nIf set to \"Mouse & Keyboard\" or \"Controller\", Purgatory will lock its \ndraw calls for custom gui objects to only the input device selected.",
				value_default = "auto_detect",
				values = { {"auto","Auto Detect"}, {"m_kb","Mouse & Keyboard"}, {"ctrl", "Controller"} },
				scope = MOD_SETTING_SCOPE_RUNTIME,
				change_fn = mod_setting_change_callback, -- Called when the user interact with the settings widget.
			},
			{
				category_id = "reset_progress_sub_folder",
				ui_name = "Reset Purgatory Persistant Flags",
				ui_description = "Contains settings that will allow you to remove Purgatory persistant flags. To use, enable the reset setting, start a new run, then disable the setting and start 2nd new run.",
				foldable = true,
				_folded = true, -- this field will be automatically added to each gategory table to store the current folding state
				settings = {
					{
						id = "reset_tree_achievements",
						ui_name = "Reset Purgatory Tree Achievements",
						ui_description = "If enabled, starting a new game will reset the custom Purgatory tree achievements.",
						value_default = false,
						scope = MOD_SETTING_SCOPE_RUNTIME
					}
				}
			},
			{
				category_id = "set_seed_sub_folder",
				ui_name = "Seed Changer",
				ui_description = "A built in seed changer for Purgatory. May or may not contain secrets.",
				foldable = true,
				_folded = true,
				settings = {
					{
						id = "seed_changer",
						ui_name = "Seed Changer",
						ui_description = "Input Seed - Leave as 0 or blank for random seed",
						value_default = "0",
						text_max_length = 20,
						allowed_characters = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz_0123456789",
						scope = MOD_SETTING_SCOPE_NEW_GAME
					},
					{
						id = "seed_setter",
						ui_name = "Seed Setter",
						ui_description = "This actually sets the seed.",
						value_default = 0,
						value_min = 0,
						value_max = 2147483647,
						scope = MOD_SETTING_SCOPE_NEW_GAME,
						hidden = true
					},
					{
						id = "seed_info_display",
						ui_name = "seed_info_display",
						ui_description = "if you see this ui description, priskip made a boo boo",
						not_setting = true,
						ui_fn = function(mod_id, gui, in_main_menu, im_id, setting)
							local input_seed = ModSettingGetNextValue("purgatory.seed_changer")
							local biggest_seed_possible = 2147483647
							local seed_to_set = 0
							local too_big = false
							local is_secret_seed = false

							--Check for secret seed
							for i, v in ipairs(secret_seeds) do
								if input_seed == v then
									GuiColorSetForNextWidget(gui, 1, 1, 0, 1)
									GuiText(gui, mod_setting_group_x_offset, 0, "Secret Seed!")
									input_seed = 0
									seed_to_set = 0
									is_secret_seed = true
									break
								end
							end

							if not is_secret_seed then
								--Check to see if inputted seed contains only numeric characters
								local is_number = tonumber(input_seed)
								if is_number == nil then
									is_number = false
								else
									is_number = true
								end

								--If inputted seed is not a number, then convert it to a number.
								if is_number == false then
									local conversion_number = 0

									for char in input_seed:gmatch "." do
										conversion_number = conversion_number + string.byte(char)
										conversion_number = conversion_number * string.byte(char) ^ 2
										conversion_number = conversion_number % biggest_seed_possible
									end

									seed_to_set = conversion_number
								else
									--Inputted seed is a number, check to see if it's too big before passing it to purgatory.seed_setter
									seed_to_set = tonumber(input_seed)

									if math.floor(seed_to_set / biggest_seed_possible) > 0 then
										--Seed is too big
										too_big = true
										seed_to_set = seed_to_set % biggest_seed_possible
									end
								end

								if seed_to_set == 0 then
									GuiText(gui, mod_setting_group_x_offset, 0, "Seed will be random!")
								else
									GuiText(gui, mod_setting_group_x_offset, 0, 'Seed will be "' .. tostring(seed_to_set) .. '"')
								end

								if too_big then
									GuiColorSetForNextWidget(gui, 1, 1, 0, 1)
									GuiText(gui, mod_setting_group_x_offset, 0, "Warning! Inputted seed number was too big!/n    Seed has been changed to the value shown above.")
								end
							end

							ModSettingSetNextValue("purgatory.seed_setter", seed_to_set, false)
						end
					}
				}
			},
			{
				id = "debug_mode",
				ui_name = "Debug Mode",
				ui_description = "Mostly here for Priskip to mess with things",
				value_default = false,
				scope = MOD_SETTING_SCOPE_RUNTIME
			}
		}
	}
}

function ModSettingsUpdate(init_scope)
	local old_version = mod_settings_get_version(mod_id) -- This can be used to migrate some settings between mod versions.
	mod_settings_update(mod_id, mod_settings, init_scope)
end

function ModSettingsGuiCount()
	return mod_settings_gui_count(mod_id, mod_settings)
end

-- This function is called to display the settings UI for this mod. Your mod's settings wont be visible in the mod settings menu if this function isn't defined correctly.
function ModSettingsGui(gui, in_main_menu)
	mod_settings_gui(mod_id, mod_settings, gui, in_main_menu)

	local gui_id = 1
	local function new_gui_id()
		gui_id = gui_id + 1
		return gui_id
	end

	--[[
	if GuiImageButton(gui, new_gui_id(), 0, 0, "Toggle Start with Edit", "mods/purgatory/files/ui_gfx/perk_icons/roll_again.png") then
		ModSettingSetNextValue("purgatory.start_with_edit", not ModSettingGetNextValue("purgatory.start_with_edit"), false)
	end
	]]
end

--[[

]]
