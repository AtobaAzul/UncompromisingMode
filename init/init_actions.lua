-- DEPLOY_AI Action [FIX FOR MOBS THAT PLANT TREES]
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
