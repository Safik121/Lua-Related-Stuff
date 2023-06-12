local player = game.Players.LocalPlayer
local camera = workspace.CurrentCamera

local placingDots = false

local function PlaceRandomDots()
	if placingDots then
		return
	end

	placingDots = true

	local dotSize = Vector3.new(0.3, 0.3, 0.3)
	local dotLifetime = 60
	local areaSize = 10 
	local dotsPerIteration = 30 
	local delayBetweenDots = 0.01

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
			wait(dotLifetime)
			dot:Destroy()
		end)
	end

	while placingDots do
		for _ = 1, dotsPerIteration do
			local randomOffset = Vector3.new(
				math.random(-areaSize / 2, areaSize / 2),
				math.random(-areaSize / 2, areaSize / 2),
				math.random(-areaSize / 2, areaSize / 2)
			)

			local dotPosition = camera.CFrame.Position + camera.CFrame.LookVector * 10 + randomOffset
			local ray = Ray.new(dotPosition, camera.CFrame.LookVector * 100) 

			local hitPart, hitPosition, hitNormal = workspace:FindPartOnRayWithIgnoreList(ray, {player.Character})

			if hitPart then
				if hitPart.Name == "BLOK" then
					CreateDot(hitPosition + (hitNormal * 0.1), "Bright blue")
				elseif hitPart:IsDescendantOf(workspace.John) then
					CreateDot(hitPosition + (hitNormal * 0.1), "Really red")
				else
					CreateDot(hitPosition + (hitNormal * 0.1), "White")
				end
			end

			wait(delayBetweenDots) 
		end

		wait() 
	end
end

game:GetService("UserInputService").InputBegan:Connect(function(input)
	if input.KeyCode == Enum.KeyCode.E then
		PlaceRandomDots()
	end
end)

game:GetService("UserInputService").InputEnded:Connect(function(input)
	if input.KeyCode == Enum.KeyCode.E then
		placingDots = false
	end
end)
