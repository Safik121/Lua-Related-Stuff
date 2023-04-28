local frame = script.Parent
local keybind = Enum.KeyCode.F
local canToggle = true
local defaultAmbient = game.Lighting.OutdoorAmbient
local toggleOnSound = game:GetService("SoundService"):FindFirstChild("On")
local toggleOffSound = game:GetService("SoundService"):FindFirstChild("Off")
local atmosphere = game.Lighting.Atmosphere

local function toggleFrame()
	if canToggle then
		canToggle = false
		frame.Visible = not frame.Visible
		if frame.Visible then
			if toggleOnSound then
				toggleOnSound:Play()
			end
			game.Lighting.OutdoorAmbient = Color3.fromRGB(255, 255, 255)
			game.Lighting.ColorCorrection.Enabled = true
			atmosphere.Haze = 0
			atmosphere.Density = 0
		else
			if toggleOffSound then
				toggleOffSound:Play()
			end
			game.Lighting.OutdoorAmbient = defaultAmbient
			game.Lighting.ColorCorrection.Enabled = false
			atmosphere.Haze = 0.982
			atmosphere.Density = 1.27
		end
		wait(3)
		canToggle = true
	end
end

frame.Visible = false

game:GetService("UserInputService").InputBegan:Connect(function(input, gameProcessed)
	if input.KeyCode == keybind and not gameProcessed then
		toggleFrame()
	end
end)
