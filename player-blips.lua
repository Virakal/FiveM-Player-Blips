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
		Wait(100)

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

		for player = 0, 64 do
			if player ~= currentPlayer and NetworkIsPlayerActive(player) then
				local playerPed = GetPlayerPed(player)
				local playerName = GetPlayerName(player)
				local new_blip = AddBlipForEntity(playerPed)

				RemoveBlip(blips[player])

				-- Add player name to blip
				SetBlipNameToPlayerName(new_blip, player)

				-- Make blip white
				SetBlipColour(new_blip, player + 10)

				-- Enable text on blip
				SetBlipCategory(new_blip, 2)

				-- Set the blip to shrink when not on the minimap
				-- Citizen.InvokeNative(0x2B6D467DAB714E8D, new_blip, true)

				SetBlipScale(new_blip, 0.9)

				Citizen.InvokeNative(0xBFEFE3321A3F5015, playerPed, playerName, false, false, '', false)

				-- Record blip so we don't keep recreating it
				blips[player] = new_blip
			end
		end
	end
end)
