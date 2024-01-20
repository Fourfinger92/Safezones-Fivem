local SafezoneIn = false
local SafezoneOut = false
local closestZone = 1
local allowedToUse = false
local bypass = false
local count = 1

Citizen.CreateThread(function()
	TriggerServerEvent("SafeZones:isAllowed")
end)

RegisterNetEvent("SafeZones.returnIsAllowed")
AddEventHandler("SafeZones.returnIsAllowed", function(isAllowed)
    allowedToUse = isAllowed
end)

RegisterCommand("sbypass", function(source, args, rawCommand)
	if allowedToUse then
	if not bypass then
	bypass = true
	ShowInfo("~g~SafeZone Bypass Enabled!")
	elseif bypass then
	bypass = false
	ShowInfo("~r~SafeZone Bypass Disabled!")
	end
else
	ShowInfo("~r~Insufficient Permissions.")
end
end)

Citizen.CreateThread(function()
	while true do
		local playerPed = PlayerPedId()
		local x, y, z = table.unpack(GetEntityCoords(playerPed, true))
		local minDistance = 100000
		Citizen.Wait(1000)
		for i = 1, #ConfigSafeZones.zones, 1 do
			dist = Vdist(ConfigSafeZones.zones[i].x, ConfigSafeZones.zones[i].y, ConfigSafeZones.zones[i].z, x, y, z)
			if dist < minDistance then
				minDistance = dist
				closestZone = i
			end
		end
	end
end)

local warte = 1650

Citizen.CreateThread(function()
	while true do
		warte = 5000
		local player = PlayerPedId()
		local x,y,z = table.unpack(GetEntityCoords(player, true))
		local dist = Vdist(ConfigSafeZones.zones[closestZone].x, ConfigSafeZones.zones[closestZone].y, ConfigSafeZones.zones[closestZone].z, x, y, z)
		local vehicle = GetVehiclePedIsIn(player, false)
		local speed = GetEntitySpeed(vehicle)

		if dist <= 150 then
			warte = 1450
		end
		if dist <= 75 then
			warte = 3
		end
		if count ==1 then
			if dist <= ConfigSafeZones.radius then 
				if not SafezoneIn then
					godmode = true
					SafezoneIn = true
					SafezoneOut = false
				end
			else
				if not SafezoneOut then
					SafezoneOut = true
					SafezoneIn = false
				end
			end
			count = count -1
		else


			if dist <= ConfigSafeZones.radius then
				if not SafezoneIn then
					NetworkSetFriendlyFireOption(false)
					SetEntityCanBeDamaged(vehicle, false)
					ClearPlayerWantedLevel(PlayerId())
					SetCurrentPedWeapon(player,GetHashKey("WEAPON_UNARMED"),true)
					if ConfigSafeZones.showNotification then
					TriggerEvent("hud:notify", "SYSTEM", "Du bist nun in einer Safezone!", "notification", "info")
					end
					SafezoneIn = true
					SafezoneOut = false
				end
			else
				if not SafezoneOut then
					NetworkSetFriendlyFireOption(true)
					if ConfigSafeZones.showNotification then
						TriggerEvent("hud:notify", "SYSTEM", "Du hast die Safezone verlassen!", "notification", "info")
					end
					if ConfigSafeZones.speedlimitinSafezone then
					SetVehicleMaxSpeed(vehicle, 1000.00)
					end
					SetEntityCanBeDamaged(vehicle, true)
					SafezoneOut = true
					SafezoneIn = false
				end
				Citizen.Wait(200)
			end
			if SafezoneIn then
				warte = 3
				if not bypass then
					DisablePlayerFiring(player, true)
					SetPlayerCanDoDriveBy(player, false)
					DisableControlAction(2, 37, true)
					DisableControlAction(0, 106, true)
					DisableControlAction(0, 24, true)
					DisableControlAction(0, 69, true)
					DisableControlAction(0, 70, true)
					DisableControlAction(0, 92, true)
					DisableControlAction(0, 114, true)
					DisableControlAction(0, 257, true)
					DisableControlAction(0, 331, true)
					DisableControlAction(0, 68, true)
					DisableControlAction(0, 257, true)
					DisableControlAction(0, 263, true)
					DisableControlAction(0, 264, true)
					DisableControlAction(0, 45, true)
					DisableControlAction(0, 80, true)
					DisableControlAction(0, 140, true)
					DisableControlAction(0, 263, true)

					if ConfigSafeZones.speedlimitinSafezone then
						mphs = 2.237
						maxspeed = ConfigSafeZones.speedlimitinSafezone/mphs
						SetVehicleMaxSpeed(vehicle, maxspeed)
					end

					if IsDisabledControlJustPressed(2, 37) then
						SetCurrentPedWeapon(player,GetHashKey("WEAPON_UNARMED"),true)
					end
					if IsDisabledControlJustPressed(0, 106) then 
						SetCurrentPedWeapon(player,GetHashKey("WEAPON_UNARMED"),true)
					end
				end
			end
		end
		Wait(warte)
	end
end)


function ShowInfo(text)
	BeginTextCommandThefeedPost("STRING")
	AddTextComponentSubstringPlayerName(text)
	EndTextCommandThefeedPostTicker(true, false)
end
