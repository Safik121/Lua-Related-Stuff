local DataStoreModule = require(game.ServerStorage.SuphisDataStore)

local keys = {"Wood", "Metal", "Glass", "Titanium", "Fabric" } 

local function StateChanged(state, dataStore)
	if state ~= true then return end
	for index, name in pairs(keys) do
		dataStore.HiddenStats[name].Value = dataStore.Value[name]
	end
end

game.Players.PlayerAdded:Connect(function(player)
	local hiddenStats = Instance.new("Folder") 
	hiddenStats.Name = "HiddenStats"
	hiddenStats.Parent = player

	for index, name in pairs(keys) do
		local hiddenValue = Instance.new("IntValue")
		hiddenValue.Name = name
		hiddenValue.Parent = hiddenStats
	end

	local dataStore = DataStoreModule.new("Player", player.UserId)
	dataStore.HiddenStats = hiddenStats
	dataStore.StateChanged:Connect(StateChanged)
end)

