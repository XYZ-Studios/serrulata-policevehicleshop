if Config.Target == 'ox_target' then 
    exports.ox_target:addBoxZone({
        coords = vec3(464.53, -1012.39, 28.08),
        size = vec3(2, 2, 2),
        rotation = 45,
        debug = drawZones,
        options = {
            {
                name = 'box',
                event = 'serrulata-policevehicleshop:client:enter',
                icon = 'fas fa-car',
                label = 'Enter Police Shop',
                distance = 1.5,
            }
        }
    })
    exports.ox_target:addBoxZone({
        coords = vec3(202.12, -1008.29, -99.0),
        size = vec3(2, 2, 2),
        rotation = 0,
        debug = drawZones,
        options = {
            {
                name = 'box',
                event = 'serrulata-policevehicleshop:client:leave',
                icon = 'fas fa-car',
                label = 'Leave Police Shop',
                distance = 1.5,
            }
        }
    })
elseif Config.Target == 'qb-target' then
    exports['qb-target']:AddBoxZone("pdupstair", vector3(459.46, -1008.02, 28.26), 1.4, 0.4, {
        name="pdupstair",
        heading=0,
        --debugPoly=true,
        minZ=27.26,
        maxZ=29.66
        }, {
        options = { 
            {
                type = "client",
                event = "serrulata-policevehicleshop:client:enter",
                icon = 'fas fa-car',
                label = 'Enter Police Shop',
                job = 'police'
            }
        },
        distance = 1.5,
    })
    exports['qb-target']:AddBoxZone("Pdout", vector3(212.67, -999.02, -99.0), 1.4, 0.2, {
        name="pdunder",
        heading=0,
        --debugPoly=true,
        minZ=-100.0,
        maxZ=-97.6
        }, {
        options = { 
            {
                type = "client",
                event = 'serrulata-policevehicleshop:client:leave',
                icon = 'fas fa-car',
                label = 'Leave Police Shop',
                job = 'police'
            }
        },
        distance = 1.5,
    })
end