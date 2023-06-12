local player = game.Players.LocalPlayer
local camera = workspace.CurrentCamera

local placingDot = false

local function CreateDot(position, color)
	local dot = Instance.new("Part")
	dot.Shape = Enum.PartType.Ball
	dot.Size = Vector3.new(0.3, 0.3, 0.3)
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
				elseif hitPart:IsDescendantOf(workspace.John) then
					color = "Really red"
				end

				local dotPosition = hitPosition + (hitNormal * 0.1)
				CreateDot(dotPosition, color)
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
