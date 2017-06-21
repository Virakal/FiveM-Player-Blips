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

		for _, blip in ipairs(blips) do
			if blip and DoesBlipExist(blip) then
				RemoveBlip(blip)
			end
		end

		blips = {}

		local players = GetPlayers()

		for _, player in ipairs(players) do
			if player ~= currentPlayer then
				local playerPed = GetPlayerPed(player)
				local coords = GetEntityCoords(playerPed)
				local new_blip = AddBlipForCoord(coords.x, coords.y, coords.z)

				table.insert(blips, new_blip)
			end
		end
	end
end)
