local Players = game:GetService("Players")
local BadgeService = game:GetService("BadgeService")
local BadgeId = "Badge ID"

local function onPlayerAdded(player)
	local hasBadge = BadgeService:UserHasBadgeAsync(player.UserId, BadgeId)
	if not hasBadge then
		player:Kick("Complete level 1!")
	end
end

Players.PlayerAdded:Connect(onPlayerAdded)

for _, player in ipairs(Players:GetPlayers()) do
	onPlayerAdded(player)
end
