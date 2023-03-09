local env = env
GLOBAL.setfenv(1, GLOBAL)

env.AddComponentPostInit("container", function(self)
    function self:DropOneItemWithTag(tag, drop_pos)
		local containers = {}

		for i = 1, self.numslots do
			local item = self.slots[i]
			if item ~= nil then
				if item:HasTag(tag) then
					self:DropItemBySlot(i, drop_pos)
					break
				elseif item.components.container ~= nil then
					table.insert(containers, item)
				end
			end
		end

		for i, v in ipairs(containers) do
			v.components.container:DropOneItemWithTag(tag, drop_pos)
		end
	end
end)
