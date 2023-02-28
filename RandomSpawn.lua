local spawns = workspace.ItemSpawns
local items = game.ReplicatedStorage.Items
local seconds = 10

local function chooseSpawn()
    local _spawn = spawns:GetChildren()[math.random(1,#spawns:GetChildren())]
    return _spawn
end

local function chooseItem()
    local item = items:GetChildren()[math.random(1,#items:GetChildren())]
    return item
end

while true do
    wait(seconds)
    local _spawn = chooseSpawn()
    local item = chooseItem()
    local clone = item:Clone()

    clone.Parent = workspace
    clone.Handle.CFrame = _spawn.CFrame * CFrame.new(0,2,0)
end
