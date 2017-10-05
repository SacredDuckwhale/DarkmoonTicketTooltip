  -- ----------------------------------------------------------------------------------------------------------------------
    -- -- This program is free software: you can redistribute it and/or modify
    -- -- it under the terms of the GNU General Public License as published by
    -- -- the Free Software Foundation, either version 3 of the License, or
    -- -- (at your option) any later version.
	
    -- -- This program is distributed in the hope that it will be useful,
    -- -- but WITHOUT ANY WARRANTY; without even the implied warranty of
    -- -- MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    -- -- GNU General Public License for more details.

    -- -- You should have received a copy of the GNU General Public License
    -- -- along with this program.  If not, see <http://www.gnu.org/licenses/>.
-- ----------------------------------------------------------------------------------------------------------------------


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
				
					-- Check if quest was already completed
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
						
						self:AddLine(format("Price per ticket: %s%s%s", format(tex, g, iconGold), format(tex, s, iconSilver), format(tex, c, iconCopper)))
					end
					
			end
	end
	
	-- Summary of quests

end);