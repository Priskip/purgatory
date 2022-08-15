dofile_once("data/scripts/lib/utilities.lua")
dofile_once("mods/purgatory/files/materials/LP_AC_reagents.lua")

function create_AP_LC_recipes()
    --Generate custom recipes for AP and LC
    local AP_recipe = {}
    local LC_recipe = {}

    local year, month, day, hour, minute, second = GameGetDateAndTimeLocal()

    local cond = true
    local count = 0
    while cond do

        math.randomseed(tonumber(tostring(hour) .. tostring(minute) .. tostring(second)))

        AP_recipe[1] = getRandominListwithoutWorldSeed(normal_liquids_reagents)
        AP_recipe[2] = getRandominListwithoutWorldSeed(magical_liquids_reagents)
        AP_recipe[3] = getRandominListwithoutWorldSeed(powder_reagents)

        LC_recipe[1] = getRandominListwithoutWorldSeed(normal_liquids_reagents)
        LC_recipe[2] = getRandominListwithoutWorldSeed(magical_liquids_reagents)
        LC_recipe[3] = getRandominListwithoutWorldSeed(powder_reagents)

        --[[
        AP_recipe[1] = "water"
        AP_recipe[2] = "magic_liquid_polymorph"
        AP_recipe[3] = "sand"

        LC_recipe[1] = "blood"
        LC_recipe[2] = "magic_liquid_movement_faster"
        LC_recipe[3] = "silver"
        ]]
        
        if AP_recipe[1] == LC_recipe[1] and AP_recipe[2] == LC_recipe[2] and AP_recipe[3] == LC_recipe[3] then
            cond = true
            count = count + 1
        else
            cond = false
        end
    end
    
    return AP_recipe, LC_recipe
end

function set_AP_LC_recipes(AP_recipe, LC_recipe)

    --Apprends the material file to include the cusotm AP LC recipes
    ModTextFileSetContent("mods/purgatory/files/materials/LC_AP_recipes.xml",
        [[<Materials> ]] ..
        [[<Reaction probability="100" ]] ..
        [[input_cell1="]] ..
        AP_recipe[1] ..
        [[" input_cell2="]] ..
        AP_recipe[2] ..
        [[" input_cell3="]] ..
        AP_recipe[3] ..
        [[" output_cell1="purgatory_alchemic_precursor" output_cell2="purgatory_alchemic_precursor" output_cell3="purgatory_alchemic_precursor"> </Reaction> ]] ..
        [[<Reaction probability="100" ]] ..
        [[input_cell1="]] ..
        LC_recipe[1] ..
        [[" input_cell2="]] ..
        LC_recipe[2] ..
        [[" input_cell3="]] ..
        LC_recipe[3] ..
        [["output_cell1="purgatory_lively_concoction" output_cell2="purgatory_lively_concoction" output_cell3="purgatory_lively_concoction"> </Reaction> ]] ..
        [[<Reaction probability="100" ]] ..
        [[input_cell1="purgatory_alchemic_precursor" ]] ..
        [[input_cell2="]] ..
        AP_recipe[1] ..
        [["output_cell1="purgatory_alchemic_precursor" output_cell2="purgatory_alchemic_precursor"> </Reaction> ]] ..
        [[<Reaction probability="100" ]] ..
        [[input_cell1="purgatory_alchemic_precursor" ]] ..
        [[input_cell2="]] ..
        AP_recipe[2] ..
        [["output_cell1="purgatory_alchemic_precursor" output_cell2="purgatory_alchemic_precursor"> </Reaction> ]] ..
        [[<Reaction probability="100" ]] ..
        [[input_cell1="purgatory_alchemic_precursor" ]] ..
        [[input_cell2="]] ..
        AP_recipe[3] ..
        [["output_cell1="purgatory_alchemic_precursor" output_cell2="purgatory_alchemic_precursor"> </Reaction> ]] ..
        [[<Reaction probability="100" ]] ..
        [[input_cell1="purgatory_lively_concoction" ]] ..
        [[input_cell2="]] ..
        LC_recipe[1] ..
        [["output_cell1="purgatory_lively_concoction" output_cell2="purgatory_lively_concoction"> </Reaction> ]] ..
        [[<Reaction probability="100" ]] ..
        [[input_cell1="purgatory_lively_concoction" ]] ..
        [[input_cell2="]] ..
        LC_recipe[2] ..
        [["output_cell1="purgatory_lively_concoction" output_cell2="purgatory_lively_concoction"> </Reaction> ]] ..
        [[<Reaction probability="100" ]] ..
        [[input_cell1="purgatory_lively_concoction" ]] ..
        [[input_cell2="]] ..
        LC_recipe[3] ..
        [["output_cell1="purgatory_lively_concoction" output_cell2="purgatory_lively_concoction"> </Reaction> ]] ..
        [[</Materials>]]
    )
    ModMaterialsFileAdd("mods/purgatory/files/materials/LC_AP_recipes.xml")

end