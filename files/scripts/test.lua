dofile_once("data/scripts/lib/utilities.lua")
dofile_once("mods/purgatory/files/scripts/utils.lua")

local ent_id = GetUpdatedEntityID()


local members = {
    "image_file",
    "ui_is_parent",
    "is_text_sprite",
    "offset_x",
    "offset_y",
    "alpha",
    "visible",
    "emissive",
    "additive",
    "fog_of_war_hole",
    "smooth_filtering",
    "rect_animation",
    "next_rect_animation",
    "text",
    "z_index",
    "update_transform",
    "update_transform_rotation",
    "kill_entity_after_finished",
    "has_special_scale",
    "special_scale_x",
    "special_scale_y",
    "never_ragdollify_on_death"
}

for i, v in ipairs(members) do
    
end
