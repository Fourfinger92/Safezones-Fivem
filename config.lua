ConfigSafeZones = {}


-- Coords for all safezones
ConfigSafeZones.zones = {
	{ ['x'] = -214.6123, ['y'] = -1011.3016, ['z'] = 29.7704}, -- Einreise
	--{ ['x'] = -1123.8680, ['y'] = -832.2680, ['z'] = 19.3199}  -- PD Sperrzone
}


ConfigSafeZones.showNotification = true -- Show notification when in Safezone?
ConfigSafeZones.radius = 100.0 -- Change the RADIUS of the Safezone.
ConfigSafeZones.speedlimitinSafezone = 50 -- Set a speed limit in a Safezone (MPH), Set to false to disable


-- Change the color of the notification
ConfigSafeZones.notificationstyle = "success"
--Notification Styles
-- inform
-- error
-- success