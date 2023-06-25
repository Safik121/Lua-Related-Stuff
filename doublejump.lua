local player = game.Players.LocalPlayer
local character = player.Character
local Humanoid = character:FindFirstChildOfClass("Humanoid")

local UserInputService = game:GetService("UserInputService")

local jumpKey = Enum.KeyCode.Space

local jumpCount = 0
local canJump = true

local function Jump()
	if Humanoid and canJump then
		jumpCount = jumpCount + 1
		Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
		Humanoid.Jump = true
		canJump = false
	end
end

local function onTouched(part)
	if part.Name == "Baseplate" then
		jumpCount = 0
		canJump = true
	end
end

UserInputService.InputBegan:Connect(function(input)
	if jumpCount < 2 then
		if input.KeyCode == jumpKey then
			Jump()
		end
	end
end)

character.Humanoid.Touched:Connect(onTouched)
