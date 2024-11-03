local DISCORD_URL = Config.Webhook

RegisterCommand('givevip', function(playerId, args)
    local xPlayer = ESX.GetPlayerFromId(playerId)
    local target = args[1]

    if xPlayer.getGroup() ~= 'admin' then
        xPlayer.showNotification('No tienes permiso para usar este comando')
        return
    end

    if not target or not GetPlayerName(target) then
        xPlayer.showNotification('Inserta un ID valido o el jugador no está conectado')
        return
    end

    local xTarget = ESX.GetPlayerFromId(target)

    if xTarget.getMeta('perri_cacheo') and xTarget.getMeta('perri_cacheo').enabled then
        xPlayer.showNotification('Este jugador ya tiene el Cacheo VIP')
    else
        xTarget.setMeta('perri_cacheo', { enabled = true })
        xPlayer.showNotification('Le has dado el menu VIP a ' .. xTarget.name)
        TriggerClientEvent('NotificacionVIP', target, 'Has recibido el menu de cacheo VIP')

        sendToDiscord('Sistema de cacheo VIP', 'El Administrador ' .. xPlayer.name .. ' ha dado permiso del Cacheo VIP a ' .. xTarget.name, Config.ServerName, 5743096)
    end
end)

RegisterCommand('removevip', function(playerId, args)
    local xPlayer = ESX.GetPlayerFromId(playerId)
    local target = args[1]

    if xPlayer.getGroup() ~= 'admin' then
        xPlayer.showNotification('No tienes permiso para usar este comando')
        return
    end

    if not target or not GetPlayerName(target) then
        xPlayer.showNotification('Inserta un ID valido o el jugador no está conectado')
        return
    end

    local xTarget = ESX.GetPlayerFromId(target)

    if xTarget.getMeta('perri_cacheo') and xTarget.getMeta('perri_cacheo').enabled then
        xTarget.setMeta('perri_cacheo', { enabled = false })
        xPlayer.showNotification('Le has quitado el menu VIP a ' .. xTarget.name)
        TriggerClientEvent('NotificacionVIP', target, 'Un Administrador te ha quitado el menu de cacheo VIP')

        sendToDiscord('Sistema de cacheo VIP', 'El Administrador ' .. xPlayer.name .. ' ha quitado el permiso del Cacheo VIP a ' .. xTarget.name, Config.ServerName, 13762560)
    else
        xPlayer.showNotification('Este jugador no tiene el Cacheo VIP')
    end
end)

function sendToDiscord(name, message, footer, color)
    local embed = {
        {
            ["color"] = color,
            ["title"] = "**" .. name .. "**",
            ["description"] = message,
            ["footer"] = {
                ["text"] = footer,
            },
        }
    }

    PerformHttpRequest(DISCORD_URL, function(err, text, headers) end, 'POST', json.encode({username = name, embeds = embed}), { ['Content-Type'] = 'application/json' })
end

RegisterNetEvent('esx:playerLoaded', function(playerId, xPlayer)
    local cacheoData = xPlayer.getMeta('perri_cacheo') or {}
    
    if not cacheoData.enabled then
        xPlayer.setMeta('perri_cacheo', { enabled = false })
    end
end)

RegisterNetEvent('cacheo:playerLoaded', function()
    local playerId = tonumber(source)
    local xPlayer = ESX.GetPlayerFromId(playerId)

    local cacheoData = xPlayer.getMeta('perri_cacheo') or {}
    
    if not cacheoData.enabled then
        xPlayer.setMeta('perri_cacheo', { enabled = false })
    end
end)




RegisterNetEvent('Perri_Cacheo:Server:handcuff', function(target)
	local xPlayer = ESX.GetPlayerFromId(source)


    if not xPlayer.getMeta('perri_cacheo') then
        DropPlayer(source, '¿Que haces intentando hackear esto pillin?')
        return
    end

	TriggerClientEvent('Perri_Cacheo:Client:handcuff', target)
end)

RegisterNetEvent('Perri_Cacheo:Server:ponerBolsa', function(target)
	local xPlayer = ESX.GetPlayerFromId(source)

    if not xPlayer.getMeta('perri_cacheo') then
        DropPlayer(source, '¿Que haces intentando hackear esto pillin?')
        return
    end

    TriggerClientEvent('Perri_Cacheo:Client:ponerBolsa', target)
end)


RegisterNetEvent('Perri_Cacheo:Server:vehicle', function(target)
    local xPlayer = ESX.GetPlayerFromId(source)

    if not xPlayer.getMeta('perri_cacheo') then
        DropPlayer(source, '¿Que haces intentando hackear esto pillin?')
        return
    end

    TriggerClientEvent('Perri_CacheoVIP:Client:vehicle', target)
end)

RegisterNetEvent('Perri_Cacheo:server:drag', function(target)
	local xPlayer = ESX.GetPlayerFromId(source)

    if not xPlayer.getMeta('perri_cacheo') then
        DropPlayer(source, '¿Que haces intentando hackear esto pillin?')
        return
    end

    TriggerClientEvent('Perri_Cacheo:client:drag', target, source)
end)

RegisterNetEvent('Perri:kickPlayer', function()
    DropPlayer(source, 'Uso de NUI Devtools')
end)


if GetCurrentResourceName() ~= 'Perri_GangMenuVip' then
    return os.exit()
end
