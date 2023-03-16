-- important variables
local tycoon = script.Parent.Parent.Parent -- connects to current tycoon
local module = require(tycoon.Parent.Parent.Settings) -- this variables refers to module script called settings that is saved 2 places above "tycoon" in the hierarchy
local tcnInfo = tycoon:WaitForChild("TycoonInfo") -- this variable reads "TycoonInfo" which contains many different information but the most important is who the owner of current tycoon is
local MarketplaceService = game:GetService("MarketplaceService") -- connects to roblox marketplace and enables gamepasses for this code

-- define how often cash is generated
local generationInterval = 1

-- function to generate cash
local function generateCash()
    local cashValue = 1
    if tcnInfo.Owner.Value and MarketplaceService:UserOwnsGamePassAsync(tcnInfo.Owner.Value.UserId, module.gamepassId) then
        cashValue = 2
    end

    if tcnInfo.Owner.Value == nil then
        return -- if tycoon belongs to nobody and item somehow exists, don't generate anything
    end
    if MarketplaceService:UserOwnsGamePassAsync(tcnInfo.Owner.Value.UserId, module.autoCollect) then
        local cash = game.ServerStorage:WaitForChild("PlayerCash"):FindFirstChild(tcnInfo.Owner.Value.Name)
        if cash then
            cash.Value += cashValue
        end
    else
        tcnInfo.CurrencyToCollect.Value += cashValue
    end
end

-- infinite loop until player leaves
while true do
    generateCash()
    wait(generationInterval)
end
