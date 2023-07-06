local env = env
GLOBAL.setfenv(1, GLOBAL)

local mooneyes = {
	"purplemooneye",
	"bluemooneye",
	"redmooneye",
	"orangemooneye",
	"yellowmooneye",
	"greenmooneye"
}

local function tosack(inst, owner)
	if owner ~= nil and owner:HasTag("klaussacklock") then
		if inst.icon == nil then
			inst.icon = SpawnPrefab("globalmapicon")
			inst.icon:TrackEntity(inst)
		end
	end
end

for i, v in pairs(mooneyes) do 
	env.AddPrefabPostInit(v, function(inst)
        inst:ListenForEvent("onputininventory", tosack)
	end)
end
