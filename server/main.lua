local QBCore = exports['qb-core']:GetCoreObject()
---------------------------------------------------------------------------

function GeneratePlate()
    local plate = QBCore.Shared.RandomInt(1) .. QBCore.Shared.RandomStr(2) .. QBCore.Shared.RandomInt(3) .. QBCore.Shared.RandomStr(2)
    local result = MySQL.scalar.await('SELECT plate FROM player_vehicles WHERE plate = ?', {plate})
    if result then
        return GeneratePlate()
    else
        return plate:upper()
    end
end
----------------------------------------------------------------------------------------------------------------
RegisterNetEvent('serrulata-policeshop:server:buyVehicle', function(vehicleNumber)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local cid = Player.PlayerData.citizenid
    local plate = GeneratePlate()
    local vehicle = Config.Vehicles[vehicleNumber]
    local vehicleNumber = 0
    for i = 1, #Config.Vehicles do
        if Config.Vehicles[i].model == vehicle.model then
            vehicleNumber = i
        end
    end
    if Player.PlayerData.money.cash >= vehicle.price then
        Player.Functions.RemoveMoney('cash', vehicle.price)

        MySQL.insert('INSERT INTO player_vehicles (license, citizenid, vehicle, hash, mods, plate, garage, state) VALUES (?, ?, ?, ?, ?, ?, ?, ?)', {
            Player.PlayerData.license,
            cid,
            vehicle.model,
            GetHashKey(vehicle.model),
            '{}',
            plate,
            Config.Garage,
            1
        })

        TriggerClientEvent('QBCore:Notify', src, 'You bought a ' .. vehicle.label .. ' for $' .. vehicle.price, 'success')
        TriggerClientEvent('serrulata-policeshop:client:buyVehicle', src, vehicle.model, plate)
        TriggerClientEvent('vehiclekeys:client:SetOwner', src, plate)
    else
        TriggerClientEvent('QBCore:Notify', src, 'You do not have enough money', 'error')
    end
end)


RegisterNetEvent('serrulata-policeshop:setbucket', function()
    local src = source
    SetPlayerRoutingBucket(src, 5)
end)
RegisterNetEvent('serrulata-policeshop:returnBucket', function()
    local src = source
    SetPlayerRoutingBucket(src, 0)
end)
----------------------------------------------------------------------------------------------------------------
AddEventHandler('onResourceStart', function(resource)
   if resource == GetCurrentResourceName() then
      print('Serrulata Police Vehicle Shop Started')
   end
end)
AddEventHandler('onResourceStop', function(resource)
   if resource == GetCurrentResourceName() then
    print("^2 Serrulata-Studios ^7v^41^7.^40^7.^40 ^7- ^2Serrulata-PoliceVehicleShop^7")
   end
end)






