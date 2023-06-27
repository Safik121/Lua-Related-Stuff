local ReplicatedStorage = game:GetService("ReplicatedStorage")
local remote = ReplicatedStorage:WaitForChild("CraftingRemote")

local craftButton = script.Parent
local valueFolder = game.ReplicatedStorage:WaitForChild("Values")
local EmptyValue = valueFolder:WaitForChild("EmptyValue")
local toCkraft = EmptyValue.Value


EmptyValue.Changed:Connect(function(newValue)
	toCkraft = newValue
end)

craftButton.MouseButton1Click:Connect(function()
	local itemToCraft = toCkraft
	remote:FireServer(itemToCraft)
end)
