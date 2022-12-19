QBCore = exports['qb-core']:GetCoreObject()

local vehicleNumber = 0
local vehicle = Config.Vehicles[i]

function GenerateVehicle()
    for i = 1, #Config.Vehicles do
        local model = GetHashKey(Config.Vehicles[i].model)

        while not HasModelLoaded(model) do
            RequestModel(model)
            Citizen.Wait(0)
        end

        local vehicle = CreateVehicle(model, Config.Vehicles[i].x, Config.Vehicles[i].y, Config.Vehicles[i].z, Config.Vehicles[i].h, true, false)

        SetVehicleEngineOn(vehicle, false, false, true)
        SetVehicleEngineHealth(vehicle, 1000.0)
        SetVehicleBodyHealth(vehicle, 1000.0)
        SetVehiclePetrolTankHealth(vehicle, 1000.0)
        SetVehicleDirtLevel(vehicle, 0.0)

        SetVehicleOnGroundProperly(vehicle)
        SetVehicleNumberPlateText(vehicle, "PD SALE")
        SetVehicleColours(vehicle, 0, 0)
        SetVehicleExtraColours(vehicle, 0, 0)
        SetVehicleModKit(vehicle, 0)
        SetVehicleWheelType(vehicle, 0)

        SetVehicleMod(vehicle, 11, 2, false)
        SetVehicleMod(vehicle, 12, 2, false)
        SetVehicleMod(vehicle, 13, 2, false)
        SetVehicleMod(vehicle, 15, 3, false)
        SetVehicleMod(vehicle, 16, 3, false)

        FreezeEntityPosition(vehicle, true)
    end
end

function DeleteGeneratedVehicle() -- Delete all vehicles in the area when the player leaves
    local vehicles = GetGamePool('CVehicle')
    for _, vehicle in pairs(vehicles) do
        local vehicleCoords = GetEntityCoords(vehicle)
        local distance = #(vector3(202.77, -1007.7, -100.0) - vehicleCoords)
        if distance < 50.0 then
            DeleteEntity(vehicle)
        end
    end
end

function loadAnimDict(dict)
    while (not HasAnimDictLoaded(dict)) do
        RequestAnimDict(dict)
        Wait(0)
    end
end

local function enterdoor()
    ClearPedSecondaryTask(cache.ped)
    loadAnimDict( "anim@heists@keycard@" ) 
    TaskPlayAnim( cache.ped, "anim@heists@keycard@", "exit", 8.0, 1.0, -1, 16, 0, 0, 0, 0 )
    Citizen.Wait(850)
    ClearPedTasks(cache.ped)
end

------------------------------------------------------------------------------------------
CreateThread(function() --- Shitty code, but it works
    for i = 1, #Config.Vehicles do
        local vehicle = Config.Vehicles[i]
        local boxZone = BoxZone:Create(vector3(vehicle.x, vehicle.y, vehicle.z), 5.0, 2.8, {
            name = "vehicle_" .. i,
            heading = vehicle.h,
            debugPoly = Config.Debug,
            minZ = vehicle.z - 1.0,
            maxZ = vehicle.z + 1.0,
        })
        boxZone:onPlayerInOut(function(isPointInside, point)
            if isPointInside then
                for i = 1, #Config.Vehicles do
                    if Config.Vehicles[i].model == vehicle.model then
                        vehicleNumber = i
                    end
                end

                lib.registerContext({
                    id = 'VehicleMenu',
                    title = 'Police Shop',
                    menu = 'VehicleMenu',
                    options = {
                        {
                            title = vehicle.label,
                            description = 'Price: $' .. vehicle.price,
                            event = 'policeshop:buyvehicle',
                        }
                    },
                })
                lib.showContext('VehicleMenu')
            end
        end)
    end
end) 
------------------------------------------------------------------------------------------
RegisterNetEvent('policeshop:buyvehicle', function()

    local confirm = lib.alertDialog({
        header = 'Confirm Purchase?',
        content = 'Are you sure you want to buy this vehicle?',
        centered = true,
        cancel = true
    })
    
    if confirm ~= 'cancel' then
        TriggerServerEvent('serrulata-policeshop:server:buyVehicle', vehicleNumber)
    end
end)
RegisterNetEvent('serrulata-policevehicleshop:client:enter', function(source)  -- am not sure why made this, but it works
    if QBCore.Functions.GetPlayerData().job and QBCore.Functions.GetPlayerData().job.name == 'police' then
        local Ped = cache.ped
        local PlayerCoords = GetEntityCoords(Ped)
        if not IsPedInAnyVehicle(Ped, false) then
            TriggerServerEvent("InteractSound_SV:PlayOnSource", "houses_door_open", 0.1)
            enterdoor()
            DoScreenFadeOut(1000)
            Wait(1500)
            TriggerServerEvent("InteractSound_SV:PlayOnSource", "houses_door_close", 0.1)
            SetEntityCoords(Ped, 202.77, -1007.7, -100.0, 4.63)
            TriggerServerEvent('serrulata-policeshop:setbucket')
            DoScreenFadeIn(1000)
            Wait(500)
            GenerateVehicle()
        else
            QBCore.Functions.Notify("You cannot enter while in a vehicle.")
        end
    else
        QBCore.Functions.Notify("You are not a police officer.")
    end
end)
RegisterNetEvent('serrulata-policevehicleshop:client:leave', function(source) -- am not sure why made this, but it works
    local Ped = cache.ped
    local PlayerCoords = GetEntityCoords(Ped)
    if not IsPedInAnyVehicle(Ped, false) then
        TriggerServerEvent("InteractSound_SV:PlayOnSource", "houses_door_open", 0.1)
        enterdoor()
        DoScreenFadeOut(1000)
        Wait(1500)
        TriggerServerEvent("InteractSound_SV:PlayOnSource", "houses_door_close", 0.1)
        SetEntityCoords(Ped, 464.46, -1012.77, 28.07, 185.47)
        TriggerServerEvent('serrulata-policeshop:returnBucket')
        DoScreenFadeIn(1000)
        DeleteGeneratedVehicle()
    else
        QBCore.Functions.Notify("You cannot leave while in a vehicle.")
    end
end)
RegisterNetEvent('policeshop:client:phonemail', function()
    local vehicle = Config.Vehicles[vehicleNumber]
    local email = {
        sender = 'Police Vehicle Shop',
        subject = 'Vehicle Purchase',
        message = 'You have purchased a ' .. vehicle.label .. ' It is stored in the ' .. Config.Garage .. ' Garage.',
    }
    TriggerServerEvent('qb-phone:server:sendNewMail', email)
end)
------------------------------------------------------------------------------------------
AddEventHandler('onResourceStop', function(resource)
   if resource == GetCurrentResourceName() then
    local vehicles = GetGamePool('CVehicle')
    for _, vehicle in pairs(vehicles) do
        DeleteEntity(vehicle)
    end 
  end 
end)

