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

local addonName, DTT = ...
if not DTT then return end

-- Localization table
local L = LibStub("AceLocale-3.0"):GetLocale("DarkmoonTicketTooltip", false)

-- Database of turnin items
local questItems = {
	[71715] = { ["quest"] = 29451, ["tickets"] = 15 }, -- A Treatise on Strategy
	[71638] = { ["quest"] = 29446, ["tickets"] = 10 }, -- Ornate Weapon
	[71637] = { ["quest"] = 29445, ["tickets"] = 10 }, -- Mysterious Grimoire
	[71636] = { ["quest"] = 29444, ["tickets"] = 10 }, -- Monstrous Egg
	[71635] = { ["quest"] = 29443, ["tickets"] = 10 }, -- Imbued Crystal
	[71716] = { ["quest"] = 29464, ["tickets"] = 10 }, -- Soothsayer's Runes
	[71952] = { ["quest"] = 29457, ["tickets"] = 5 }, -- Captured Insignia
	[71951] = { ["quest"] = 29456, ["tickets"] = 5 }, -- Banner of the Fallen
	[71953] = { ["quest"] = 29458, ["tickets"] = 5 }, -- Adventurer's Journal
};
	
	[105891] = { quest = 33354, tickets = 10 }, -- Moonfang's Pelt -> Den Mother's Demise (probably too expensive in almost all cases, but added for completion)
	[124669] = { quest = 38934, tickets = 100, numRequiredItems = 100 }, -- Darkmoon Daggermaw -> Silas' Secret Stash (one-time only)
}

-- Display tooltip information, but only on DMF quest items
GameTooltip:HookScript("OnTooltipSetItem", function(self)
	
	local _, itemLink = self:GetItem()
	if type(itemLink) == "string" then -- Is valid item string (i.e., not nil) -> Check if it's the right item
	
		local itemID = GetItemInfoInstant(itemLink)
		
			if questItems[itemID] then -- Is DMF turnin item -> Show tooltip info
			
				-- Check if quest was already completed 
				if IsQuestFlaggedCompleted(questItems[itemID]["quest"]) then -- Is completed - > Show text in green
					self:AddLine(L["Quest already completed!"], 0xFF/255, 0x1A/255, 0x1A/255)
				else -- Not yet completed -> Show text in red
					self:AddLine(L["Quest not yet completed!"], 0x1E/255, 0xFF/255, 0x00/255)
				end
			
				local numTickets = questItems[itemID]["tickets"]
				local numRequiredItems = questItems[itemID]["numRequiredItems"] or 1 -- Only 1 is required of the regular quest items
				self:AddLine(format(L["Quest awards %d %s"], numTickets, L["Darkmoon Prize Tickets"]))
					
					if IsAddOnLoaded("TradeSkillMaster_AuctionDB") then -- TSM AuctionDB is available as a price source -> Show price per ticket (using the currently lowest item price)
						
						-- Get price from TSM's database (via their API)
						local marketPrice = TSMAPI:GetItemValue(itemLink,"DBMinBuyout")
						local copperPerTicket = marketPrice / numTickets * numRequiredItems
						
						-- Upvalues
						local math_floor = math.floor
						local format = string.format
						
						-- Extract values to display in the standard format of XgYYsZZc
						local g = copperPerTicket / 10000
						copperPerTicket = copperPerTicket - math_floor(g * 10000 + 0.5)
						local s = (copperPerTicket / 1000)
						copperPerTicket = copperPerTicket - math_floor (s * 1000 + 0.5)
						local c = math_floor(copperPerTicket + 0.5)
						
						-- Display with the actual icons, though - as that looks much nicer
						local iconGold = "Interface\\MONEYFRAME\\UI-GoldIcon"
						local iconSilver = "Interface\\MONEYFRAME\\UI-SilverIcon"
						local iconCopper = "Interface\\MONEYFRAME\\UI-CopperIcon"
						local tex = "%.2d|T%s:16|t" -- Using the  |T ... |t UI Escape sequence to insert textures into the tooltip's text	
						
						-- Finally, add everything to the tooltip
						self:AddLine(format(L["Price per ticket: %s%s%s"], format(tex, g, iconGold), format(tex, s, iconSilver), format(tex, c, iconCopper)))
						
					end
			end
	end
end)