--[[
	1.0 Displays number of tickets awarded for each item's respective quest

	
	Related:
	https://mods.curse.com/addons/wow/muffin-darkmoon-helper
	https://mods.curse.com/addons/wow/darkmoon_tracker
	https://mods.curse.com/addons/wow/darkmoon-professional
	https://mods.curse.com/addons/wow/dmfquest
	
]]--

-- TODO: Upvalues
-- TODO: Moonfang's Pelt, Daggermaw Map (one-time, but still...)
-- Frame to compare all items
-- Localisation of items
-- Slash command to show? Or hide/show if world event is active? X button to close/another to close permanently for the char (until the fare rolls around again)
-- Compare transmog / petcs to see if it is actually worth it
-- different price sources, manual prices?
-- set manual threshold (or based on pet price etc), then show which items will be worth buying (orange, yellow, green, red text colour)

-- TODO: Find appropriate colour codes
local COLOUR_RED, COLOUR_GREEN = "FF1A1A", GREEN_FONT_COLOR_CODE;

local questItems = {
	[71715] = { ["quest"] = 29451, ["tickets"] = 15 }, -- A Treatise on Strategy
	[71638] = { ["quest"] = 29446, ["tickets"] = 10 }, -- Ornate Weapon
	[71637] = { ["quest"] = 29445, ["tickets"] = 10 }, -- Mysterious Grimoire
	[71636] = { ["quest"] = 29444, ["tickets"] = 10 }, -- Monstrous Egg
	[71635] = { ["quest"] = 29443, ["tickets"] = 10 }, -- Imbued Crystal
	[71716] = { ["quest"] = 29464, ["tickets"] = 10 }, -- Soothsayer's Runes
	[71952] = { ["quest"] = 29457, ["tickets"] = 5 }, -- Captured Insignia
	[71951] = { ["quest"] = 29456, ["tickets"] = 5 }, -- Banner of the Fallen
	[71953] = { ["quest"] = 29458, ["tickets"] = 5 }, --Adventurer's Journal
};

-- Display tooltip information, but only on DMF quest items
GameTooltip:HookScript("OnTooltipSetItem", function(self)
	
	local _, itemLink = self:GetItem();
	if type(itemLink) == "string" then
	
		local itemID = GetItemInfoInstant(itemLink);
		
			if questItems[itemID] then
			
				local numTickets = questItems[itemID]["tickets"]
				self:AddLine("Quest awards " .. numTickets .. " Darkmoon Prize Tickets");
				
					-- Check if quest was already completed TODO: this faire (calendar)
					if IsQuestFlaggedCompleted(questItems[itemID]["quest"]) then
						self:AddLine("Quest already completed!", 0xFF/255, 0x1A/255, 0x1A/255);
					else
						self:AddLine("Quest not completed yet!", 0x1E/255, 0xFF/255, 0x00/255);
					end
					
					if IsAddOnLoaded("TradeSkillMaster_AuctionDB") then

						local marketPrice = TSMAPI:GetItemValue(itemLink,"DBMinBuyout");
						local copperPerTicket = marketPrice / numTickets
						
						local math_floor = math.floor
						local format = string.format
						
						local g = copperPerTicket / 10000
						copperPerTicket = copperPerTicket - math_floor(g * 10000 + 0.5)
						local s = (copperPerTicket / 1000)
						copperPerTicket = copperPerTicket - math_floor (s * 1000 + 0.5)
						local c = math_floor(copperPerTicket + 0.5)
						
						
						local iconGold = "Interface\\MONEYFRAME\\UI-GoldIcon"
						local iconSilver = "Interface\\MONEYFRAME\\UI-SilverIcon"
						local iconCopper = "Interface\\MONEYFRAME\\UI-CopperIcon"
						local tex = "%.2d|T%s:16|t"						
					--	self:AddLine("DBMarket: " .. marketPrice .. " " .. copperPerTicket .. " " .. g .. "g" .. s .. "s" .. c .. "c")
					--	self:AddLine(format("Price per ticket: %dg%.2ds%.2dc", g, s, c))
						self:AddLine(format("Price per ticket: %s%s%s", format(tex, g, iconGold), format(tex, s, iconSilver), format(tex, c, iconCopper)))
					end
					
			end
		
		

		
		
	end
	
	-- Summary of quests

end);