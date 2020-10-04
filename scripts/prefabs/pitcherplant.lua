require "prefabutil"

local assets =
{
    Asset("ANIM", "anim/pitcher.zip"),

    Asset("ANIM", "anim/bee_box_hermitcrab.zip"),
    Asset("MINIMAP_IMAGE", "beebox_hermitcrab"),
}

local prefabs =
{
    "fruitbat",
	"honey",
}

SetSharedLootTable( 'pitcherplant',
{
    {'honey',1},
})

local function OnEnterLight(inst)
    if not (TheWorld.state.iswinter or inst:HasTag("burnt"))
        and TheWorld.state.iscaveday then
        Start(inst)
    end
end

local function OnEnterDark(inst)
    Stop(inst)
end



local function onchildgoinghome(inst, data)
        if data.child ~= nil and
        data.child.bugcount ~= nil then
		inst.count = data.child.bugcount
        end
end

local function SeasonalSpawnChanges(inst, season)
    if inst.components.childspawner then
        if season == SEASONS.SPRING then
            inst.components.childspawner:SetRegenPeriod(TUNING.BEEBOX_REGEN_TIME / TUNING.SPRING_COMBAT_MOD)
            inst.components.childspawner:SetSpawnPeriod(TUNING.BEEBOX_RELEASE_TIME / TUNING.SPRING_COMBAT_MOD)
            inst.components.childspawner:SetMaxChildren(1)
        else
            inst.components.childspawner:SetRegenPeriod(TUNING.BEEBOX_REGEN_TIME)
            inst.components.childspawner:SetSpawnPeriod(TUNING.BEEBOX_RELEASE_TIME)
            inst.components.childspawner:SetMaxChildren(1)
        end
    end
end

local function onsave(inst, data)
data.count = inst.count
end

local function onload(inst, data)
if data ~= nil and data.count ~= nil then
inst.count = data.count
end
end
local function StartSpawning(inst)
    if inst.components.childspawner ~= nil
        and not TheWorld.state.iswinter
        and not (inst.components.freezable ~= nil and inst.components.freezable:IsFrozen()) then
        inst.components.childspawner:StartSpawning()
    end
end

local function StopSpawning(inst)
    if inst.components.childspawner ~= nil then
        inst.components.childspawner:StopSpawning()
    end
end
local function OnIsDay(inst, isday)
    if isday then
        StartSpawning(inst)
    else
        StopSpawning(inst)
    end
end
local function OnInit(inst)
    inst:WatchWorldState("isday", OnIsDay)
    OnIsDay(inst, TheWorld.state.isday)
	local x, y ,z = inst.Transform:GetWorldPosition()
	--inst.Transform:SetPosition(x,9,z)
end

local function onspawnbat(inst, bat)
    bat.sg:GoToState("flyback")
end

local function MakeBeebox(name, common_postinit)

    local function fn()
        local inst = CreateEntity()

        inst.entity:AddTransform()
        inst.entity:AddAnimState()
        inst.entity:AddSoundEmitter()
        inst.entity:AddMiniMapEntity()
        inst.entity:AddNetwork()
        inst.entity:AddLightWatcher()


        inst.MiniMapEntity:SetIcon("pitcher.tex")

		inst.AnimState:SetBank("pitcher")
		inst.AnimState:SetBuild("pitcher")
		inst.AnimState:PlayAnimation("swinglong")
		inst:AddTag("CLASSIFIED")
      
  
        if common_postinit ~= nil then
            common_postinit(inst)
        end

        inst.entity:SetPristine()

        if not TheWorld.ismastersim then
            return inst
        end

        ---------------------  

        inst:ListenForEvent("childgoinghome", onchildgoinghome)
        -------------------

        inst:AddComponent("childspawner")
        inst.components.childspawner.childname = "fruitbat"
        inst.components.childspawner.allowwater = true
        SeasonalSpawnChanges(inst, TheWorld.state.season)
        inst:WatchWorldState("season", SeasonalSpawnChanges)

        if TheWorld.state.isday and not TheWorld.state.iswinter then
            inst.components.childspawner:StartSpawning()
        end

		inst:DoTaskInTime(0, OnInit)

        inst:AddComponent("inspectable")
		inst.components.childspawner:SetSpawnedFn(onspawnbat)
		inst:AddComponent("lootdropper")
		inst.components.lootdropper:SetChanceLootTable("pitcherplant")
		MakeLargePropagator(inst)
		inst.count = 0
		inst.OnSave = onsave
		inst.OnLoad = onload  
		
        return inst
    end

    return Prefab(name, fn, assets, prefabs)
end


return MakeBeebox("pitcherplant")

    
