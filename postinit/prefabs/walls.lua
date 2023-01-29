local env = env
GLOBAL.setfenv(1, GLOBAL)

local anims =
{
    { threshold = 0, anim = "broken" },
    { threshold = 0.4, anim = "onequarter" },
    { threshold = 0.5, anim = "half" },
    { threshold = 0.99, anim = "threequarter" },
    { threshold = 1, anim = { "fullA", "fullB", "fullC" } },
}
local all_walls = 
{
    "wall_stone",
    "wall_hay",
    "wall_wood",
    "wall_moonrock",
    "wall_ruins",
    "fence",
    "fence_gate"
}
local function makeobstacle(inst)
    inst.Physics:SetActive(true)
    inst._ispathfinding:set(true)
	inst:AddTag("wall")
end

local function clearobstacle(inst)
    inst.Physics:SetActive(false)
    inst._ispathfinding:set(false)
	inst:RemoveTag("wall")
end

local function resolveanimtoplay(inst, percent)
    for i, v in ipairs(anims) do
        if percent <= v.threshold then
            if type(v.anim) == "table" then
                -- get a stable animation, by basing it on world position
                local x, y, z = inst.Transform:GetWorldPosition()
                local x = math.floor(x)
                local z = math.floor(z)
                local q1 = #v.anim + 1
                local q2 = #v.anim + 4
                local t = ( ((x%q1)*(x+3)%q2) + ((z%q1)*(z+3)%q2) )% #v.anim + 1
                return v.anim[t]
            else
                return v.anim
            end
        end
    end
end

local function onhealthchange(inst, old_percent, new_percent)
    local anim_to_play = resolveanimtoplay(inst, new_percent)
    if new_percent > 0 then
        if old_percent <= 0 then
            makeobstacle(inst)
        end
        inst.AnimState:PlayAnimation(anim_to_play.."_hit")
        inst.AnimState:PushAnimation(anim_to_play, false)
    else
        if old_percent > 0 then
            clearobstacle(inst)
        end
        inst.AnimState:PlayAnimation(anim_to_play)
    end
end

env.AddPrefabPostInit("wall_stone", function(inst)--what's this for??
	if not TheWorld.ismastersim then    
		return
	end
	
	if inst.components.health ~= nil then
		inst.components.health.ondelta = onhealthchange
		inst.components.health.nofadeout = true
	end
end)

for k, v in ipairs(all_walls) do
    env.AddPrefabPostInit(v, function(inst)
        --inst:AddTag("companion")
        --maybe we can return to this some day.
    end)
end