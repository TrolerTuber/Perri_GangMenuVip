isOpen, cegado, isHandcuffed, wasDragged, inVehicle = false, false, false, false, false
dragged = {}
dragged.dragging = false

RegisterNetEvent('Perri_Cacheo:client:drag', function(sc)
    wasDragged = not wasDragged  

    if not isHandcuffed then
        DisplayRadar(true)
        DetachEntity(cache.ped, true, false)
        wasDragged = false
        dragged.dragging = false
        return
    end

    dragged.dragging = not dragged.dragging
    dragged.sc = sc
    
    CreateThread(function()
        while wasDragged do
            local targetPed = GetPlayerPed(GetPlayerFromServerId(dragged.sc))

            if DoesEntityExist(targetPed) and IsPedOnFoot(targetPed) and not IsPedDeadOrDying(targetPed, true) then
                AttachEntityToEntity(cache.ped, targetPed, 11816, 0.54, 0.54, 0.0, 0.0, 0.0, 0.0, false, false, false, false, 2, true)
            else
                wasDragged = false
            end

            Wait(50)
        end
        DetachEntity(cache.ped, true, false)
    end)

end)

RegisterNetEvent('Perri_CacheoVIP:Client:vehicle', function()
    local vehicle, distance = ESX.Game.GetClosestVehicle()
    local seating = IsPedSittingInAnyVehicle(cache.ped)
    local maxSeats, freeSeat = GetVehicleMaxNumberOfPassengers(vehicle)
    
    inVehicle = not inVehicle

    if not isHandcuffed or not inVehicle or not seating then
        return
    end

    TaskLeaveVehicle(cache.ped, GetVehiclePedIsIn(cache.ped, false), 64)

    if not vehicle or distance > 5  then
        return
    end
        
    for i = maxSeats - 1, 0, -1 do
        if IsVehicleSeatFree(vehicle, i) then
            freeSeat = i
        end
        break
    end

    if not freeSeat then
        return
    end

    TaskWarpPedIntoVehicle(cache.ped, vehicle, freeSeat)
    dragged.dragging = false
end)

RegisterNetEvent('Perri_Cacheo:Client:ponerBolsa', function()
    ponerBolsa()
end)

RegisterNetEvent('Perri_Cacheo:Client:handcuff', function()
    handcuff()
end)

RegisterNUICallback('exit', function(data, cb)
    SetNuiFocus(false, false)
    isOpen = false
end)

RegisterNUICallback('cachear', function()
    searchPlayer()
end)

RegisterNUICallback('esposar', function()
    local targetPlayerId = lib.getClosestPlayer(GetEntityCoords(cache.ped), Config.MaxDistance)

    if not targetPlayerId then
        noPermissionNotification()
        return
    end
    
    TriggerServerEvent('Perri_Cacheo:Server:handcuff', GetPlayerServerId(targetPlayerId))
end)

RegisterNUICallback('cegar', function()
    local targetPlayerId = lib.getClosestPlayer(GetEntityCoords(cache.ped), Config.MaxDistance)

    if not targetPlayerId then
        noPermissionNotification()
        return
    end

    TriggerServerEvent('Perri_Cacheo:Server:ponerBolsa', GetPlayerServerId(targetPlayerId))
end)

RegisterNUICallback('drag', function(data, cb)
    local targetPlayerId = lib.getClosestPlayer(GetEntityCoords(cache.ped), Config.MaxDistance)

    if not targetPlayerId then
        noPermissionNotification()
        return
    end

    TriggerServerEvent('Perri_Cacheo:server:drag', GetPlayerServerId(targetPlayerId))
end)

RegisterNUICallback('vehiculo', function()
    local targetPlayerId = lib.getClosestPlayer(GetEntityCoords(cache.ped), Config.MaxDistance)

    if not targetPlayerId then
        noPermissionNotification()
        return
    end
    
    TriggerServerEvent('Perri_Cacheo:Server:vehicle', GetPlayerServerId(targetPlayerId))
end)

CreateThread(function()
    while not ESX.PlayerLoaded or not ESX.PlayerData.dateofbirth do
        Wait(500)
    end    

    Wait(500)

    TriggerServerEvent('cacheo:playerLoaded')
end)

lib.addKeybind({
    name = 'vipSearch',
    description = 'Open VIP search menu',
    defaultKey = Config.OpenKey,
    onPressed = function()
        openMenu()
        isOpen = true
    end
})
