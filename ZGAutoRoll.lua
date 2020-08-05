local addon = ...
local main = CreateFrame("Frame")
local items = {}
local minZGItemNumber = 19698
local maxZGItemNumber = 19715
local minAQItemNumber = 20858
local maxAQItemNumber = 20865

function getItemInfo(itemID, maxItemNumber)
	if (itemID > maxItemNumber) then
		return
	end

	local item = Item:CreateFromItemID(itemID)
	item:ContinueOnItemLoad(
		function()
			items[item:GetItemName()] = true
			getItemInfo(itemID + 1, maxItemNumber)
		end
	)
end

function main:ADDON_LOADED(name)
	if (name == "ZGAutoRoll") then
		getItemInfo(minZGItemNumber, maxZGItemNumber)
		getItemInfo(minAQItemNumber, maxAQItemNumber)
		main:RegisterEvent("START_LOOT_ROLL")
	end
end

function main:START_LOOT_ROLL(rollID)
	local _, name, _, _, _, canNeed = GetLootRollItemInfo(rollID)

	if (canNeed and items[name]) then
		RollOnLoot(rollID, 1)
	end
end

main:SetScript(
	"OnEvent",
	function(self, event, ...)
		if (main[event]) then
			main[event](self, ...)
		end
	end
)

main:RegisterEvent("ADDON_LOADED")
