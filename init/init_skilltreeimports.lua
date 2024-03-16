-- ADD ALL THE SKILL THREE IMAGES HERE

local OldGetSkilltreeBG = GLOBAL.GetSkilltreeBG
function GLOBAL.GetSkilltreeBG(imagename, ...)
    if imagename == "wathgrithr_background.tex" and GetModConfigData("wathgrithr_rework") == 1 then
        return "images/wathgrithr_rework_skilltree.xml"

    --else if then
    --ADD OTHER CHARACTERS HERE
    else
        return OldGetSkilltreeBG(imagename, ...)
    end
end