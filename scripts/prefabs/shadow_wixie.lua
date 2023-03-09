--[[
 .____                  ________ ___.    _____                           __                
 |    |    __ _______   \_____  \\_ |___/ ____\_ __  ______ ____ _____ _/  |_  ___________ 
 |    |   |  |  \__  \   /   |   \| __ \   __\  |  \/  ___// ___\\__  \\   __\/  _ \_  __ \
 |    |___|  |  // __ \_/    |    \ \_\ \  | |  |  /\___ \\  \___ / __ \|  | (  <_> )  | \/
 |_______ \____/(____  /\_______  /___  /__| |____//____  >\___  >____  /__|  \____/|__|   
         \/          \/         \/    \/                \/     \/     \/                   
          \_Welcome to LuaObfuscator.com   (Alpha 0.2.5) ~  Much Love, Ferib 

]]--

require("brains/old_shadowwaxwellbrain");require("stategraphs/SGold_shadowwaxwell");local v0={Asset("ANIM","anim/waxwell_shadow_mod.zip"),Asset("SOUND","sound/maxwell.fsb"),Asset("ANIM","anim/swap_pickaxe.zip"),Asset("ANIM","anim/swap_axe.zip"),Asset("ANIM","anim/swap_nightmaresword.zip")};local v1={};local function v2(v3)local v28=v3.components.combat.target;local v29,v30,v31=v3.Transform:GetWorldPosition();local v32=TheSim:FindEntities(v29,v30,v31,40,{"player"});local v33=math.huge;for v127,v128 in ipairs(v32) do local v129=v128:GetDistanceSqToPoint(v29,v30,v31);local v130=TheSim:FindEntities(v29,v30,v31,40,{"shadow_wixie"});for v149,v150 in ipairs(v130) do if (( #v130==1) or ((v150~=v3) and ((v150.components.combat.target==nil) or (v150.components.combat.target~=v128)))) then if ((v129<v33) and v3.components.combat:CanTarget(v128) and (v28==nil)) then v33=v129;v28=v128;end end end end return v28,true;end local function v4(v3,v5)local v34,v35,v36=v3.Transform:GetWorldPosition();local v37=TheSim:FindEntities(v34,v35,v36,40,{"shadow_wixie"});for v131,v132 in ipairs(v37) do if ((v132~=v3) and (v132.components.combat.target~=nil) and (v132.components.combat.target==v5)) then return false;end end return true;end local function v6(v3,v7)if (v7~=nil) then v3.components.combat:SetTarget(v7.attacker);end end local function v8(v3,v7)local v38=v7.amount or 0 ;v3.decoy_attack_count=v3.decoy_attack_count + v38 ;if (v3.decoy_attack_count<= -1500) then v3.decoy_attack=true;end v3.marble_bag_attack_count=v3.marble_bag_attack_count + v38 ;if (v3.marble_bag_attack_count<= -250) then if (v3.components.health:GetPercent()<=0.75) then v3.marble_bag_attack_count=0;v3.marble_bag_attack=true;end end v3.SoundEmitter:PlaySound("UCSounds/shadow_wixie/appear");local v41,v42,v43=v3.Transform:GetWorldPosition();local v44=TheSim:FindEntities(v41,v42,v43,40,{"shadow_wixie_clone"});for v133,v134 in pairs(v44) do if ((v134~=nil) and v134:IsValid()) then SpawnPrefab("shadow_despawn").Transform:SetPosition(v134.Transform:GetWorldPosition());if (v134.physbox~=nil) then v134.physbox:Remove();end v134:Remove();end end v3.force_invincible_value=v3.force_invincible_value + v38 ;if (v3.force_invincible_value<= -500) then v3.sg:GoToState("disappear");elseif (v3.sg.currentstate.name=="trickster") then v3.sg:GoToState("claustrophobia");end end local function v9(v3,v10)if ((ThePlayer==nil) or v3:HasTag("flight") or IsEntityDead(v3)) then v3._playingmusic=false;elseif ThePlayer:IsNear(v3,(v3._playingmusic and 40) or 20 ) then v3._playingmusic=true;ThePlayer:PushEvent("playwixiemusic",{name="wixie",level=v10});elseif (v3._playingmusic and  not ThePlayer:IsNear(v3,50)) then v3._playingmusic=false;end end local function v11(v3)if  not TheNet:IsDedicated() then if (v3._musictask~=nil) then v3._musictask:Cancel();end local v153=(v3._pausemusic:value() and 2) or (v3._unchained:value() and 3) or 1 ;v3._musictask=v3:DoPeriodicTask(1,v9,nil,v153);v9(v3,v153);end end local function v12()local v46=CreateEntity();v46.entity:AddTransform();v46.entity:AddAnimState();v46.entity:AddSoundEmitter();v46.entity:AddNetwork();v46.Transform:SetFourFaced(v46);MakeCharacterPhysics(v46,10,0.25);RemovePhysicsColliders(v46);v46.Physics:SetCollisionGroup(COLLISION.SANITY);v46.Physics:CollidesWith(COLLISION.SANITY);v46.AnimState:SetBank("wilson");v46.AnimState:SetBuild("wixie");v46.AnimState:HideSymbol("face");v46.AnimState:OverrideSymbol("fx_wipe","wilson_fx","fx_wipe");v46.AnimState:AddOverrideBuild("waxwell_minion_spawn");v46.AnimState:AddOverrideBuild("waxwell_minion_appear");v46.AnimState:AddOverrideBuild("lavaarena_shadow_lunge");v46.AnimState:SetMultColour(0,0,0,0.6);v46.AnimState:UsePointFiltering(true);v46.AnimState:PlayAnimation("idle");v46.AnimState:Hide("ARM_carry");v46.AnimState:Hide("hat");v46.AnimState:Hide("hat_hair");v46:AddTag("epic");v46:AddTag("hostile");v46:AddTag("notraptrigger");v46:AddTag("shadowchesspiece");v46:AddTag("shadowcreature");v46:AddTag("shadow_wixie");v46:AddTag("prime_shadow_wixie");v46._unchained=net_bool(v46.GUID,"klaus._unchained","musicdirty");v46._pausemusic=net_bool(v46.GUID,"klaus_pausemusic","musicdirty");v46._playingmusic=false;v46._musictask=nil;v11(v46);v46.entity:SetPristine();if  not TheWorld.ismastersim then v46:ListenForEvent("musicdirty",v11);return v46;end v46.decoy_attack=false;v46.decoy_attack_count=0;v46.force_invincible_value=0;v46.marble_bag_attack_count=0;v46.stunned_count=0;v46.marble_bag_attack=false;v46.helper=false;v46.AnimState:OverrideSymbol("swap_object","swap_slingshot","swap_slingshot");v46.AnimState:Show("ARM_carry");v46.AnimState:Hide("ARM_normal");v46:AddComponent("locomotor");v46.components.locomotor.walkspeed=8;v46.components.locomotor.runspeed=20;v46.components.locomotor:SetTriggersCreep(false);v46.components.locomotor.pathcaps={ignorecreep=true};v46.components.locomotor:SetSlowMultiplier(0.6);v46:AddComponent("health");v46.components.health:SetMaxHealth(5000);v46.components.health.destroytime=3;v46.components.health.fire_damage_scale=TUNING.WILLOW_FIRE_DAMAGE;v46:AddComponent("colourtweener");v46:AddComponent("combat");v46.components.combat.hiteffectsymbol="torso";v46.components.combat:SetAttackPeriod(2);v46.components.combat:SetRange(5,1);v46.components.combat:SetDefaultDamage(10);v46.components.combat:SetRetargetFunction(1,v2);v46.components.combat:SetKeepTargetFunction(v4);v46:AddComponent("lootdropper");v46.components.lootdropper:SetLoot({"nightmarefuel","nightmarefuel","nightmarefuel","the_real_charles_t_horse"});v46:AddComponent("sanityaura");v46.components.sanityaura.penalty=TUNING.OLD_SHADOWWAXWELL_SANITY_PENALTY;v46:ListenForEvent("attacked",v6);v46:ListenForEvent("healthdelta",v8);v46:ListenForEvent("death",function()if (v46.physbox~=nil) then v46.physbox:Remove();end end);v46:ListenForEvent("removed",function()if (v46.physbox~=nil) then v46.physbox:Remove();end end);local v67=require("brains/shadow_wixie");v46:SetBrain(v67);v46:SetStateGraph("SGshadow_wixie");v46:DoTaskInTime(0,function()if  not v46:HasTag("puzzlespawn") then if (v46.physbox~=nil) then end end end);v46:WatchWorldState("cycles",function()if  not v46.components.health:IsDead() then local v166=TheSim:FindFirstEntityWithTag("wixie_clock");v166.canbeused=true;v166.MakeUsable(v166);local v168,v169,v170=v46.Transform:GetWorldPosition();SpawnPrefab("statue_transition").Transform:SetPosition(v168,v169,v170);SpawnPrefab("statue_transition_2").Transform:SetPosition(v168,v169,v170);if (v46.physbox~=nil) then v46.physbox:Remove();end v46:Remove();end end);v46.persists=false;return v46;end local function v13()local v69=CreateEntity();v69.entity:AddTransform();v69.entity:AddAnimState();v69.entity:AddSoundEmitter();v69.entity:AddNetwork();v69.Transform:SetFourFaced(v69);MakeCharacterPhysics(v69,10,0.25);RemovePhysicsColliders(v69);v69.Physics:SetCollisionGroup(COLLISION.SANITY);v69.Physics:CollidesWith(COLLISION.SANITY);v69.AnimState:SetBank("wilson");v69.AnimState:SetBuild("wixie");v69.AnimState:HideSymbol("face");v69.AnimState:OverrideSymbol("fx_wipe","wilson_fx","fx_wipe");v69.AnimState:AddOverrideBuild("waxwell_minion_spawn");v69.AnimState:AddOverrideBuild("waxwell_minion_appear");v69.AnimState:AddOverrideBuild("lavaarena_shadow_lunge");v69.AnimState:SetMultColour(0,0,0,0.6);v69.AnimState:UsePointFiltering(true);v69.AnimState:PlayAnimation("idle");v69.AnimState:Hide("ARM_carry");v69.AnimState:Hide("hat");v69.AnimState:Hide("hat_hair");v69:AddTag("hostile");v69:AddTag("notraptrigger");v69:AddTag("shadowchesspiece");v69:AddTag("shadowcreature");v69:AddTag("shadow_wixie");v69:AddTag("shadow_wixie_helper");v69:AddTag("shadow_wixie_clone");v69.entity:SetPristine();if  not TheWorld.ismastersim then return v69;end v69.stunned_count=0;v69.helper=true;v69.AnimState:OverrideSymbol("swap_object","swap_slingshot","swap_slingshot");v69.AnimState:Show("ARM_carry");v69.AnimState:Hide("ARM_normal");v69:AddComponent("locomotor");v69.components.locomotor.walkspeed=8;v69.components.locomotor.runspeed=20;v69.components.locomotor:SetTriggersCreep(false);v69.components.locomotor.pathcaps={ignorecreep=true};v69.components.locomotor:SetSlowMultiplier(0.6);v69:AddComponent("health");v69.components.health:SetMaxHealth(1);v69.components.health:SetMaxDamageTakenPerHit(1);v69.components.health.destroytime=3;v69.components.health.fire_damage_scale=TUNING.WILLOW_FIRE_DAMAGE;v69:AddComponent("colourtweener");v69:AddComponent("combat");v69.components.combat.hiteffectsymbol="torso";v69.components.combat:SetAttackPeriod(2);v69.components.combat:SetRange(5,1);v69.components.combat:SetDefaultDamage(10);v69.components.combat:SetRetargetFunction(2,v2);v69.components.combat:SetKeepTargetFunction(v4);v69:AddComponent("lootdropper");v69:AddComponent("sanityaura");v69.components.sanityaura.penalty=TUNING.OLD_SHADOWWAXWELL_SANITY_PENALTY;local v81=require("brains/shadow_wixie");v69:SetBrain(v81);v69:SetStateGraph("SGshadow_wixie");v69:ListenForEvent("death",function()if (v69.physbox~=nil) then v69.physbox:Remove();end end);v69:ListenForEvent("removed",function()if (v69.physbox~=nil) then v69.physbox:Remove();end end);v69:DoTaskInTime(0,function()if  not v69:HasTag("puzzlespawn") then if (v69.physbox~=nil) then v69.physbox:Remove();end v69:Remove();end end);v69:WatchWorldState("cycles",function()if  not v69.components.health:IsDead() then local v171,v172,v173=v69.Transform:GetWorldPosition();SpawnPrefab("statue_transition").Transform:SetPosition(v171,v172,v173);SpawnPrefab("statue_transition_2").Transform:SetPosition(v171,v172,v173);if (v69.physbox~=nil) then v69.physbox:Remove();end v69:Remove();end end);v69.persists=false;return v69;end local function v14(v3,v15,v5)local v83=v3:GetPosition();if ((v3.caster~=nil) and v3.thisistheone) then if TheWorld.Map:IsPassableAtPoint(v83.x,0,v83.z) then v3.caster.Physics:Teleport(v83:Get());end v3.caster.sg:GoToState("trickster");local v155,v156,v157=v3.Transform:GetWorldPosition();local v158=TheSim:FindEntities(v155,v156,v157,40,{"shadow_wixie_helper"});for v174,v175 in pairs(v158) do if ((v175~=nil) and (v175~=v3) and v175:IsValid()) then SpawnPrefab("shadow_despawn").Transform:SetPosition(v175.Transform:GetWorldPosition());if (v175.physbox~=nil) then v175.physbox:Remove();end v175:Remove();end end else local v159,v160,v161=v3.Transform:GetWorldPosition();local v162=SpawnPrefab("wixie_shadow_clone");SpawnPrefab("shadow_puff_large_back").Transform:SetPosition(v159,v160-0.1 ,v161);v162.Transform:SetPosition(v159,v160-0.05 ,v161);SpawnPrefab("shadow_puff_large_front").Transform:SetPosition(v159,v160,v161);local v163=TheSim:FindEntities(v159,v160,v161,15,{"_combat"},{"noclaustrophobia","INLIMBO"});for v176,v177 in pairs(v163) do if (v177:IsValid() and (v177.components~=nil) and (v177.components.combat~=nil) and (v177.components.combat.target~=nil) and (v177.components.combat.target==v3.caster)) then v177.components.combat.target=v162;print("change formation!");end end end local v84,v85,v86=v3.Transform:GetWorldPosition();SpawnPrefab("shadow_despawn").Transform:SetPosition(v84,v85,v86);v3:Remove();end local function v16()local v87=CreateEntity();v87.entity:AddTransform();v87.entity:AddAnimState();v87.entity:AddSoundEmitter();v87.entity:AddNetwork();v87.entity:AddPhysics();v87.Physics:SetMass(1);v87.Physics:SetFriction(0);v87.Physics:SetDamping(0);v87.Physics:SetCollisionGroup(COLLISION.CHARACTERS);v87.Physics:ClearCollisionMask();v87.Physics:CollidesWith(COLLISION.GROUND);v87.Physics:SetCapsule(0.1,0.1);v87.Physics:SetDontRemoveOnSleep(true);v87:AddTag("NOCLICK");v87:AddTag("projectile");v87.AnimState:SetBank("slingshotammo");v87.AnimState:SetBuild("wixieammo");v87.AnimState:PlayAnimation("spin_loop",true);v87.AnimState:OverrideSymbol("rock","wixieammo_IA","slow");v87.AnimState:SetMultColour(0,0,0,0.6);v87.entity:SetPristine();if  not TheWorld.ismastersim then return v87;end v87.thisistheone=false;v87.caster=nil;v87:AddComponent("locomotor");v87:AddComponent("complexprojectile");v87.components.complexprojectile.usehigharc=true;v87.components.complexprojectile:SetHorizontalSpeed(30);v87.components.complexprojectile:SetGravity( -45);v87.components.complexprojectile:SetLaunchOffset(Vector3(0,1.5,0));v87.components.complexprojectile:SetOnHit(v14);return v87;end local function v17(v3)local v91={};local v92=v3;local v93,v94,v95=v92.Transform:GetWorldPosition();local v96=12;local v97=15;local v98=0.2;local v99=2 * PI * math.random() ;local v100=((v3.reversespikes and  -2) or 2) * PI * v96 ;v3.reversespikes= not v3.reversespikes;local v102=0;local v103=2 * FRAMES ;local v104=8;local v105=TheWorld.Map;for v135=1,v104 do local v136=v97;v97=v97;local v137=PI * (v136 + v97) ;local v138=v100/v137 ;v99=v99 + v138 ;local v139=v93 + (v97 * math.cos(v99)) ;local v140=v95 + (v97 * math.sin(v99)) ;if v105:IsPassableAtPoint(v139,0,v140) then table.insert(v91,{t=v102,level=v135/v104 ,pts={Vector3(v139,0,v140)}});v102=v102 + v103 ;end end return v91,v92;end local function v18(v3,v19,v10)if  not v3.components.health:IsDead() then for v178,v179 in ipairs(v19) do local v180=SpawnPrefab("slingshot_target");v180.Transform:SetPosition(v179:Get());v180.persists=false;local v182,v183,v184=v3.Transform:GetWorldPosition();local v185=SpawnPrefab("wixie_shadow_shot");v185.Transform:SetPosition(v182,v183,v184);v185.components.projectile:Throw(v3,v180,v3);v180:DoTaskInTime(0,v180.Remove);end end end local function v20(v3)local v106,v107=v17(v3);if ( #v106>0) then for v186,v187 in ipairs(v106) do v3:DoTaskInTime(0,v18,v187.pts,v187.level);end end v3:DoTaskInTime(0.1,function()SpawnPrefab("shadow_despawn").Transform:SetPosition(v3.Transform:GetWorldPosition());v3:Remove();end);end local function v21()local v108=CreateEntity();v108.entity:AddTransform();v108.entity:AddAnimState();v108.entity:AddSoundEmitter();v108.entity:AddNetwork();v108.AnimState:SetBank("wixie_shadowclone");v108.AnimState:SetBuild("wixie_shadowclone");v108.AnimState:PlayAnimation("pose"   .. math.random(5) ,true);v108:AddTag("monster");v108:AddTag("hostile");v108:AddTag("notraptrigger");v108:AddTag("shadowchesspiece");v108:AddTag("shadow_wixie_clone");v108.entity:SetPristine();if  not TheWorld.ismastersim then return v108;end v108:AddComponent("combat");v108:AddComponent("health");v108.components.health:SetMaxHealth(10);v108:DoTaskInTime(15,function(v108)local v141,v142,v143=v108.Transform:GetWorldPosition();local v144=SpawnPrefab("dreadeye_sanityburstring");v144:AddTag("ignore_transparency");v144.Transform:SetScale(1.4,1.4,1.4);v144.entity:SetParent(v108.entity);for v164,v165 in ipairs(TheSim:FindEntities(v141,v142,v143,4,{"_combat","player"},{"playerghost"})) do if (v165:IsValid() and (v165.components.combat~=nil) and (v165.components.health~=nil)) then if  not (v165.components.health:IsDead() or v165:HasTag("playerghost")) then v165.components.combat:GetAttacked(v108,50,v108);end end end v20(v108);end);v108:ListenForEvent("attacked",function(v108)v108.SoundEmitter:PlaySound("dontstarve/impacts/impact_sanity_armour_dull");end);v108:WatchWorldState("cycles",function()if  not v108.components.health:IsDead() then local v188,v189,v190=v108.Transform:GetWorldPosition();SpawnPrefab("statue_transition").Transform:SetPosition(v188,v189,v190);SpawnPrefab("statue_transition_2").Transform:SetPosition(v188,v189,v190);v108:Remove();end end);v108:ListenForEvent("death",function(v108)SpawnPrefab("wixie_shadow_ring").Transform:SetPosition(v108.Transform:GetWorldPosition());SpawnPrefab("shadow_despawn").Transform:SetPosition(v108.Transform:GetWorldPosition());v108:Remove();end);v108.persists=false;return v108;end local function v22(v3,v5)if ((v5~=nil) and (v5.components.sanity~=nil)) then if ((v5.components.sanity~=nil) and v5.components.sanity:IsSane()) then v5.components.sanity:DoDelta( -10);end end v3:Remove();end local function v23(v3)local v110,v111,v112=v3.Transform:GetWorldPosition();local v113=6;local v114=SpawnPrefab("dreadeye_sanityburstring");v114:AddTag("ignore_transparency");v114.Transform:SetPosition(v110,0,v112);v114.Transform:SetScale(1.8,1.8,1.8);local v115=FindPlayersInRange(v110,v111,v112,v113,{"player"},{"playerghost"});local v116={};for v145,v146 in ipairs(v115) do if v146:IsValid() then v22(v3,v146);end end end local function v24()local v117=CreateEntity();v117.entity:AddTransform();v117.entity:AddAnimState();v117.entity:AddSoundEmitter();v117.entity:AddNetwork();v117.AnimState:SetBank("dreadeye_circle");v117.AnimState:SetBuild("dreadeye_circle");v117.AnimState:PlayAnimation("idle");v117.AnimState:SetOrientation(ANIM_ORIENTATION.OnGround);v117.AnimState:SetLayer(LAYER_BACKGROUND);v117.AnimState:SetSortOrder(3);v117.AnimState:SetMultColour(0,0,0,0.6);v117.Transform:SetScale(2,2,2);v117:AddTag("FX");v117:AddTag("NOCLICK");if  not TheNet:IsDedicated() then v117:AddComponent("transparentonsanity_dreadeye");v117.components.transparentonsanity_dreadeye:ForceUpdate();end v117.entity:SetPristine();if  not TheWorld.ismastersim then return v117;end v117.SoundEmitter:PlaySound("dontstarve/creatures/together/stalker/shield");v117:ListenForEvent("animover",v117.Remove);v117:DoTaskInTime(0,v23);v117.persists=false;return v117;end local function v25(v3)local v119,v120,v121=v3.Transform:GetWorldPosition();local v122=v3.components.projectile.owner or nil ;for v147,v148 in ipairs(TheSim:FindEntities(v119,v120,v121,0.9,{"_combat","player"},{"playerghost"})) do if (v148:IsValid() and (v148.components.combat~=nil) and (v148.components.health~=nil)) then if  not (v148.components.health:IsDead() or (v148==v122) or v148:HasTag("playerghost")) then v148.components.combat:GetAttacked(v122,50,v3);v3:Remove();return;end end end end local function v26()local v123=CreateEntity();v123.entity:AddTransform();v123.entity:AddAnimState();v123.entity:AddSoundEmitter();v123.entity:AddPhysics();v123.entity:AddNetwork();v123.Physics:SetMass(1);v123.Physics:SetFriction(10);v123.Physics:SetDamping(5);v123.Physics:SetCollisionGroup(COLLISION.CHARACTERS);v123.Physics:ClearCollisionMask();v123.Physics:SetCapsule(0.85,0.85);v123.Transform:SetFourFaced();v123.AnimState:SetBank("slingshotammo");v123.AnimState:SetBuild("slingshotammo");v123.AnimState:PlayAnimation("spin_loop",true);v123.AnimState:SetMultColour(0,0,0,0.6);v123:AddTag("projectile");v123:AddTag("scarytoprey");v123.entity:SetPristine();if  not TheWorld.ismastersim then return v123;end v123.persists=false;v123:AddComponent("weapon");v123.components.weapon:SetDamage(50);v123.components.weapon:SetOnAttack(nil);v123.Physics:SetCollisionCallback(nil);v123:DoPeriodicTask(FRAMES,v25,0);v123:AddComponent("locomotor");v123:AddComponent("projectile");v123.components.projectile:SetSpeed(20);v123.components.projectile:SetHoming(false);v123.components.projectile:SetOnPreHitFn(nil);v123.components.projectile:SetOnHitFn(nil);v123.components.projectile:SetOnMissFn(nil);v123.components.projectile:SetLaunchOffset(Vector3(1,0.5,0));v123:DoTaskInTime(2,v123.Remove);return v123;end local function v27()local v125=CreateEntity();v125.entity:AddTransform();v125.entity:AddAnimState();v125.entity:AddSoundEmitter();v125.entity:AddPhysics();v125.entity:AddNetwork();v125.AnimState:SetBank("forcefield");v125.AnimState:SetBuild("forcefield");v125.AnimState:PlayAnimation("open");v125.AnimState:PushAnimation("idle_loop",true);v125.AnimState:SetMultColour(0,0,0,1);v125:AddTag("fx");v125:AddTag("NOCLICK");v125.entity:SetPristine();if  not TheWorld.ismastersim then return v125;end v125.persists=false;return v125;end return Prefab("shadow_wixie",v12,v0,v1),Prefab("shadow_wixie_helper",v13,v0,v1),Prefab("shadow_wixie_cloneball",v16,v0,v1),Prefab("wixie_shadow_clone",v21,v0,v1),Prefab("wixie_shadow_ring",v24,v0,v1),Prefab("wixie_shadow_shield",v27,v0,v1),Prefab("wixie_shadow_shot",v26,v0,v1);