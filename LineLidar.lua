local player = game.Players.LocalPlayer
local camera = workspace.CurrentCamera

local placingDot = false
local dotSize = Vector3.new(0.05, 0.05, 0.05)
local gridSize = 5
local gridSpacing = 0.3
local dotLayerDistance = 0.7 

local function CreateDot(position, color)
	local dot = Instance.new("Part")
	dot.Shape = Enum.PartType.Ball
	dot.Size = dotSize
	dot.Position = position
	dot.BrickColor = BrickColor.new(color)
	dot.Parent = workspace
	dot.CanCollide = false
	dot.CanTouch = false
	dot.CanQuery = false
	dot.Anchored = true

	spawn(function()
		wait(10)
		dot:Destroy()
	end)
end

game:GetService("UserInputService").InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		placingDot = true
		while placingDot and game:GetService("UserInputService"):IsMouseButtonPressed(Enum.UserInputType.MouseButton1) do
			local ray = Ray.new(camera.CFrame.Position, camera.CFrame.LookVector * 100)
			local hitPart, hitPosition, hitNormal = workspace:FindPartOnRayWithIgnoreList(ray, {player.Character})

			if hitPart then
				local color = "White"

				if hitPart.Name == "BLOK" then
					color = "Bright blue"
				elseif hitPart:IsDescendantOf(workspace.John) or hitPart.Name == "John" then
					color = "Really red"
				end

				local dotCenter = hitPosition + (hitNormal * 0.1)

				-- Generate a grid of dots with randomized positions aligned with the surface normal
				local rightVector = Vector3.new(1, 0, 0)
				local upVector = Vector3.new(0, 1, 0)
				if hitNormal.Y == 1 or hitNormal.Y == -1 then
					rightVector = hitNormal:Cross(Vector3.new(0, 0, 1)).Unit
					upVector = rightVector:Cross(hitNormal).Unit
				else
					rightVector = hitNormal:Cross(Vector3.new(0, 1, 0)).Unit
					upVector = rightVector:Cross(hitNormal).Unit
				end

				for y = -gridSize / 2, gridSize / 2 do
					for x = -gridSize / 2, gridSize / 2 do
						local xOffset = (math.random() - 0.5) * gridSpacing
						local yOffset = (math.random() - 0.5) * gridSpacing
						local dotPosition = dotCenter + (rightVector * (x * gridSpacing + xOffset)) + (upVector * (y * gridSpacing + yOffset))

						-- Check if the dot is within the same layer as the hit position
						if (dotPosition - hitPosition).Magnitude <= dotLayerDistance then
							CreateDot(dotPosition, color)
						end
					end
				end
			end

			wait()
		end
	end
end)

game:GetService("UserInputService").InputEnded:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		placingDot = false
	end
end)
