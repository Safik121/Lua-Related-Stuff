
local vertices = {
	Vector3.new(0, 0, 0),
	Vector3.new(10, 0, 0),
	Vector3.new(5, 10, 0)
}
local iterations = 10000

local plotter = Instance.new("Part")
plotter.Anchored = true
plotter.CanCollide = false
plotter.Size = Vector3.new(0.1, 0.1, 0.1)
plotter.BrickColor = BrickColor.new("Bright red")
plotter.Position = vertices[math.random(1, #vertices)] -- Randomly select a starting vertex
plotter.Parent = workspace

local function getRandomVertex()
	return vertices[math.random(1, #vertices)]
end

for i = 1, iterations do

	local clone = plotter:Clone()
	clone.Parent = workspace


	local target = getRandomVertex()


	local newPosition = (plotter.Position + target) / 2


	plotter.Position = newPosition

	wait(0.001) 
end

plotter:Destroy()
