local env = env
GLOBAL.setfenv(1, GLOBAL)

env.AddPrefabPostInit("crabking", function(inst)
	if not TheWorld.ismastersim then
		return
	end
	if TUNING.DSTU.VETCURSE ~= "off" then
		inst:AddComponent("vetcurselootdropper")
		inst.components.vetcurselootdropper.loot = "crabclaw"
	end
	inst.components.lootdropper:AddChanceLoot("dormant_rain_horn",1.00)
	--[[
	--hoarder ck
	Shelved until UTW. Not satisfied with this...
	inst:ListenForEvent("death", function(inst)
		local pos = inst:GetPosition()
		local messagebottletreasures = require("messagebottletreasures_um")
		local red = inst.countgems(inst).red
		local blue = inst.countgems(inst).blue
		local purple = inst.countgems(inst).purple
		local yellow = inst.countgems(inst).yellow
		local orange = inst.countgems(inst).orange
		local green = inst.countgems(inst).green
		local opal = inst.countgems(inst).opal+1
		local pearl = inst.countgems(inst).pearl*3

		if red > 2 then
			red = 2
		end
		if blue > 2 then
			blue = 2
		end
		if purple > 2 then
			purple = 2
		end
		if yellow > 2 then
			yellow = 2
		end
		if orange > 2 then
			orange = 2
		end
		if green > 2 then
			green = 2
		end
		if opal > 2 then
			opal = 2
		end

		local royalcount = 3+(red + blue + purple + yellow + orange + green + pearl)*opal
		local normalcount = (1+(red + blue + purple + yellow + orange + green + pearl)*opal)
		local royalpos = royalcount*0.33
		local normalpos = normalcount*1.25

		print(royalcount)
		print(normalcount)
		for i = 1, royalcount do
			messagebottletreasures.GenerateTreasure(pos, "sunkenchest_royal").Transform:SetPosition(pos.x + math.random(-royalpos, royalpos), pos.y, pos.z + math.random(-royalpos, royalpos))
		end
		for i = 1, normalcount do
			messagebottletreasures.GenerateTreasure(pos, "sunkenchest").Transform:SetPosition(pos.x + math.random(-normalpos, normalpos), pos.y, pos.z + math.random(-normalpos, normalpos))
		end
	end)
]]
	local DAMAGE_SCALE = 0.5
	local function OnCollide(inst, data)
		local boat_physics = data.other.components.boatphysics
		if boat_physics ~= nil then
			local hit_velocity = math.floor(math.abs(boat_physics:GetVelocity() * data.hit_dot_velocity) * DAMAGE_SCALE / boat_physics.max_velocity + 0.5)
			print(hit_velocity)
			if inst.components.health ~= nil then
				inst.components.health:DoDelta(-400*hit_velocity)
			end
		end
	end
	inst:ListenForEvent("on_collide", OnCollide)

end)