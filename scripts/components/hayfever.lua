local function onnextsneeze(self, sneezetime)
    self.inst.replica.hayfever:SetNextSneezeTime(sneezetime)
end

local Hayfever = Class(function(self, inst)
    self.inst = inst
    self.enabled = false
    self.sneezed = false
    self.nextsneeze  = self:GetNextSneezTime()    
end,
nil,
{
    nextsneeze = onnextsneeze,
})

function Hayfever:DoDelta(amount)
    if self.nextsneeze >= amount then         
        self.nextsneeze = self.nextsneeze + amount
    else       
        self.nextsneeze = self.nextsneeze - 1
    end
end

function Hayfever:GetNextSneezTime()
	if self.inst:HasTag("plantkin") then
		return math.random(80,120)
	elseif self.inst:HasTag("allergictobees") then
		return math.random(45,65)
	end
    return math.random(60,80)
end

function Hayfever:SetNextSneezeTime(newtime)
    if self.nextsneeze < newtime then         
        self.nextsneeze = newtime
    end
end

function Hayfever:CanSneeze()
    local can = true
--[[
    local x, y, z = ThePlayer.Transform:GetWorldPosition()
    local ents = TheSim:FindEntities(x, y, z, 30, {"prevents_hayfever"})
    local suppressorNearby = (#ents > 0)
--]]
    if self.inst:HasTag("playerghost") or self.inst:HasTag("has_gasmask") or self.inst:HasTag("has_hayfeverhat") or self.inst:HasTag("minifansuppressor") or self.inst:HasTag("wereplayer") or self.inst.sg:HasStateTag("sleeping") then --or not TheWorld:HasTag("hayfever") or not TheWorld.net:HasTag("hayfever") then -- or suppressorNearby
        can = false
    end
	
    return can
end

function Hayfever:CanSneezeQueen()
    local cancan = true
	
	local queenkilled = TheWorld.components.hayfever_tracker:CheckQueen() or nil
	if queenkilled or self.inst:HasTag("plantkin") or self.inst:HasTag("hayfever_immune") then
		cancan = false
	end
	
	--print(queenkilled)
	
    return cancan
end

function Hayfever:OnUpdate(dt)
	--print(self.nextsneeze)
    if self:CanSneeze() and self:CanSneezeQueen() then
        if self.nextsneeze <= 0 then
            if not self.inst.wantstosneeze then
                -- large chance to sneeze twice in a row
                if self.sneezed or math.random() > 0.7 then
                    self.sneezed = false
                    self.nextsneeze = self:GetNextSneezTime()
                else
                    self.sneezed = true
                    self.nextsneeze = 1
                end

                self.inst.wantstosneeze = true
                self.inst:PushEvent("sneeze")               
            end
        else
            self.nextsneeze = self.nextsneeze -dt
        end        
    elseif self:CanSneeze() and not self:CanSneezeQueen() then
        if self.nextsneeze <= 0 then
			if not self.inst.wantstosneeze then
				-- large chance to sneeze twice in a row
				if self.sneezed or math.random() > 0.7 then
					 self.sneezed = false
					self.nextsneeze = self:GetNextSneezTime()
				else
					self.sneezed = true
					self.nextsneeze = 1
				end

				self.inst.wantstosneeze = true
                self.inst:PushEvent("sneeze")
			end
		elseif self.nextsneeze < 10 then
            self.nextsneeze = self.nextsneeze + (dt*0.9)
		elseif self.nextsneeze > 11 then
            self.nextsneeze = self.nextsneeze -dt
        end
	else
        if self.nextsneeze < 10 then
            self.nextsneeze = self.nextsneeze + (dt*0.9)
		elseif self.nextsneeze > 11 then
            self.nextsneeze = self.nextsneeze -dt
        end
    end
    self.inst:PushEvent("updatepollen", {sneezetime = self.nextsneeze})  
end

function Hayfever:OnSave()
    local data = {}
    local references = {}

    data.enabled = self.enabled
    data.sneezed = self.sneezed
    data.nextsneeze = self.nextsneeze

    return data, references
end

function Hayfever:OnLoad(data, newents)
   if data then
        if data.enabled then
            self.enabled = data.enabled
        end
        if data.sneezed then
            self.sneezed = data.sneezed
        end
        if data.nextsneeze then
            self.nextsneeze = data.nextsneeze
        end    
   end 
   if self.enabled then
        self:Enable()
   end
end

function Hayfever:Enable()
    if not self.hayfeverimune then

        --if GetWorld().getworldgenoptions(GetWorld())["hayfever"] and GetWorld().getworldgenoptions(GetWorld())["hayfever"] == "never" then
			--return
        --end

        if not self.enabled and not self.inst.components.health:IsDead() and self.inst.prefab ~= "wes" then --and (TheWorld:HasTag("hayfever") or TheWorld.net:HasTag("hayfever"))then
            --print("HAYVEVER STARTED")    
            self.inst.components.talker:Say(GetString(self.inst.prefab, "ANNOUNCE_HAYFEVER"))
        end
        self.enabled = true

        self.inst:StartUpdatingComponent(self)
		return
    end
end

function Hayfever:Disable()
    if self.enabled and not self.inst.components.health:IsDead() and self.inst.prefab ~= "wes" then --and (TheWorld:HasTag("hayfever") or TheWorld.net:HasTag("hayfever"))then	
        self.inst:PushEvent("updatepollen", {sneezetime = nil}) 
        self.inst.components.talker:Say(GetString(self.inst.prefab, "ANNOUNCE_HAYFEVER_OFF"))    
    end
    self.enabled = false
    self.inst:StopUpdatingComponent(self) 
end

function Hayfever:GetDebugString()
    return "nextsneeze" ..  self.nextsneeze
end

function Hayfever:DoSneezeEffects()
    
    self.inst.components.sanity:DoDelta(-TUNING.SANITY_SUPERTINY*3)
	
	if not TheWorld.state.isspring and self.inst.components.hayfever ~= nil then
		self.inst.components.hayfever:Disable()
	end
--[[
    -- cause player to drop stuff here.
    local itemstodrop = 0 
    if math.random() < 0.6 then
        itemstodrop = itemstodrop +1
    end
    if math.random() < 0.1 then
        itemstodrop = itemstodrop +1
    end    

    if itemstodrop > 0 then
        local findItems = self.inst.components.inventory:FindItems(
                        function(item)
                            return not item:HasTag("nosteal")
                        end) 

        for i=1,itemstodrop do            
            for i=1, itemstodrop do
                if #findItems > 0 then
                    local itemnum = math.random(1,#findItems)
                    local item = findItems[itemnum]

                    table.remove(findItems,itemnum)

                    if item then
                        local direction = Vector3(math.random(1)-2,0,math.random(1)-2)        
                        --print("DROPPING",item.prefab)                
                        self.inst.components.inventory:DropItem(item, false, direction:GetNormalized())
                    end                   

                end                      
            end
        end
    end]]
end 

return Hayfever
