local player = game:GetService("Players").LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local rootpart = character:WaitForChild("RootPart")
local leaderboard = character:WaitForChild("leaderstats")
local cash = leaderboard.Cash

cash.ValueChanged:Connect(function(newVal)
    print("Cash:", newVal)
end)
