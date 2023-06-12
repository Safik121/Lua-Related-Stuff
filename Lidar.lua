local player = game.Players.LocalPlayer
local camera = workspace.CurrentCamera

local scanning = false 
local initialCameraPosition = nil 
local debounce = false 

local function ScanObjects()
	if scanning or debounce then
		return
	end

	scanning = true 
	debounce = true 

	if not initialCameraPosition then
		initialCameraPosition = camera.CFrame.Position
	end

	local dotSize = Vector3.new(0.1, 0.1, 0.1)
	local scanSize = 30
	local stepSize = 0.3 
	local delay = 0.001
	local dotLifetime = 10

	local hitPart, hitPosition, hitNormal = workspace:FindPartOnRayWithIgnoreList(
		Ray.new(initialCameraPosition, camera.CFrame.LookVector * 10),
		{player.Character}
	)

	if hitPart then
		local dot = Instance.new("Part")
		dot.Shape = Enum.PartType.Ball
		dot.Size = dotSize
		dot.Position = hitPosition + (hitNormal * 0.1)
		dot.BrickColor = BrickColor.new("White")
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

	local initialLookVector = camera.CFrame.LookVector
	local initialRightVector = camera.CFrame.RightVector
	local initialUpVector = camera.CFrame.UpVector

	for y = scanSize / 2, -scanSize / 2, -stepSize do
		for x = -scanSize / 2, scanSize / 2, stepSize do
			local scanPosition = initialCameraPosition + (initialRightVector * x) + (initialUpVector * y)
			local scanRay = Ray.new(scanPosition, initialLookVector * 100)

			local scanHitPart, scanHitPosition, scanHitNormal = workspace:FindPartOnRayWithIgnoreList(
				scanRay,
				{player.Character}
			)

			if scanHitPart then
				local obstructionRay = Ray.new(scanHitPosition, initialCameraPosition - scanHitPosition)
				local obstructionPart, _, _ = workspace:FindPartOnRayWithIgnoreList(obstructionRay, {player.Character})

				if not obstructionPart then
					local dot = Instance.new("Part")
					dot.Shape = Enum.PartType.Ball
					dot.Size = dotSize
					dot.Position = scanHitPosition + (scanHitNormal * 0.1)

					if scanHitPart.Name == "BLOK" then
						dot.BrickColor = BrickColor.new("Bright blue")
					elseif scanHitPart:IsDescendantOf(workspace.John) then
						dot.BrickColor = BrickColor.new("Really red")
					else
						dot.BrickColor = BrickColor.new("White")
					end

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
			end
		end
		wait(delay)
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
