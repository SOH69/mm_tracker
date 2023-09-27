local QBCore = exports['qb-core']:GetCoreObject()
local vehicles = {}

RegisterNetEvent('mm_tracker:server:setobj', function(obj, plate)
    local src = source
    if #vehicles > Config.MaxLimit then
        TriggerClientEvent('QBCore:Notify', src, "Maximum Tracker limit Reached", "error")
        return
    end
    obj = NetworkGetEntityFromNetworkId(obj)
    vehicles[#vehicles+1] = {
        obj = obj,
        time = os.time(),
        coords = GetEntityCoords(obj),
        name = 'Plate: '..plate
    }
end)

RegisterNetEvent('mm_tracker:server:returnTracker', function(id, name)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    TriggerClientEvent('mm_tracker:client:expireTracker', -1, name)
    if Config.Inventory == 'ox_inventory' then
        exports.ox_inventory:AddItem(src, "tracker", 1)
    elseif Config.Inventory then
        Player.Functions.AddItem("tracker", 1)
    end
    vehicles[id] = nil
end)

QBCore.Functions.CreateUseableItem("tracker", function(source, item)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    if Config.Inventory == 'ox_inventory' then
        exports.ox_inventory:RemoveItem(src, "tracker", 1)
    elseif Config.Inventory then
        Player.Functions.RemoveItem(item.name, 1, item.slot)
    end
    TriggerClientEvent("mm_tracker:client:useTracker", source, vehicles)
end)



CreateThread(function()
    while true do
        for k, v in pairs(vehicles) do
            if ((v.time - os.time())/60) >= Config.TimeLimit then
                vehicles[k] = nil
                TriggerClientEvent('mm_tracker:client:expireTracker', -1, v.name)
            else
                v.coords = GetEntityCoords(v.obj)
            end
        end
        TriggerClientEvent('mm_tracker:client:sendTracker', -1, vehicles)
        Wait(Config.RefreshRate*1000)
    end
end)

lib.addCommand("removetracker", {
    help = "Remove Tracker from vehicle",
}, function(source)
    TriggerClientEvent("mm_tracker:client:removeTracker", source, vehicles)
end)