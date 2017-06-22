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

	while true do
		Wait(1)

		local players = GetPlayers()
		local i = 0

		for _, player in ipairs(players) do
			if player ~= currentPlayer and not blips[player] then
				local playerPed = GetPlayerPed(player)
				local new_blip = AddBlipForEntity(playerPed)

				SetBlipNameToPlayerName(new_blip, player)
				SetBlipColour(new_blip, 0)
				-- Enable text on blip
				SetBlipCategory(new_blip, 2)
				-- Set the blip to shrink when not on the minimap
				Citizen.InvokeNative(0x2B6D467DAB714E8D, new_blip, true)

				blips[player] = new_blip
			end
		end
	end
end)
