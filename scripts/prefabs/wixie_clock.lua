--[[
 .____                  ________ ___.    _____                           __                
 |    |    __ _______   \_____  \\_ |___/ ____\_ __  ______ ____ _____ _/  |_  ___________ 
 |    |   |  |  \__  \   /   |   \| __ \   __\  |  \/  ___// ___\\__  \\   __\/  _ \_  __ \
 |    |___|  |  // __ \_/    |    \ \_\ \  | |  |  /\___ \\  \___ / __ \|  | (  <_> )  | \/
 |_______ \____/(____  /\_______  /___  /__| |____//____  >\___  >____  /__|  \____/|__|   
         \/          \/         \/    \/                \/     \/     \/                   
          \_Welcome to LuaObfuscator.com   (Alpha 0.2.5) ~  Much Love, Ferib 

]]--

local v0={Asset("ANIM","anim/wixie_clock.zip"),Asset("ANIM","anim/wixie_clock_hands.zip"),Asset("ANIM","anim/wixie_dangley.zip"),Asset("ANIM","anim/wooden_queen_piece.zip")};local v1={};local function v2(v3)local v29,v30,v31=v3.Transform:GetWorldPosition();v3.second=SpawnPrefab("wixie_clockhand_second");v3.minute=SpawnPrefab("wixie_clockhand_minute");v3.hour=SpawnPrefab("wixie_clockhand_hour");v3.seconddangle=SpawnPrefab("wixie_clockdangley1");v3.seconddangle.host=v3;v3.minutedangle=SpawnPrefab("wixie_clockdangley2");v3.minutedangle.host=v3;v3.hourdangle=SpawnPrefab("wixie_clockdangley3");v3.hourdangle.host=v3;v3.front=SpawnPrefab("wixie_clockfront");v3.front.Transform:SetPosition(v29,v30-0.1 ,v31);v3.second.entity:SetParent(v3.entity);v3.second.Transform:SetPosition(0,0,0);v3.entity:AddFollower();v3.minute.entity:SetParent(v3.entity);v3.minute.Transform:SetPosition(0,0,0);v3.entity:AddFollower();v3.hour.entity:SetParent(v3.entity);v3.hour.Transform:SetPosition(0,0,0);v3.entity:AddFollower();v3.seconddangle.Transform:SetPosition(v29,v30-0.06 ,v31);v3.seconddangle.myhand=v3.second;v3.minutedangle.Transform:SetPosition(v29,v30-0.06 ,v31);v3.minutedangle.myhand=v3.minute;v3.hourdangle.Transform:SetPosition(v29,v30-0.06 ,v31);v3.hourdangle.myhand=v3.hour;end local function v4(v3,v5)if ((v3.hourdangle~=nil) and (v3.seconddangle~=nil) and (v3.minutedangle~=nil)) then local v85,v86,v87=v3.Transform:GetWorldPosition();local v88=TheSim:FindEntities(v85,v86,v87,30,{"player"});if (v3.final_code_ready and (v3.hourdangle.count==12) and (v3.minutedangle.count==2) and (v3.seconddangle.count==7)) then if ((v88~=nil) and ( #v88== #AllPlayers)) then v3.canbeused=false;print("ding dong the witch is dead");for v103=1,8 do v3:DoTaskInTime((v103 * 3) -3 ,function()local v104=16 -((v103-1) * 2) ;local v105=(v103-1) * 2 ;local v106=TheSim:FindFirstEntityWithTag("wixie_wardrobe");if (v103==8) then v106:PushEvent("spawn_shadow_wix");TheWorld:PushEvent("ms_setclocksegs",{day=0,dusk=0,night=16});else v106:PushEvent("wixie_wardrobe_shutter");TheWorld:PushEvent("ms_setclocksegs",{day=0,dusk=v104,night=v105});end local v107=9 -v103 ;v3.SoundEmitter:PlaySound("UCSounds/wixie_clock/"   .. v107 );end);end v3.final_code_ready=false;v3.components.timer:StartTimer("reset_use",9600);TheNet:SystemMessage("The time has come...");else TheNet:SystemMessage("All must be gathered before you can proceed...");end elseif ((v3.hourdangle.count==10) and (v3.minutedangle.count==9) and (v3.seconddangle.count==1)) then print("SpawnKey");local v101=SpawnPrefab("wixie_piano_card");v101.Transform:SetPosition(v3.Transform:GetWorldPosition());v101.name="Tempus sit amet";Launch2(v101,v3,2,0,1,0.5);elseif ((v3.hourdangle.count==1) and (v3.minutedangle.count==5) and (v3.seconddangle.count==8)) then local v108=SpawnPrefab("wooden_queen_piece");v108.Transform:SetPosition(v3.Transform:GetWorldPosition());v108:AddTag("puzzlespawn");local v109=((v5~=nil) and v5) or v3 ;Launch2(v108,v109,2,0,1,0.5);else if ((v5~=nil) and (v5.components.sanity~=nil)) then v5.components.sanity:DoDelta( -10);end v3.SoundEmitter:PlaySound("dontstarve/common/chesspile_repair");end end v3.SoundEmitter:KillSound("ticking_clock");end local function v6(v3)if (TheWorld.state.isday and v3.canbeused) then v3.components.activatable.inactive=true;v3.SoundEmitter:PlaySound("UCSounds/wixie_clock/ticking_clock","ticking_clock");v3:DoTaskInTime(13,function(v90)v90.components.activatable.inactive=false;v90.SoundEmitter:KillSound("ticking_clock");end);end end local function v7(v3,v8)if (v8.name=="reset_use") then v3.canbeused=true;end end local function v9(v3,v8)if (v3.canbeused~=nil) then v8.canbeused=v3.canbeused;end end local function v10(v3,v8)if ((v8~=nil) and (v8.canbeused~=nil)) then v3.canbeused=v8.canbeused;end end local function v11(v12)local v45=CreateEntity();v45.entity:AddTransform();v45.entity:AddAnimState();v45.entity:AddSoundEmitter();v45.entity:AddDynamicShadow();v45.entity:AddNetwork();v45.AnimState:SetBuild("wixie_clock");v45.AnimState:SetBank("wixie_clock");v45.AnimState:PlayAnimation("idle",true);v45:AddTag("wixie_clock");v45.entity:SetPristine();if  not TheWorld.ismastersim then return v45;end v45.repaired=false;v45.canbeused=true;v45.final_code_ready=false;v45:AddComponent("inspectable");v45:DoTaskInTime(1,v2);v45:AddComponent("activatable");v45.components.activatable.OnActivate=v4;v45.components.activatable.inactive=false;v45.components.activatable.quickaction=true;v45:AddComponent("timer");v45:ListenForEvent("timerdone",v7);v45.OnSave=v9;v45.OnLoad=v10;v45.MakeUsable=v6;v45:WatchWorldState("isday",v6);return v45;end local function v13(v14,v15)local v55=CreateEntity();v55.entity:AddTransform();v55.entity:AddAnimState();v55.entity:AddNetwork();v55.AnimState:SetBuild("wixie_clock_hands");v55.AnimState:SetBank("wixie_clock_hands");v55.AnimState:PlayAnimation(v14   .. v15 ,false);v55:AddTag("NOCLICK");v55.entity:SetPristine();if  not TheWorld.ismastersim then return v55;end v55.handtype=v14;v55.persists=false;return v55;end local function v16()local v58=v13("min",12);if  not TheWorld.ismastersim then return v58;end return v58;end local function v17()local v59=v13("sec",4);if  not TheWorld.ismastersim then return v59;end return v59;end local function v18()local v60=v13("hour",8);if  not TheWorld.ismastersim then return v60;end return v60;end local function v19(v3)if (v3.count>=12) then v3.count=1;else v3.count=v3.count + 1 ;end if (v3.myhand~=nil) then v3.myhand.AnimState:PlayAnimation(v3.myhand.handtype   .. v3.count ,false);v3.SoundEmitter:PlaySound("dontstarve/creatures/together/deer/chain");end v3.AnimState:SetPercent(v3.dangletype,(1/12) * v3.count );v3.components.activatable.inactive=true;end local function v20(v21,v15)local v62=CreateEntity();v62.entity:AddTransform();v62.entity:AddAnimState();v62.entity:AddSoundEmitter();v62.entity:AddNetwork();v62.AnimState:SetBuild("wixie_dangley");v62.AnimState:SetBank("wixie_dangley");v62.AnimState:SetPercent(v21,(1/12) * v15 );v62.entity:SetPristine();if  not TheWorld.ismastersim then return v62;end v62.dangletype=v21;v62.myhand=nil;v62.count=v15;v62:AddComponent("activatable");v62.components.activatable.OnActivate=v19;v62.components.activatable.inactive=true;v62.components.activatable.quickaction=true;v62.persists=false;return v62;end local function v22()local v70=v20("dangley1",4);if  not TheWorld.ismastersim then return v70;end return v70;end local function v23()local v71=v20("dangley2",12);if  not TheWorld.ismastersim then return v71;end return v71;end local function v24()local v72=v20("dangley3",8);if  not TheWorld.ismastersim then return v72;end return v72;end local function v25()local v73=CreateEntity();v73.entity:AddTransform();v73.entity:AddAnimState();v73.entity:AddNetwork();v73.AnimState:SetBuild("wixie_clock");v73.AnimState:SetBank("wixie_clock");v73.AnimState:PlayAnimation("back");v73:AddTag("NOCLICK");v73.entity:SetPristine();if  not TheWorld.ismastersim then return v73;end v73.persists=false;return v73;end local function v26(v3,v27)return (v27:HasTag("troublemaker") and 'Oh, it\'s one of my moms carvings!\n\"VII\" is engraved on the back.') or '\"VII\" is engraved on the back.' ;end local function v28()local v75=CreateEntity();v75.entity:AddTransform();v75.entity:AddAnimState();v75.entity:AddNetwork();MakeInventoryPhysics(v75);v75.AnimState:SetBank("wooden_queen_piece");v75.AnimState:SetBuild("wooden_queen_piece");v75.AnimState:PlayAnimation("idle");MakeInventoryFloatable(v75,"med",0.1,0.75);v75.entity:SetPristine();if  not TheWorld.ismastersim then return v75;end v75:AddComponent("edible");v75.components.edible.foodtype=FOODTYPE.WOOD;v75.components.edible.healthvalue=0;v75.components.edible.hungervalue=0;v75:AddComponent("fuel");v75.components.fuel.fuelvalue=TUNING.MED_FUEL;MakeSmallBurnable(v75,TUNING.MED_BURNTIME);MakeSmallPropagator(v75);MakeHauntableLaunchAndIgnite(v75);v75:AddComponent("inspectable");v75.components.inspectable.getspecialdescription=v26;v75:AddComponent("inventoryitem");v75.components.inventoryitem.atlasname="images/inventoryimages/wooden_queen_piece.xml";v75:DoTaskInTime(0,function()if  not v75:HasTag("puzzlespawn") then v75:Remove();end end);v75.persists=false;return v75;end return Prefab("wixie_clock",v11,v0,v1),Prefab("wixie_clockhand_minute",v16,v0,v1),Prefab("wixie_clockhand_second",v17,v0,v1),Prefab("wixie_clockhand_hour",v18,v0,v1),Prefab("wixie_clockdangley1",v22,v0,v1),Prefab("wixie_clockdangley2",v23,v0,v1),Prefab("wixie_clockdangley3",v24,v0,v1),Prefab("wixie_clockfront",v25,v0,v1),Prefab("wooden_queen_piece",v28,v0,v1);