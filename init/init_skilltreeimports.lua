-- ADD ALL THE SKILL THREE IMAGES HERE

local OldGetSkilltreeBG = GLOBAL.GetSkilltreeBG
function GLOBAL.GetSkilltreeBG(imagename, ...)
    if imagename == "wathgrithr_background.tex" and GetModConfigData("wathgrithr_rework_") == 1 then
        return "images/wathgrithr_rework_skilltree.xml"

    elseif imagename == "wolfgang_background.tex" and GetModConfigData("wolfgang") then
        return "images/wolfgang_rework_skilltree.xml"
        
    --ADD OTHER CHARACTERS HERE
    
    else
        return OldGetSkilltreeBG(imagename, ...)
    end
end