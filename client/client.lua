local QBCore = exports['qb-core']:GetCoreObject()

local PlayerData = {}
local blips = {}
local tracker = 0


local function SetTracker()
    lib.requestModel('prop_police_radio_main', 500)
    local coords = GetEntityCoords(cache.ped)
    tracker = CreateObject(`prop_police_radio_main`, coords.x, coords.y, coords.z, true, true, false)
    AttachEntityToEntity(tracker, cache.ped, GetPedBoneIndex(cache.ped, 28422), -0.03, 0.0, 0.0, 0.0, 0.0, 0.0, true, true, false, true, 1, true)
    
    lib.requestAnimSet("move_ped_crouched", 500)
    SetPedMovementClipset(cache.ped, "move_ped_crouched", 0.25 )
    lib.requestAnimDict('weapons@projectile@sticky_bomb', 500)
    TaskPlayAnim(cache.ped, 'weapons@projectile@sticky_bomb', 'plant_vertical', 8.0, -8.0, 8000, 0, 0, false, false, false)
end

AddEventHandler('QBCore:Client:OnPlayerLoaded', function()
    PlayerData = QBCore.Functions.GetPlayerData()
end)

RegisterNetEvent('QBCore:Client:OnJobUpdate', function(JobInfo)
    PlayerData.job = JobInfo
end)

RegisterNetEvent('QBCore:Client:OnPlayerUnload', function()
    PlayerData = {}
end)

RegisterNetEvent('mm_tracker:client:expireTracker', function(name)
    if PlayerData.job and PlayerData.job.name == 'police' then
        if blips[name] then
            RemoveBlip(blips[name])
            blips[name] = nil
        end
    end
end)

RegisterNetEvent('mm_tracker:client:sendTracker', function(veh)
    local vehicles = veh
    if PlayerData.job and PlayerData.job.name == 'police' then
        for _, v in pairs(vehicles) do
            if #(GetEntityCoords(cache.ped) - v.coords) < Config.TrackerRange then
                if blips[v.name] then
                    SetBlipCoords(blips[v.name], v.coords.x, v.coords.y, v.coords.z)
                    if Config.Blip.flash then
                        SetBlipFlashTimer(blip, Config.Blip.flashrate)
                    end
                else
                    local blip = AddBlipForCoord(v.coords.x, v.coords.y, v.coords.z)
                    SetBlipSprite(blip, Config.Blip.sprite)
                    SetBlipColour(blip, Config.Blip.color)
                    SetBlipScale(blip, Config.Blip.scale)
                    BeginTextCommandSetBlipName('STRING')
                    AddTextComponentString(v.name)
                    EndTextCommandSetBlipName(blip)
                    if Config.Blip.flash then
                        SetBlipFlashTimer(blip, Config.Blip.flashrate)
                    end
                    blips[v.name] = blip
                end
            else
                if blips[v.name] then
                    RemoveBlip(blips[v.name])
                    blips[v.name] = nil
                end
            end
        end
    end
end)

RegisterNetEvent('mm_tracker:client:useTracker', function(veh, item)
    local coords = GetEntityCoords(cache.ped)
    local vehicle, vehcoords = lib.getClosestVehicle(coords, 5.0, false)
    if vehicle == -1 then
        lib.notify({
            title = 'Failed',
            description = 'No vehicles Found',
            type = 'error'
        })
        return
    end
    local distance = #(coords - vehcoords)
    if PlayerData.job and PlayerData.job.name == 'police' then
        for _, v in pairs(veh) do
            if v.name == 'Plate: '..QBCore.Functions.GetPlate(vehicle) then
                lib.notify({
                    title = 'Failed',
                    description = 'Tracker Already Installed',
                    type = 'error'
                })
                return
            end
        end
        if vehicle ~= -1 and distance < 3 then
            SetTracker()
            QBCore.Functions.Progressbar("setting_tracker", "Fixing Tracker...", 8000, false, true, {
                disableMovement = false,
                disableCarMovement = false,
                disableMouse = false,
                disableCombat = true,
            }, {}, {}, {}, function() -- Done
                DeleteEntity(tracker)
                TriggerServerEvent('mm_tracker:server:setobj', NetworkGetNetworkIdFromEntity(vehicle), QBCore.Functions.GetPlate(vehicle))
                TriggerServerEvent('mm_tracker:server:removeItem', item)
                ClearPedTasksImmediately(cache.ped)
                ResetPedMovementClipset(cache.ped, 0.25)
            end)
        else
            lib.notify({
                title = 'Failed',
                description = 'No vehicles Nearby',
                type = 'error'
            })
        end
    else
        lib.notify({
            title = 'Failed',
            description = 'Not authorized',
            type = 'error'
        })
    end
end)

RegisterNetEvent('mm_tracker:client:removeTracker', function(veh)
    if PlayerData.job and PlayerData.job.name == 'police' then
        local vehicles = veh
        local coords = GetEntityCoords(cache.ped)
        local vehicle, vehcoords = lib.getClosestVehicle(coords, 5.0, false)
        local distance = #(coords - vehcoords)
        if vehicle ~= -1 and distance < 3 then
            for k, v in pairs(vehicles) do
                RequestAnimDict('mp_car_bomb')
                while not HasAnimDictLoaded('mp_car_bomb') do
                    Wait(100)
                end
                TaskPlayAnim(cache.ped, "mp_car_bomb", "car_bomb_mechanic" ,3.0, 3.0, -1, 16, 0, false, false, false)
                QBCore.Functions.Progressbar("setting_tracker", "Removing tracker...", 8000, false, true, {
                    disableMovement = false,
                    disableCarMovement = false,
                    disableMouse = false,
                    disableCombat = true,
                }, {}, {}, {}, function() -- Done
                    TriggerServerEvent('mm_tracker:server:returnTracker', k, v.name)
                    ClearPedTasksImmediately(cache.ped)
                end)
                return
            end
            lib.notify({
                title = 'Failed',
                description = 'No Tracker Found',
                type = 'error'
            })
        else
            lib.notify({
                title = 'Failed',
                description = 'No vehicles Nearby',
                type = 'error'
            })
        end
    else
        lib.notify({
            title = 'Failed',
            description = 'Not authorized',
            type = 'error'
        })
    end
end)