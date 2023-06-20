local ESX = nil

ESX = exports['es_extended']:getSharedObject()


local availableVehicles = {
    { model = 'Adder', label = 'Adder 5k$', price = 5000 },
    { model = 'Ardent', label = 'Ardent 3k$', price = 3000 },
    { model = 'Avarus', label = 'Avarus 2k$', price = 2000 },

}

Citizen.CreateThread(function()
    for _, vehicleData in ipairs(availableVehicles) do
        local vehicleBlip = AddBlipForCoord(2347.9814, 3047.7444, 47.565)
        SetBlipSprite(vehicleBlip, 225)
        SetBlipDisplay(vehicleBlip, 4)
        SetBlipScale(vehicleBlip, 0.8)
        SetBlipColour(vehicleBlip, 1)
        SetBlipAsShortRange(vehicleBlip, true)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString('Auta używane')
        EndTextCommandSetBlipName(vehicleBlip)
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        local playerPed = GetPlayerPed(-1)
        local playerCoords = GetEntityCoords(playerPed)

        for _, vehicleData in ipairs(availableVehicles) do
            local vehicleCoords = vector3(2368.7351, 3033.9585, 51.0785)
            local distance = #(playerCoords - vehicleCoords)

            if distance < 3.0 then
                DrawMarker(2, vehicleCoords.x, vehicleCoords.y, vehicleCoords.z - 1.0, 0, 0, 0, 0, 0, 0, 1.0, 1.0, 1.0, 255, 255, 255, 100, false, true, 2, false, false, false, false)

                if distance < 1.5 then
                    ESX.ShowHelpNotification('Naciśnij ~INPUT_CONTEXT~, aby kupić Auto ')

                    if IsControlJustReleased(0, 38) then
                        OpenPurchaseMenu(vehicleData)
                    end
                end
            end
        end
    end
end)

function OpenPurchaseMenu(vehicleData)
    local elements = {}

    for _, vehicle in ipairs(availableVehicles) do
        table.insert(elements, { label = vehicle.label, value = vehicle })
    end

    ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'purchase_menu', {
        title = 'Wybierz pojazd do kupienia',
        align = 'center',
        elements = elements
    }, function(data, menu)
        BuyVehicle(data.current.value)
        menu.close()
    end, function(data, menu)
        menu.close()
    end)
end

function BuyVehicle(vehicleData)
    ESX.TriggerServerCallback('esx_vehicleshop:buyVehicle', function(canBuy)
        if canBuy then
            local model = vehicleData.model
        else
            ESX.ShowNotification('Nie masz wystarczającej ilości gotówki!')
        end
    end, vehicleData.model, vehicleData.plate)
end
