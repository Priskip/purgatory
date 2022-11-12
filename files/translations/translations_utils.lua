--Taken from Goki's Things
function append_translations( filepath, translation_file )
    if translation_file == nil then
        translation_file = "data/translations/common.csv";
    end
    local translations = ModTextFileGetContent( translation_file );
    if translations ~= nil then
        while translations:find("\r\n\r\n") do
            translations = translations:gsub("\r\n\r\n","\r\n");
        end
        local new_translations = ModTextFileGetContent( filepath );
        translations = translations .. new_translations;
        ModTextFileSetContent( translation_file, translations );
    end
end