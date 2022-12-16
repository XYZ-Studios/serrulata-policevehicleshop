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
    print('am lazy making into qb-target do a pull request if you want it')  -- unsupported
end