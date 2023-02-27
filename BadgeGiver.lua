script.Parent.Touched:Connect(function(part)
	if part.Parent:FindFirstChild("Humanoid") then
		local player = game.Players:GetPlayerFromCharacter(part.Parent)
		game:GetService("BadgeService"):AwardBadge(player.UserId, 2141603999) -- input badge ID
	end
end)
