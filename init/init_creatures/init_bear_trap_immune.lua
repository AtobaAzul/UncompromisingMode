local TRAPIMMUNE = 
{
	"hound",
	"icehound",
	"firehound",
	"lightninghound",
	"sporehound",
	"glacialhound",
	"magmahound",
	"walrus",
	"little_walrus",
}

local function AddBearTrapImmune(prefab)
	AddPrefabPostInit(prefab, function(inst)
		if not GLOBAL.TheWorld.ismastersim then
			return
		end
		
		inst:AddTag("bear_trap_immune")
		
	end)
end

for k, v in pairs(TRAPIMMUNE) do
	AddBearTrapImmune(v)
end