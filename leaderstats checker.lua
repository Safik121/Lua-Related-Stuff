local play = game.Player.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local rootpart = character:WaitForChild("RootPart")
local leaderboard = character:WaitForChild("leaderstats")
local bool = true
while bool do
  print(leaderboard)
  wait(1)
end
