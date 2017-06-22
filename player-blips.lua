function GetPlayers()
	local players = {}

	for i = 0, 31 do
		if NetworkIsPlayerActive(i) then
			table.insert(players, i)
		end
	end

	return players
end

Citizen.CreateThread(function()
	local blips = {}
	local currentPlayer = PlayerId()
	local i = 0

	while true do
		Wait(1)

		i = i + 1

		if i >= 30000 then
			-- Every n frames, recreate all blips in case something screwed up
			i = 0

			for _, blip in ipairs(blips) do
				if blip then
					RemoveBlip(blip)
				end
			end

			blips = {}
		end

		local players = GetPlayers()

		for _, player in ipairs(players) do
			if player ~= currentPlayer and not blips[player] then
				local playerPed = GetPlayerPed(player)
				local new_blip = AddBlipForEntity(playerPed)

				-- Add player name to blip
				SetBlipNameToPlayerName(new_blip, player)

				-- Make blip white
				SetBlipColour(new_blip, 0)

				-- Enable text on blip
				SetBlipCategory(new_blip, 2)

				-- Set the blip to shrink when not on the minimap
				Citizen.InvokeNative(0x2B6D467DAB714E8D, new_blip, true)

				-- Record blip so we don't keep recreating it
				blips[player] = new_blip
			end
		end
	end
end)
