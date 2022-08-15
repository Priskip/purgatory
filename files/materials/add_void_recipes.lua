dofile_once("data/scripts/lib/utilities.lua")

function add_ceaseless_void_recipes(toggle)
    if toggle == true then
        --Add Ceaseless Void Material
        ModMaterialsFileAdd("mods/purgatory/files/materials/ceaseless_void.xml")

        --Create a recipe for every material to be consumed
        local recipes = [[<Materials> ]]

        local nxml = dofile_once("mods/purgatory/libraries/nxml.lua")
        local content = ModTextFileGetContent("data/materials.xml")
        local xml = nxml.parse(content)
        for element in xml:each_child() do
            if element.attr.name ~= nil then
                recipes =
                    recipes ..
                    [[<Reaction probability="100" input_cell1="ceaseless_void_static" input_cell2="]] ..
                        element.attr.name .. [[" output_cell1="ceaseless_void_static" output_cell2="ceaseless_void_static" fast_reaction="1"> </Reaction> ]]
            end
        end

        recipes = recipes .. [[</Materials>]] --close tag

        --Set content of file with recipes
        ModTextFileSetContent("mods/purgatory/files/materials/ceaseless_void_recipes.xml", recipes)

        --Add file to material list
        ModMaterialsFileAdd("mods/purgatory/files/materials/ceaseless_void_recipes.xml")
    end
end
