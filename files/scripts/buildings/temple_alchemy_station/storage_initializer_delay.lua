dofile_once("data/scripts/lib/utilities.lua")
dofile_once("mods/purgatory/files/scripts/lib/utilities.lua")

function init(entity_id)
    --This gives time for entities to load in and all that
    EntityAddComponent2(
			entity_id,
			"LuaComponent",
			{
				execute_on_added = false,
				script_source_file = "mods/purgatory/files/scripts/buildings/temple_alchemy_station/storage_initializer.lua",
				execute_every_n_frame = 5,
				remove_after_executed = true
			}
		)
end
