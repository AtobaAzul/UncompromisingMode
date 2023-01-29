local env = env
GLOBAL.setfenv(1, GLOBAL)

local function Sway(inst, monster, monsterpost)
    if inst.sg:HasStateTag("burning") or inst:HasTag("stump") then
        return
    elseif monster then
        inst.sg:GoToState("gnash_pre", { push = false, skippre = false })
    elseif monsterpost then
        inst.sg:GoToState(inst.sg:HasStateTag("gnash") and "gnash_pst" or "gnash_idle")
    elseif inst.monster then
        inst.sg:GoToState("gnash_idle")
    else
        inst.AnimState:PlayAnimation(math.random() < .5 and inst.anims.sway1 or inst.anims.sway2, true)
    end
end

local builds =
{
    normal = { --Green
        leavesbuild="tree_leaf_green_build",
        prefab_name="deciduoustree",
        normal_loot = {"log", "log"},
        short_loot = {"log"},
        tall_loot = {"log", "log", "log", "acorn"},
        drop_acorns=true,
        fx="green_leaves",
        chopfx="green_leaves_chop",
        shelter=true,
    },
    barren = {
        leavesbuild=nil,
        prefab_name="deciduoustree",
        normal_loot = {"log", "log"},
        short_loot = {"log"},
        tall_loot = {"log", "log", "log"},
        drop_acorns=false,
        fx=nil,
        chopfx=nil,
        shelter=false,
    },
    red = {
        leavesbuild="tree_leaf_red_build",
        prefab_name="deciduoustree",
        normal_loot = {"log", "log"},
        short_loot = {"log"},
        tall_loot = {"log", "log", "log", "acorn"},
        drop_acorns=true,
        fx="red_leaves",
        chopfx="red_leaves_chop",
        shelter=true,
    },
    orange = {
        leavesbuild="tree_leaf_orange_build",
        prefab_name="deciduoustree",
        normal_loot = {"log", "log"},
        short_loot = {"log"},
        tall_loot = {"log", "log", "log", "acorn"},
        drop_acorns=true,
        fx="orange_leaves",
        chopfx="orange_leaves_chop",
        shelter=true,
    },
    yellow = {
        leavesbuild="tree_leaf_yellow_build",
        prefab_name="deciduoustree",
        normal_loot = {"log", "log"},
        short_loot = {"log"},
        tall_loot = {"log", "log", "log", "acorn"},
        drop_acorns=true,
        fx="yellow_leaves",
        chopfx="yellow_leaves_chop",
        shelter=true,
    },
    poison = {
        leavesbuild="tree_leaf_poison_build",
        prefab_name="deciduoustree",
        normal_loot = {"livinglog", "acorn", "acorn"},
        short_loot = {"livinglog", "acorn"},
        tall_loot = {"livinglog", "acorn", "acorn", "acorn"},
        drop_acorns=true,
        fx="purple_leaves",
        chopfx="purple_leaves_chop",
        shelter=true,
    },
}

local function GetBuild(inst)
    return builds[inst.build] or builds.normal
end

local function GrowLeavesFn(inst, monster, monsterout)
    if (inst.components.burnable ~= nil and inst.components.burnable:IsBurning()) or
        inst:HasTag("stump") or
        inst:HasTag("burnt") then
        inst:RemoveEventCallback("animover", GrowLeavesFn)
        return
    end

    if inst.leaf_state == "barren" or inst.target_leaf_state == "barren" then 
        inst:RemoveEventCallback("animover", GrowLeavesFn)
        if inst.target_leaf_state == "barren" then
            inst.build = "barren"
        end
    end

    if GetBuild(inst).leavesbuild then
        inst.AnimState:OverrideSymbol("swap_leaves", GetBuild(inst).leavesbuild, "swap_leaves")
    else
        inst.AnimState:ClearOverrideSymbol("swap_leaves")
    end

    if inst.components.growable ~= nil then
        if inst.components.growable.stage == 1 then
            inst.components.lootdropper:SetLoot(GetBuild(inst).short_loot)
        elseif inst.components.growable.stage == 2 then
            inst.components.lootdropper:SetLoot(GetBuild(inst).normal_loot)
        else
            inst.components.lootdropper:SetLoot(GetBuild(inst).tall_loot)
        end
    end

    inst.leaf_state = inst.target_leaf_state
    if inst.leaf_state == "barren" then
        inst.AnimState:ClearOverrideSymbol("mouseover")
    else
        if inst.build == "barren" then
            inst.build = inst.leaf_state == "normal" and "normal" or "red"
        end
        inst.AnimState:OverrideSymbol("mouseover", "tree_leaf_trunk_build", "toggle_mouseover")
    end

    if monster ~= true and monsterout ~= true then
        Sway(inst)
    end
end

local function OnChangeLeaves(inst, monster, monsterout)
    if (inst.components.burnable ~= nil and inst.components.burnable:IsBurning()) or
        inst:HasTag("stump") or
        inst:HasTag("burnt") then
        inst.targetleaveschangetime = nil
        inst.leaveschangetask = nil
        return
    elseif not monster and inst.components.workable and inst.components.workable.lastworktime and inst.components.workable.lastworktime < GetTime() - 10 then
        inst.targetleaveschangetime = GetTime() + 11
        inst.leaveschangetask = inst:DoTaskInTime(11, OnChangeLeaves)
        return
    else
        inst.targetleaveschangetime = nil
        inst.leaveschangetask = nil
    end

    if inst.target_leaf_state ~= "barren" then
        if inst.target_leaf_state == "colorful" then
            local rand = math.random()
            inst.build = ({ "red", "orange", "yellow" })[math.random(3)]
            inst.AnimState:SetMultColour(1, 1, 1, 1)
        elseif inst.target_leaf_state == "poison" then
            inst.AnimState:SetMultColour(1, 1, 1, 1)
            inst.build = "poison"
        else
            inst.AnimState:SetMultColour(inst.color, inst.color, inst.color, 1)
            inst.build = "normal"
        end

        if inst.leaf_state == "barren" then
            if GetBuild(inst).leavesbuild then
                inst.AnimState:OverrideSymbol("swap_leaves", GetBuild(inst).leavesbuild, "swap_leaves")
            else
                inst.AnimState:ClearOverrideSymbol("swap_leaves")
            end
            inst.AnimState:PlayAnimation(inst.anims.growleaves)
            inst.SoundEmitter:PlaySound("dontstarve/forest/treeGrow")
            inst:ListenForEvent("animover", GrowLeavesFn)
        else
            GrowLeavesFn(inst, monster, monsterout)
        end
    else
        inst.AnimState:PlayAnimation(inst.anims.dropleaves)
        SpawnLeafFX(inst, 11 * FRAMES)
        inst.SoundEmitter:PlaySound("dontstarve/forest/treeWilt")
        inst:ListenForEvent("animover", GrowLeavesFn)
    end
    if GetBuild(inst).shelter then
        inst:AddTag("shelter")
    else
        inst:RemoveTag("shelter")
    end
end

env.AddPrefabPostInit("deciduoustree", function(inst)
	if not TheWorld.ismastersim then
		return
	end
	
local _Onload = inst.OnLoad
local function OnLoad(inst,data)

if TheWorld:HasTag("cave") then
inst.build = "poison"
inst:DoTaskInTime(3,function(inst) OnChangeLeaves(inst,false) 
inst.build = "poison"
inst.AnimState:OverrideSymbol("swap_leaves", GetBuild(inst).leavesbuild, "swap_leaves") end)
if data ~= nil then
data.build = "poison"
--_Onload(inst,data)

end
end
end
inst.OnLoad = OnLoad
end)

env.AddPrefabPostInit("deciduoustree_normal", function(inst)
	if not TheWorld.ismastersim then
		return
	end
	
local _Onload = inst.OnLoad
local function OnLoad(inst,data)

if TheWorld:HasTag("cave") then
inst.build = "poison"
inst:DoTaskInTime(3,function(inst) OnChangeLeaves(inst,false) 
inst.build = "poison"
inst.AnimState:OverrideSymbol("swap_leaves", GetBuild(inst).leavesbuild, "swap_leaves") end)
if data ~= nil then
data.build = "poison"
--_Onload(inst,data)
end
end
end
inst.OnLoad = OnLoad
end)

env.AddPrefabPostInit("deciduoustree_tall", function(inst)
	if not TheWorld.ismastersim then
		return
	end
	
local _Onload = inst.OnLoad
local function OnLoad(inst,data)

if TheWorld:HasTag("cave") then
inst.build = "poison"
inst:DoTaskInTime(3,function(inst) OnChangeLeaves(inst,false) 
inst.build = "poison" end)
if data ~= nil then
data.build = "poison"
--_Onload(inst,data)
end
end
end
inst.OnLoad = OnLoad
end)