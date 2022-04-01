AddAction(
	"LAVASPIT",
	"LAVASPIT",
	function(act)
    if act.doer and act.target and act.doer.prefab == "dragonfly" then
        local spit = SpawnPrefab("lavaspit")
        local x,y,z = act.doer.Transform:GetWorldPosition()
        local downvec = TheCamera:GetDownVec()
        local offsetangle = math.atan2(downvec.z, downvec.x) * (180/math.pi)
        if act.doer.AnimState:GetCurrentFacing() == 0 then --Facing right
            offsetangle = offsetangle + 70
        else --Facing left
            offsetangle = offsetangle - 70
        end
        while offsetangle > 180 do offsetangle = offsetangle - 360 end
        while offsetangle < -180 do offsetangle = offsetangle + 360 end
        local offsetvec = Vector3(math.cos(offsetangle*DEGREES), -.3, math.sin(offsetangle*DEGREES)) * 1.7
        spit.Transform:SetPosition(x+offsetvec.x, y+offsetvec.y, z+offsetvec.z)
        spit.Transform:SetRotation(act.doer.Transform:GetRotation())
    end
end
)

AddAction(
	"INFEST",
	"INFEST",
	function(act)

		if not act.doer.infesting then
			act.doer.components.infester:Infest(act.target)
		end

		return true
	end
)

AddAction(
	"UNCOMPROMISING_PAWN_HIDE",
	"UNCOMPROMISING_PAWN_HIDE",
	function(act)
		--Dummy action for pawn.
	end
)

AddAction(
	"UNCOMPROMISING_PAWN_SHAKE",
	"UNCOMPROMISING_PAWN_SHAKE",
	function(act)
		--Dummy action for pawn.
	end
)

AddAction(
	"RAT_STEAL_EQUIPPABLE",
	"RAT_STEAL_EQUIPPABLE",
	function(act)
		if act.target.components.container then
			act.target.components.container:DropEverythingWithTag("_equippable")
			return true
		end
	end
)
AddAction(
	"RAT_STEAL_GEM",
	"RAT_STEAL_GEM",
	function(act)
		if act.target.components.container then
			act.target.components.container:DropEverythingWithTag("gem")
			return true
		end
	end
)

AddAction(
	"CASTLIGHTER",
	"CASTLIGHTER",
	function(act)
		local staff = act.invobject or act.doer.components.inventory:GetEquippedItem(EQUIPSLOTS.HANDS)
		local act_pos = act:GetActionPoint()
		if staff and staff:HasTag("lighter") and staff.components.spellcaster and staff.components.spellcaster:CanCast(act.doer, act.target, act_pos) then
			staff.components.spellcaster:CastSpell(act.target, act_pos)
			return true
		end
	end
)

AddAction(
	"WINGSUIT",
	"WINGSUIT",
	function(act)
		local staff = act.invobject or act.doer.components.inventory:GetEquippedItem(EQUIPSLOTS.BODY)
		local act_pos = act:GetActionPoint()
		if staff and staff.components.spellcaster and staff.components.spellcaster:CanCast(act.doer, act.target, act_pos) then
			staff.components.spellcaster:CastSpell(act.target, act_pos)
			return true
		end
	end
)

local createburrow = AddAction(
	"CREATE_BURROW",
	GLOBAL.STRINGS.ACTIONS.CREATE_BURROW,
	function(act)
		local act_pos = act:GetActionPoint()
		if act.doer.components.hunger.current > 15 and not GLOBAL.TheWorld.Map:GetPlatformAtPoint(act_pos.x, act_pos.z) then
			local burrows = GLOBAL.TheSim:FindEntities(act_pos.x, 0, act_pos.z, 10000, {"winkyburrow"})
			local home = false
			
			for i, v in pairs(burrows) do
				if v.myowner == act.doer.userid then
					home = true
				end
			end
			
			if home then
				local burrow = GLOBAL.SpawnPrefab("uncompromising_winkyburrow")
				burrow.Transform:SetPosition(act_pos.x, 0, act_pos.z)
				act.doer.components.hunger:DoDelta(-15)
			else
				local burrow = GLOBAL.SpawnPrefab("uncompromising_winkyhomeburrow")
				burrow.Transform:SetPosition(act_pos.x, 0, act_pos.z)
				burrow.myowner = act.doer.userid
				
				act.doer.components.hunger:DoDelta(-20)
			end
				
			return true
		end
	end
)

createburrow.priority = HIGH_ACTION_PRIORITY
createburrow.rmb = true
createburrow.distance = 2
createburrow.mount_valid = false