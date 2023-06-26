local require = GLOBAL.require

AddClassPostConstruct("screens/consolescreen", function(self, inst)
	-- ADD NEW/CHANGED COMMANDS TO THIS LIST
	-- Just write what you want them to autocomplete to, minus the 'c_um_' part.
	-- Also, please keep it alphabetical so we can quickly check our commands.
	local prediction_command = {
		"findents()",
		"forcetornado()",
		"heatwave()",
		"ratcheck()",
		"regenerateoceanbiomes()",
		"rne()",
		"setadrenaline(",
		"settile(",
		"snowstorm()",
		"spawnsunkenchest(",
		"umss(",
		"vetcurse()",
		"vetcurseitems()",
	}
	
	self.console_edit:AddWordPredictionDictionary({words = prediction_command, delim = "c_um_", num_chars = 0})
end)
