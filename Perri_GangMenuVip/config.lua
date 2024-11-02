Config = {}

Config.OpenKey = 'F6'


function OpenInventory() -- PUT YOUR OPEN INVENTORY ACTION, THIS IS FOR QUASAR INVENTORY
    local targetPlayerId = lib.getClosestPlayer(GetEntityCoords(cache.ped), Config.MaxDistance)
    exports['progressbar']:Progress({
        name = "searching",
        duration = 2000,
        label = 'Searching...',
        useWhileDead = false,
        canCancel = true,
        controlDisables = {
            disableMovement = false,
            disableCarMovement = true,
            disableMouse = false,
            disableCombat = true,
        }
    })
    
    Wait(2000)
    TriggerServerEvent("inventory:server:OpenInventory", "otherplayer", GetPlayerServerId(targetPlayerId))
end

Config.Notification = true -- This is if you want to receive the notification or not.
Config.NoPermission = "You don't have permission to use the VIP menu" -- This is the notification
Config.NoNearbyPlayers = 'There are no players nearby'



Config.DeathMessage = "Cannot open menu while dead"
Config.MaxDistance = 3

Config.ServerName = "Your server"


-- COMMANDS (/givevip ID) (/removevip ID)
