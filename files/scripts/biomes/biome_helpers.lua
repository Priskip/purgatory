dofile_once("data/scripts/lib/utilities.lua")

function AddBiomes(xml_file_location)
    local nxml = dofile_once("mods/purgatory/libraries/nxml.lua")

    local biomes_list = ModTextFileGetContent("data/biome/_biomes_all.xml")
    local biomes_list_xml = nxml.parse(biomes_list)

    local biomes_to_add = ModTextFileGetContent(xml_file_location)
    local biome_to_add_xml = nxml.parse(biomes_to_add)
    
    for child in biome_to_add_xml:each_child() do
        print(child.attr.biome_filename)
        biomes_list_xml:add_child(child)
    end

    ModTextFileSetContent("data/biome/_biomes_all.xml", tostring(biomes_list_xml))
end


-- mods/purgatory/files/biome/biomes_to_add.xml
-- data/biome/_biomes_all.xml