local env = env
GLOBAL.setfenv(1, GLOBAL)
-----------------------------------------------------------------
local clockworks =
{
	"knight",
	"bishop",
	"rook",
	"knight_nightmare",
	"bishop_nightmare",
	"rook_nightmare",
}

local zombies = --Keep the stunning clockworks less likely, roship the least
{
	bight = 0.75,
	knook = 1,
	roship = 0.5,
}

local function ZombieClockwork(inst,target)
	local x,y,z = inst.Transform:GetWorldPosition()
	local x2 = x + math.random(-8, 8)
	local z2 = z + math.random(-8, 8)
	while not TheWorld.Map:IsPassableAtPoint(x2, 0, z2) do
		x2 = x + math.random(-8, 8)
		z2 = z + math.random(-8, 8)
	end
	local zombie = SpawnPrefab(weighted_random_choice(zombies))
	zombie.Transform:SetPosition(x2, 0, z2)
	if not zombie:HasTag("uncompromising_pawn") then
		zombie.sg:GoToState("zombie")
	end
	--[[if target ~= nil and zombie.components.combat ~= nil then
		zombie.components.combat:SuggestTarget(target)
	end]]
end

local function LookNearby(inst,data)
	local x,y,z = inst.Transform:GetWorldPosition()
	local clockworks = #TheSim:FindEntities(x,y,z,24,{"chess"},{"mech"})
	local chessjunk = FindEntity(inst,24,nil,{"chess","mech"})
	if (math.random()-(clockworks^1.5)*0.1) > 0.6 and TUNING.DSTU.AMALGAMS and chessjunk ~= nil then -- We want it to be pretty likely if it was the last clockwork, however, if there's more than 1 it shouldn't be likely
		if data.afflicter ~= nil then
			if chessjunk.SpawnClockwork ~= nil then
				chessjunk.SpawnClockwork(chessjunk,data.afflicter)
			end
		else
			if chessjunk.SpawnClockwork ~= nil then
				chessjunk.SpawnClockwork(chessjunk,nil)
			end
		end
	elseif (math.random()-(clockworks^1.5)*0.1) > 0.8 and TheWorld:HasTag("cave") then --Not quite as likely if there's no chessjunk nearby, but still have a very rare case where a zombie may come out of the ground, damaged pawns can come too
		if data.afflicter ~= nil then
			ZombieClockwork(inst,data.afflicter)
		else
			ZombieClockwork(inst,nil)
		end
	end
end

for i, v in ipairs(clockworks) do
	env.AddPrefabPostInit(v, function(inst)
		inst:ListenForEvent("death", LookNearby)
	end)
end
