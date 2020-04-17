local addon = ...
local main = CreateFrame("Frame")
local items = {}
local minItemNumber = 19698
local maxItemNumber = 19715

function getItemInfo(itemID)
	if (itemID > maxItemNumber) then
		return
	end

	local item = Item:CreateFromItemID(itemID)
	item:ContinueOnItemLoad(
		function()
			print(item:GetItemName())
			items[item:GetItemName()] = true
			getItemInfo(itemID + 1)
		end
	)
end

function main:ADDON_LOADED(name)
	if (name == "ZGAutoRoll") then
		print("ZG AutoRoll enabled!")
		getItemInfo(minItemNumber)
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
