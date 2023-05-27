local DataStoreService = game:GetService("DataStoreService")
local BatteryDS = DataStoreService:GetDataStore("BatteryDS")

local RemoteEvent = Instance.new("RemoteEvent")
RemoteEvent.Name = "BatteryChanged"
RemoteEvent.Parent = game.ReplicatedStorage

local debounceTable = {}
local changeQueue = {}
local batchSize = 10
local debounceTime = 5
local isProcessing = false

local function updateBattery(player, change)
	local folder = player:FindFirstChild("Batteries_Folder")
	if folder then
		local battery = folder:FindFirstChild("Battery")
		if battery and battery:IsA("IntValue") then
			battery.Value = battery.Value + change
			debounceTable[player.UserId] = true

			table.insert(changeQueue, {Player = player, Value = battery.Value})

			if #changeQueue >= batchSize and not isProcessing then
				isProcessing = true

				local batch = {}
				for _, entry in ipairs(changeQueue) do
					table.insert(batch, {Key = entry.Player.UserId, Value = entry.Value})
				end

				changeQueue = {}

				coroutine.wrap(function()
					wait(1)
					local success, error = pcall(function()
						BatteryDS:SetAsync(unpack(batch))
					end)
					if not success then
						warn("Failed to save batched changes to DataStore:", error)
					end
					wait(debounceTime)
					debounceTable[player.UserId] = nil
					isProcessing = false
				end)()
			end
		end
	end
end

local function playerAdded(player)
	local folder = Instance.new("Folder")
	folder.Name = "Batteries_Folder"
	folder.Parent = player

	local battery = Instance.new("IntValue")
	battery.Name = "Battery"
	battery.Value = BatteryDS:GetAsync(player.UserId) or 100
	battery.Parent = folder

	battery.Changed:Connect(function()
		if not debounceTable[player.UserId] then
			debounceTable[player.UserId] = true

			table.insert(changeQueue, {Player = player, Value = battery.Value})

			if #changeQueue >= batchSize and not isProcessing then
				isProcessing = true

				local batch = {}
				for _, entry in ipairs(changeQueue) do
					table.insert(batch, {Key = entry.Player.UserId, Value = entry.Value})
				end

				changeQueue = {}

				coroutine.wrap(function()
					wait(1)
					local success, error = pcall(function()
						BatteryDS:SetAsync(unpack(batch))
					end)
					if not success then
						warn("Failed to save batched changes to DataStore:", error)
					end
					wait(debounceTime)
					debounceTable[player.UserId] = nil
					isProcessing = false
				end)()
			end
		end
	end)
end

local function playerRemoving(player)
	local folder = player:FindFirstChild("Batteries_Folder")
	if folder then
		local battery = folder:FindFirstChild("Battery")
		if battery and battery:IsA("IntValue") then
			BatteryDS:SetAsync(player.UserId, battery.Value)
		end
	end
end

game.Players.PlayerAdded:Connect(playerAdded)
game.Players.PlayerRemoving:Connect(playerRemoving)

RemoteEvent.OnServerEvent:Connect(updateBattery)

