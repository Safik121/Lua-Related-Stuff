local DataStoreModule = require(game.ServerStorage.SuphisDataStore)

local template = {
	Coins = 0,
	Gems = 0,
	Wood = 0,
	Metal = 0,
	Glass = 0,
	Titanium = 0,
	Fabric = 0,
}

local function StateChanged(state, dataStore)
	while dataStore.State == false do
		if dataStore:Open(template) ~= "Success" then
			task.wait(6)
		end
	end
end

game.Players.PlayerAdded:Connect(function(player)
	local dataStore = DataStoreModule.new("Player", player.UserId)
	dataStore.StateChanged:Connect(StateChanged)
	StateChanged(dataStore.State, dataStore)
end)

game.Players.PlayerRemoving:Connect(function(player)
	local dataStore = DataStoreModule.find("Player", player.UserId)
	if dataStore ~= nil then
		dataStore:Destroy()
	end
end)

local function GetPlayerMaterialData(player)
	local dataStore = DataStoreModule.find("Player", player.UserId)
	if dataStore ~= nil and dataStore.State == true then
		local materialData = {
			Wood = dataStore.Value.Wood,
			Metal = dataStore.Value.Metal,
			Glass = dataStore.Value.Glass,
			Titanium = dataStore.Value.Titanium,
			Fabric = dataStore.Value.Fabric,
		}
		return materialData
	end
end

local function UpdatePlayerMaterialData(player, materialData)
	player.HiddenStats.Wood.Value = materialData.Wood
	player.HiddenStats.Metal.Value = materialData.Metal
	player.HiddenStats.Glass.Value = materialData.Glass
	player.HiddenStats.Titanium.Value = materialData.Titanium
	player.HiddenStats.Fabric.Value = materialData.Fabric

	local dataStore = DataStoreModule.find("Player", player.UserId)
	if dataStore ~= nil and dataStore.State == true then
		dataStore.Value.Wood = materialData.Wood
		dataStore.Value.Metal = materialData.Metal
		dataStore.Value.Glass = materialData.Glass
		dataStore.Value.Titanium = materialData.Titanium
		dataStore.Value.Fabric = materialData.Fabric
	end
end

local function HasMaterials(player, recipe)
	local playerMaterials = GetPlayerMaterialData(player)
	for material, amountNeeded in pairs(recipe) do
		if playerMaterials[material] < amountNeeded then
			return false
		end
	end
	return true
end

local function GetRecipe(itemName)
	if itemName == "Sword" then
		return {
			Wood = 1,
			Metal = 0
		}
	elseif itemName == "Shield" then
		return {
			Wood = 2,
			Metal = 0
		}
	end
	
	return nil
end

local function ConsumeMaterials(player, recipe)
	local playerMaterials = GetPlayerMaterialData(player)
	for material, amountNeeded in pairs(recipe) do
		playerMaterials[material] = playerMaterials[material] - amountNeeded
	end
	UpdatePlayerMaterialData(player, playerMaterials)
end

local function CraftItem(player, itemName)
	local recipe = GetRecipe(itemName)

	if recipe and HasMaterials(player, recipe) then
		ConsumeMaterials(player, recipe)

		local tool = Instance.new("Tool")
		tool.Name = itemName
		tool.Parent = player.Backpack

		print(player.Name .. " crafted " .. itemName)
	else
		print(player.Name .. " does not have enough materials to craft " .. itemName)
	end
end

local remote = Instance.new("RemoteEvent")
remote.Name = "CraftingRemote"
remote.Parent = game.ReplicatedStorage

remote.OnServerEvent:Connect(function(player, itemName)
	CraftItem(player, itemName)
end)
