--Appends for Sampo Endings

--Purgatory Ascendence Levels
--Get run ascension level
local ascend_level = 0;
for i = 0, 99, 1 do
	local flag = "run_ascension_level_"..tostring(i)
	local has_flag = GameHasFlagRun(flag)
	if has_flag then
		ascend_level = i
		break
	end
end

--Get max ascension level
local max_ascend = 0;
for i = 1, 100, 1 do
	local flag = "purgatory_max_ascension_"..tostring(i)
	local has_flag = HasFlagPersistent(flag)
	if has_flag then
		max_ascend = i
		break
	end
end

--Assign New Max Asecension if Run Ascension = Max Ascension
if ascend_level == max_ascend then
	RemoveFlagPersistent("purgatory_max_ascension_"..tostring(max_ascend))
	AddFlagPersistent("purgatory_max_ascension_"..tostring(max_ascend + 1))
end

--Add Purgatory Win Flag
if GameHasFlagRun("run_purgatory") then
	AddFlagPersistent("purgatory_win")
end

--Add Purgatory Win Flag
if GameHasFlagRun("purgatory_no_edit_run") then
	AddFlagPersistent("purgatory_win_no_edit_start")
end