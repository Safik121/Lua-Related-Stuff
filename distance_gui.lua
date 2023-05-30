local btn = script.Parent
local plr = game.Players.LocalPlayer
local testParts = game.Workspace.Folder:GetChildren()

local distanceLabel = btn:WaitForChild("DistanceLabel")

local humanoid = plr.Character:WaitForChild("Humanoid")

local function updateDistanceLabel()
	local minDistance = math.huge
	local nearestPart = nil

	for _, part in ipairs(testParts) do
		local distance = (plr.Character.HumanoidRootPart.Position - part.Position).Magnitude
		if distance < minDistance then
			minDistance = distance
			nearestPart = part
		end
	end

	if nearestPart then
		local roundedDistance = math.floor(minDistance)
		distanceLabel.Text = "Distance: " .. tostring(math.floor((roundedDistance)/4)) .. "m" 
	else
		distanceLabel.Text = "Distance: N/A"
	end
end

updateDistanceLabel()

humanoid.Died:Connect(function()
	distanceLabel.Text = "Distance: N/A"
end)

game:GetService("RunService").Heartbeat:Connect(updateDistanceLabel)
