RegisterServerEvent("SafeZones:isAllowed")
AddEventHandler("SafeZones:isAllowed", function()
    if IsPlayerAceAllowed(source, "safezones.bypass") then
        TriggerClientEvent("SafeZones.returnIsAllowed", source, true)
    else
        TriggerClientEvent("SafeZones.returnIsAllowed", source, false)
    end
end)




