local player = game.Players.LocalPlayer
local camera = workspace.CurrentCamera

local scanning = false
local initialCameraPosition = nil
local debounce = false

local function PlaceDot(position, size, color)
	local dot = Instance.new("Part")
	dot.Shape = Enum.PartType.Ball
	dot.Size = size
	dot.Position = position
	dot.BrickColor = color
	dot.Parent = workspace
	dot.Anchored = true
	dot.CanCollide = false
	dot.CanTouch = false
	dot.CanQuery = false

	return dot
end

local function ScanObjects()
	if scanning or debounce then
		return
	end

	scanning = true
	debounce = true

	if not initialCameraPosition then
		initialCameraPosition = camera.CFrame.Position
	end

	local dotSize = Vector3.new(0.05, 0.05, 0.05)
	local scanSize = 30
	local stepSize = 0.3
	local maxDotsPerFrame = 50  -- Maximum number of dots generated per frame
	local dotLifetime = 50

	local hitPart, hitPosition, hitNormal = workspace:FindPartOnRayWithIgnoreList(
		Ray.new(initialCameraPosition, camera.CFrame.LookVector * 10),
		{player.Character}
	)

	if hitPart then
		local dot = PlaceDot(hitPosition + hitNormal * 0.1, dotSize, BrickColor.new("White"))

		spawn(function()
			wait(dotLifetime)
			dot:Destroy()
		end)
	end

	local initialLookVector = camera.CFrame.LookVector
	local initialRightVector = camera.CFrame.RightVector
	local initialUpVector = camera.CFrame.UpVector

	local dotsGenerated = 0  -- Track the number of dots generated in the current frame

	for y = scanSize / 2, -scanSize / 2, -stepSize do
		for x = -scanSize / 2, scanSize / 2, stepSize do
			local xOffset = math.random() * stepSize - stepSize / 2
			local yOffset = math.random() * stepSize - stepSize / 2

			local scanPosition = initialCameraPosition + (initialRightVector * (x + xOffset)) + (initialUpVector * (y + yOffset))
			local scanRay = Ray.new(scanPosition, initialLookVector * 100)

			local scanHitPart, scanHitPosition, scanHitNormal = workspace:FindPartOnRayWithIgnoreList(
				scanRay,
				{player.Character}
			)

			if scanHitPart then
				local obstructionRay = Ray.new(scanHitPosition, initialCameraPosition - scanHitPosition)
				local obstructionPart, _, _ = workspace:FindPartOnRayWithIgnoreList(obstructionRay, {player.Character})

				if not obstructionPart then
					local dotColor = BrickColor.new("White")

					if scanHitPart.Name == "BLOK" then
						dotColor = BrickColor.new("Bright blue")
					elseif scanHitPart:IsDescendantOf(workspace.John) or scanHitPart.Name == "John" then
						dotColor = BrickColor.new("Really red")
					end

					local dot = PlaceDot(scanHitPosition + scanHitNormal * 0.1, dotSize, dotColor)

					spawn(function()
						wait(dotLifetime)
						dot:Destroy()
					end)

					dotsGenerated = dotsGenerated + 1

					if dotsGenerated >= maxDotsPerFrame then
						dotsGenerated = 0
						wait()  -- Yield to the engine to prevent excessive lag
					end
				end
			end
		end
	end

	scanning = false
	initialCameraPosition = nil
	wait(1)
	debounce = false
end

game:GetService("UserInputService").InputBegan:Connect(function(input)
	if input.KeyCode == Enum.KeyCode.F then
		ScanObjects()
	end
end)
