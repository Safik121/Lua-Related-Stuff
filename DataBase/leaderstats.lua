local DataStoreModule = require(game.ServerStorage.SuphisDataStore)

local keys = {"Coins", "Gems"}

local function StateChanged(state, dataStore)
	if state ~= true then return end
	for index, name in keys do
		dataStore.Leaderstats[name].Value = dataStore.Value[name]
	end
end

game.Players.PlayerAdded:Connect(function(player)
	local leaderstats = Instance.new("Folder")
	leaderstats.Name = "leaderstats"
	leaderstats.Parent = player
	
	for index, name in keys do
		local intValue = Instance.new("IntValue")
		intValue.Name = name
		intValue.Parent = leaderstats
	end
	
	local dataStore = DataStoreModule.new("Player", player.UserId)
	dataStore.Leaderstats = leaderstats
	dataStore.StateChanged:Connect(StateChanged)
end)
