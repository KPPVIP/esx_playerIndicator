local ind = {l = false, r = false}
local ped = PlayerPedId()
local vehData = {handler = false}
local fuel
local showhud = false
local position = GetEntityCoords(PlayerPedId())
local carSpeed = 0
local lastSpeed = 0

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1000)
		ped = PlayerPedId()
		local vehicle = GetVehiclePedIsIn(ped)
		if vehicle > 0 and GetPedInVehicleSeat(vehicle, -1) == ped then
			vehData.handler = vehicle
			vehData.pause = IsPauseMenuActive()

			if vehData.fuel ~= math.floor(exports.LegacyFuel:GetFuel(vehicle)) then
				vehData.fuel = math.floor(exports.LegacyFuel:GetFuel(vehicle))
                SendNUIMessage({
                    action = 'showCarhud';
                    vel = carSpeed; 
                    gasolina = vehData.fuel;
                    street = GetStreetNameFromHashKey(GetStreetNameAtCoord(position.x, position.y, position.z));
                    cinturon = true;
                    bateria = GetIsVehicleEngineRunning(GetVehiclePedIsIn(PlayerPedId(), false));
                    vidav  = GetVehicleBodyHealth(GetVehiclePedIsUsing(PlayerPedId()))/10;
                })
			end
		else
			vehData = {handler = false}
            SendNUIMessage({
                action = 'hideCarhud';
            })
		end

		if not (vehData.handler and not vehData.pause) and showhud then
			showhud = false
            SendNUIMessage({
                action = 'hideCarhud';
            })
		end
	end
end)

Citizen.CreateThread(function()
	while true do
		if vehData.handler and not vehData.pause then
			Citizen.Wait(250)
			carSpeed = math.ceil(GetEntitySpeed(vehData.handler) * 3.6)
			if carSpeed ~= lastSpeed then
				lastSpeed = carSpeed
				showhud = true
                position = GetEntityCoords(PlayerPedId())
                SendNUIMessage({
                    action = 'showCarhud';
                    vel = carSpeed; 
                    gasolina = vehData.fuel;
                    street = GetStreetNameFromHashKey(GetStreetNameAtCoord(position.x, position.y, position.z));
                    cinturon = true;
                    bateria = GetIsVehicleEngineRunning(GetVehiclePedIsIn(PlayerPedId(), false));
                    vidav  = GetVehicleBodyHealth(GetVehiclePedIsUsing(PlayerPedId()))/10;
                })
			end
		else
			Citizen.Wait(1000)
		end
	end
end)
