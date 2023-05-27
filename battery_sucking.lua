local player = game.Players.LocalPlayer
local leaderstats = player:WaitForChild("Batteries_Folder")
local battery = leaderstats:WaitForChild("Battery")
local atmosphere = game.Lighting.Atmosphere
local defaultAmbient = game.Lighting.OutdoorAmbient

local RemoteEvent = game.ReplicatedStorage:WaitForChild("BatteryChanged")
local debounceTime = 5
local debounceTimer = nil
local changeQueue = 0

local function sendBatteryChange()
	RemoteEvent:FireServer(changeQueue)
	changeQueue = 0
end

local function accumulateChange(amount)
	changeQueue = changeQueue + amount
	if not debounceTimer then
		debounceTimer = true
		spawn(function()
			wait(debounceTime)
			sendBatteryChange()
			debounceTimer = nil
		end)
	end
end

local function batterySucker()
	local playerGui = player:WaitForChild("PlayerGui")
	local nvGui = playerGui:WaitForChild("NV")
	local frame = nvGui:WaitForChild("Frame")

	local drainingBattery = false
	local batteryDrainRate = 1 

	frame:GetPropertyChangedSignal("Visible"):Connect(function()
		if frame.Visible then
			print("Frame is now visible!")
			if not drainingBattery then
				drainingBattery = true
				spawn(function()
					while drainingBattery and frame.Visible do
						print("Battery value before: ", battery.Value)
						if battery.Value <= 0 then
							frame.Visible = false
							drainingBattery = false
							game.Lighting.ColorCorrection.Enabled = false
							atmosphere.Haze = 0.982
							atmosphere.Density = 1.27
						else
							battery.Value = math.max(0, battery.Value - batteryDrainRate)
							accumulateChange(-batteryDrainRate)
						end
						print("Battery value after: ", battery.Value)
						wait(2)
					end
				end)
			end
		else
			print("Frame is now hidden!")
			drainingBattery = false
			sendBatteryChange() 
		end
	end)
end

batterySucker()
