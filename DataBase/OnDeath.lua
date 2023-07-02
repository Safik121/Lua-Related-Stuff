local npc = script.Parent
local humanoid = npc:WaitForChild("Humanoid")
local DataStoreModule = require(game.ServerStorage.SuphisDataStore)


npc.PrimaryPart:SetNetworkOwner(nil)

humanoid.Died:Connect(function()
	local killer = humanoid:FindFirstChild("creator")
	
	if killer then
		local player = killer.Value
		if player == nil then return end
		local dataStore = DataStoreModule.find("Player", player.UserId)
		if dataStore == nil then return end
		if dataStore.State ~= true then return end
		dataStore.Value.Coins += 1
		dataStore.Leaderstats.Coins.Value = dataStore.Value.Coins
	end
end)
