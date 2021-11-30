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