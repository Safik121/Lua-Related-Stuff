local starterGui = game:GetService("StarterGui")
local player = game.Players.LocalPlayer
local leaderstats = player:WaitForChild("leaderstats")
local battery = leaderstats:WaitForChild("Battery")

local function batterySucker()
    local playerGui = player:WaitForChild("PlayerGui")
    local nvGui = playerGui:WaitForChild("NV")
    local frame = nvGui:WaitForChild("Frame")

    frame:GetPropertyChangedSignal("Visible"):Connect(function()
        if frame.Visible then
            print("Frame is now visible!")

            local drainingBattery = true

            spawn(function()
                while drainingBattery and frame.Visible do
                    battery.Value = battery.Value - 1
                    if battery.Value <= 95 then
                        frame.Visible = false
                        drainingBattery = false
                    end
                    wait(1)
                end
            end)

        else
            print("Frame is now hidden!")
        end
    end)
end

batterySucker()
