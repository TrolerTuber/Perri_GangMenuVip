plyState = LocalPlayer.state

function openMenu()
    isCacheoEnabled = plyState.metadata.perri_cacheo and plyState.metadata.perri_cacheo.enabled
    
    if IsPlayerDead(cache.playerId) and isCacheoEnabled then
        ESX.ShowNotification(Config.DeathMessage)
        return
    end

    if (not isCacheoEnabled or cegado or isHandcuffed) and Config.Notification then
        lib.notify({
            title = '¡ERROR!',
            description = Config.NoPermission,
            type = 'error'
        })
        return
    end

    SendNUIMessage({
        action = 'show'
    })
    SetNuiFocus(true, true)
    SetNuiFocusKeepInput(true)

    CreateThread(function()
        while isOpen do
            DisableDisplayControlActions()
            Wait(1)
        end
    end)
end


function searchPlayer()
    isCacheoEnabled = plyState.metadata.perri_cacheo and plyState.metadata.perri_cacheo.enabled

    if not isCacheoEnabled then
            TriggerServerEvent('Perri:kickPlayer')
        return
    end
    
    local targetPlayerId = lib.getClosestPlayer(GetEntityCoords(cache.ped), Config.MaxDistance)

    if not targetPlayerId then
        lib.notify({
            title = '¡ERROR!',
            description = Config.NoNearbyPlayers,
            type = 'error'
        })
        return
    end

    lib.requestAnimDict('anim@gangops@facility@servers@bodysearch@')
    TaskPlayAnim(cache.ped, 'anim@gangops@facility@servers@bodysearch@', 'player_search', 8.0, 1.0, 3000, 49, 0, 0, 0, 0)
    
    OpenInventory()
end



function ponerBolsa()
    
    cegado = not cegado

    if not cegado then
        SendNUIMessage({
            action = 'bolsa'
        }) 
    
        DisplayRadar(false)
        return
    end

    SendNUIMessage({
        action = 'quitarBolsa'
    })
    DisplayRadar(true)
end




function handcuff()
       
	isHandcuffed = not isHandcuffed

    if not isHandcuffed then
        wasDragged = false
        dragged.dragging = false
        DetachEntity(cache.ped, true, false)
        
		ClearPedSecondaryTask(cache.ped)
		SetEnableHandcuffs(cache.ped, false)
		DisablePlayerFiring(cache.ped, false)
		SetPedCanPlayGestureAnims(cache.ped, true)
		DisplayRadar(true)
        return
    end

    lib.requestAnimDict('mp_arresting', 1000)
    TaskPlayAnim(cache.ped, 'mp_arresting', 'idle', 8.0, -8, -1, 49, 0, 0, 0, 0)
    SetEnableHandcuffs(cache.ped, true)

    DisablePlayerFiring(cache.ped, true)
    SetCurrentPedWeapon(cache.ped, `WEAPON_UNARMED`, true) 
    SetPedCanPlayGestureAnims(cache.ped, false)
    DisplayRadar(false)
    
    CreateThread(function()
        while isHandcuffed do
            DisableWhenIsHandcuffed()
            Wait(0)
        end
    end)
end


function DisableDisplayControlActions()

    DisableControlAction(0, 1, true) -- disable mouse look
    DisableControlAction(0, 2, true) -- disable mouse look
    DisableControlAction(0, 3, true) -- disable mouse look
    DisableControlAction(0, 4, true) -- disable mouse look
    DisableControlAction(0, 5, true) -- disable mouse look
    DisableControlAction(0, 6, true) -- disable mouse look
    DisableControlAction(0, 75, true) -- disable leave vehicle
    DisableControlAction(0, 263, true) -- disable melee
    DisableControlAction(0, 264, true) -- disable melee
    DisableControlAction(0, 257, true) -- disable melee
    DisableControlAction(0, 140, true) -- disable melee
    DisableControlAction(0, 141, true) -- disable melee
    DisableControlAction(0, 142, true) -- disable melee
    DisableControlAction(0, 143, true) -- disable melee
    DisableControlAction(0, 177, true) -- disable escape
    DisableControlAction(0, 200, true) -- disable escape
    DisableControlAction(0, 202, true) -- disable escape
    DisableControlAction(0, 322, true) -- disable escape
    DisableControlAction(0, 25, true) -- disable aiming
    DisableControlAction(0, 245, true) -- disable chat
    DisableControlAction(0, 37, true) -- disable TAB
    DisableControlAction(0, 261, true) -- disable mouse wheel
    DisableControlAction(0, 262, true) -- disable mouse wheel
    DisableControlAction(0, 288, true) -- Disable open phone
    DisableControlAction(0, 289, true) -- Disable open inventory
    HideHudComponentThisFrame(19)
end


function DisableWhenIsHandcuffed()
    DisableControlAction(0, 25, true) -- disable aiming
    DisableControlAction(0, 263, true) -- disable melee
    DisableControlAction(0, 264, true) -- disable melee
    DisableControlAction(0, 257, true) -- disable melee
    DisableControlAction(0, 140, true) -- disable melee
    DisableControlAction(0, 141, true) -- disable melee
    DisableControlAction(0, 142, true) -- disable melee
    DisableControlAction(0, 143, true) -- disable melee
    DisableControlAction(0, 177, true) -- disable escape
    DisableControlAction(0, 200, true) -- disable escape
    DisableControlAction(0, 202, true) -- disable escape
    DisableControlAction(0, 322, true) -- disable escape
    DisableControlAction(0, 75, true) -- disable leave vehicle
    DisableControlAction(0, 245, true) -- disable chat
    DisableControlAction(0, 37, true) -- disable TAB
    DisableControlAction(0, 261, true) -- disable mouse wheel
    DisableControlAction(0, 262, true) -- disable mouse wheel
    HideHudComponentThisFrame(19)
    if IsEntityPlayingAnim(cache.ped, 'mp_arresting', 'idle', 3) ~= 1 then
        ESX.Streaming.RequestAnimDict('mp_arresting', function()
            TaskPlayAnim(cache.ped, 'mp_arresting', 'idle', 8.0, -8, -1, 49, 0.0, false, false, false)
            RemoveAnimDict('mp_arresting')
        end)
    end    
end


function noPermissionNotification()
    lib.notify({
        title = '¡ERROR!',
        description = Config.NoNearbyPlayers,
        type = 'error'
    })
end

