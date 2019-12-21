--[[
What is this for?
	This is a way to access local variables in files. You should always, always, always, try to find
	another way to do this first. However, there are some cases where there's really no other way to do it.
	For example: you want to remove an event listener, but there's no way to access the local function.

How do I use this?
	The basic idea is that you find a starting function first (usually a prefab's constructor), and then
	you have to trace the variables downward through the stack to get at the particular variable you want.
	First, load it into your modmain (assuming you put it in tools/upvaluehacker.lua):
	
	local UpvalueHacker = GLOBAL.require("tools/upvaluehacker")
	
	There are two main things you can do with this:
		UpvalueHacker.GetUpvalue: get a reference to a local variable to use it
		UpvalueHacker.SetUpvalue: set the value of the local variable to change it

Usually you'll want to be making these changes from an AddPrefabPostInit("world", function(inst) end),
to make sure that all prefabs/mods have loaded first.
	
Example 1: A normal prefab
	Let's say you want to change the IsCrazyGuy function in prefabs/bunnyman.
	IsCrazyGuy is referenced in two other local functions, CalcSanityAura and LootSetupFunction
	Let's go with CalcSanityAura; this is referenced in the bunnyman constructor ("fn()")
	We can get a reference to the constructor from the Prefabs table,
	so first we define our own IsCrazyGuy, and then we can set it like this:
	
	UpvalueHacker.SetUpvalue(GLOBAL.Prefabs.bunnyman.fn, IsCrazyGuy, "CalcSanityAura", "IsCrazyGuy")
	
	So the first argument there is the function we start from. Then, we give it our own IsCrazyGuy.
	Then, we give it the series of functions we're following to finally get to the default IsCrazyGuy.
	From looking before, we found that it went Constructor -> CalcSanityAura -> IsCrazyGuy
	
Example 2: A player prefab, with a secondary reference
	Players are a little more complicated because if you look at their file, you might think that you
	can get at stuff there directly, but you can't, because you have to go through the function that
	MakePlayerCharacter generates in player_common. So, let's say we want to make WX-78 drop more gears.
	Gears get dropped by his ondeath function, which is referenced in his master_postinit. However, ondeath
	also references the local function applyupgrades, which we need as well if we just want to replace
	ondeath with a small change to dropgears. First, how do we get to master_postinit?
	We can go through GLOBAL.Prefabs.wx78.fn, which brings us to the fn defined in MakePlayerCharacter.
	From there, we can get at master_postinit, and then ondeath, and then applyupgrades. So first we grab it:
	
	local applyupgrades = UpvalueHacker.GetUpvalue(GLOBAL.Prefabs.wx78.fn, "master_postinit", "ondeath", "applyupgrades")
	
	Then, we can define our own ondeath, starting by copy-pasting theirs... maybe need to fix some GLOBAL references...
	And then, we can set the ondeath:
	
	UpvalueHacker.SetUpvalue(GLOBAL.Prefabs.wx78.fn, ondeath, "master_postinit", "ondeath")
	
Example 3: Local variables in components
	Let's say we want to change what birds spawn on what turf, like make the deciduous turf spawn
	the same birds as forest turf. Right now this is a local variable, BIRD_TYPES, in components/birdspawner.
	We can start by doing an AddClassPostConstruct("components/birdspawner", function(self) <code> end)
	Now that we have the class, we have to figure out where BIRD_TYPES is referenced.
	Looks like BIRD_TYPES is only referenced in the local function PickBird. Where's that referenced?
	PickBird is referenced in self:SpawnBird. This means that in our PostConstruct, we can find it at
	self.SpawnBird -> PickBird -> BIRD_TYPES. So we can now use GetUpvalue and make the change:
	
	local BIRD_TYPES = UpvalueHacker.GetUpvalue(self.SpawnBird, "PickBird", "BIRD_TYPES")
	BIRD_TYPES[GLOBAL.GROUND.DECIDUOUS] = BIRD_TYPES[GLOBAL.GROUND.FOREST]
	
	Because BIRD_TYPES is a table, we don't need to use SetUpvalue on it, because we got a reference to the
	actual table and can change it. If it were a string, number, or function, then we'd have to use
	SetUpvalue to replace it instead.
	
Good luck and happy upvalue hacking!
]]

UpvalueHacker = {}
local function GetUpvalueHelper(fn, name)
	local i = 1
	while debug.getupvalue(fn, i) and debug.getupvalue(fn, i) ~= name do
		i = i + 1
	end
	local name, value = debug.getupvalue(fn, i)
	return value, i
end

function UpvalueHacker.GetUpvalue(fn, ...)
	local prv, i, prv_var = nil, nil, "(the starting point)"
	for j,var in ipairs({...}) do
		assert(type(fn) == "function", "We were looking for "..var..", but the value before it, "
			..prv_var..", wasn't a function (it was a "..type(fn)
			.."). Here's the full chain: "..table.concat({"(the starting point)", ...}, ", "))
		prv = fn
		prv_var = var
		fn, i = GetUpvalueHelper(fn, var)
	end
	return fn, i, prv
end

function UpvalueHacker.SetUpvalue(start_fn, new_fn, ...)
	local _fn, _fn_i, scope_fn = UpvalueHacker.GetUpvalue(start_fn, ...)
	debug.setupvalue(scope_fn, _fn_i, new_fn)
end

return UpvalueHacker