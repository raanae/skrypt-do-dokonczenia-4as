ESX.RegisterServerCallback('esx_vehicleshop:buyVehicle', function(source, cb, model, plate)
    local xPlayer = ESX.GetPlayerFromId(source)
    

    exports.oxmysql:execute('SELECT * FROM vehicles WHERE model = ? LIMIT 1', {model}, function(result)
        if result[1] then
            local vehicleData = result[1]
            local modelPrice = vehicleData.price

            if modelPrice and xPlayer.getMoney() >= modelPrice then
                xPlayer.removeMoney(modelPrice, "Vehicle Purchase")


                local generatedPlate = GenerateRandomPlate("AU")
                
                exports.oxmysql:insert('INSERT INTO owned_vehicles (owner, plate, vehicle) VALUES (?, ?, ?)',
                    {xPlayer.identifier, generatedPlate, json.encode({ model = model, plate = generatedPlate })},
                    function(rowsChanged)
                        cb(true)
                    end
                )
            else
                cb(false)
            end
        else
            cb(false)
        end
    end)
end)


function GenerateRandomPlate(prefix)
    local plateLetters = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
    local plateNumbers = "0123456789"
    local generatedPlate = prefix


    for i = 1, 3 do
        local randomIndex = math.random(1, #plateLetters)
        generatedPlate = generatedPlate .. plateLetters:sub(randomIndex, randomIndex)
    end


    for i = 1, 3 do
        local randomIndex = math.random(1, #plateNumbers)
        generatedPlate = generatedPlate .. plateNumbers:sub(randomIndex, randomIndex)
    end

    return generatedPlate
end
