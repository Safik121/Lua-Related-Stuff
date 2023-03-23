local player = game.Player.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local rootpart = character:WaitForChild("RootPart")
local leaderboard = character:WaitForChild("leaderstats")
local cash = leaderboard.Cash
local bool = true
while bool do
  print(cash.Value)
  wait(1)
end
