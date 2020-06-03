local env = env
GLOBAL.setfenv(1, GLOBAL)
local infestables =
{
"bat",
"vampirebat",
"bunnyman",
"pigman",
"slurtle",
"slurper",
"monkey",
"rocky",
"spider",
"spiderqueen",
"spider_warrior",
"spider_dropper",
"spider_spitter",
"spider_hider",
"spider_moon",
"beefalo",
"bee",
"killerbee",
"mosquito",
}
local function Infestablize(prefab)
	env.AddPrefabPostInit(prefab, function(inst)
	inst:AddComponent("infestable")
	inst:AddTag("infestable")
	end)
end
for k, v in pairs(infestables) do
Infestablize(v)
end
env.AddPlayerPostInit( function(inst)
inst:AddComponent("infestable")
inst:AddTag("infestable")
inst:ListenForEvent("respawnfromghost", function(inst) inst:AddComponent("infestable")
inst:AddTag("infestable") end)
inst:ListenForEvent("respawnfromcorpse",function(inst) inst:AddComponent("infestable")
inst:AddTag("infestable") end)
end)