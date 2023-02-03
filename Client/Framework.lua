IsNUIReady = false
ESX = nil
local hunger = 98
local thirst = 98
local mental = 98
PlayerData = nil
--[[
https://discord.gg/7jQxWtS7rt
https://discord.gg/7jQxWtS7rt
https://discord.gg/7jQxWtS7rt
https://discord.gg/7jQxWtS7rt
https://discord.gg/7jQxWtS7rt
https://discord.gg/7jQxWtS7rt
]]

Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        Citizen.Wait(0)
    end
    while ESX.GetPlayerData().job == nil do
        Citizen.Wait(500)
    end
    PlayerData = ESX.GetPlayerData()
end)

RegisterNUICallback('NUIReady', function(data, cb)
	IsNUIReady = true
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
    ESX.PlayerData.job = job
    PlayerData.job = job
end)

RegisterNetEvent('esx:setGang')
AddEventHandler('esx:setGang', function(gang)
    ESX.PlayerData.gang = gang
    PlayerData.gang = gang
end)

RegisterNetEvent('moneyUpdate')
AddEventHandler('moneyUpdate', function(money)
    ESX.PlayerData.money = money
    PlayerData.money = money
end)

RegisterNetEvent('gcphone:setUiPhone')
AddEventHandler('gcphone:setUiPhone', function(money)
    ESX.PlayerData.bank = money
    PlayerData.bank = money
end)

RegisterNetEvent('HR_Coin:UpdateThatFuckinShit')
AddEventHandler('HR_Coin:UpdateThatFuckinShit', function(dCoin)
    ESX.PlayerData.Coin = dCoin
    PlayerData.Coin = dCoin
end)

function ZonaSegura(enable)
    SendNUIMessage({
        showZone = enable
    })
end

RegisterNetEvent('5G-Hud:INZone')
AddEventHandler('5G-Hud:INZone', function()
	ZonaSegura(true)
end)

RegisterNetEvent('5G-Hud:OUTZone')
AddEventHandler('5G-Hud:OUTZone', function()
	ZonaSegura(false)
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(10000)
        TriggerEvent('esx_status:getStatus', 'hunger', function(lav)
            TriggerEvent('esx_status:getStatus', 'thirst', function(ref)
                TriggerEvent('esx_status:getStatus', 'mental', function(fer)
                    hunger = lav.val / 10000
                    thirst = ref.val / 10000
                    mental = fer.val / 10000
                end)
            end)
        end)
    end
end)

function TriggerThread()
    Citizen.CreateThread(function()
        while true do
            Citizen.Wait(1500)
            TriggerInformation()
            TriggerStatus()
            if IsPauseMenuActive() then
                SendNUIMessage({action = 'hideAllHud'})
            else 
                SendNUIMessage({action = 'ShowAllHud'})
            end
            if IsPedArmed(PlayerPedId(), 7) then
                local weapon = GetSelectedPedWeapon(PlayerPedId())
                local ammoTotal = GetAmmoInPedWeapon(PlayerPedId(),weapon)
                local bool,ammoClip = GetAmmoInClip(PlayerPedId(),weapon)
                local ammoRemaining = math.floor(ammoTotal - ammoClip)
                SendNUIMessage({
                    action = 'updateAmmo',
                    ammo = ammoClip,
                    ammohand = ammoRemaining
                })
            else
                SendNUIMessage({
                    action = 'hideAmmo',
                })
            end
        end
    end)
end

function TriggerStatus()
    SendNUIMessage({action = 'statushud'})
    SendNUIMessage({talking = NetworkIsPlayerTalking(PlayerId())})
    SendNUIMessage({
        action = 'updateStatus',
        health = GetEntityHealth(PlayerPedId()) - 100,
        armor = GetPedArmour(PlayerPedId()),
        hunger = hunger,
        thirst = thirst,
        stress = mental,
        stamina = 100 - GetPlayerSprintStaminaRemaining(PlayerPedId()),
        oxigen = GetPlayerUnderwaterTimeRemaining(PlayerId())*Config.oxygenMax,
    })
end

function TriggerInformation()
    ESX.TriggerServerCallback('esx_playerIndicator:GetData', function(data)
        SendNUIMessage({
            action = 'updateStatusUP',
            pid = GetPlayerServerId(PlayerId()),
            wallet =  data.pdata.money,
            banks = data.pdata.bank,
            duty = '0',
            job = PlayerData.job.label..'┃'..PlayerData.job.grade_label,
            gang = PlayerData.gang.name..'┃'..PlayerData.gang.grade_label,
            logo = 'https://cdn.discordapp.com/attachments/831483081403531294/947841397594144818/Comp_5.gif',
            logotext = "DiamondRP",
            playerss = data.players,
            maxPlayers = 200,
            time = calculateDate(),
        })
    end)
end

function calculateDate()
    local minutes, hours = GetClockMinutes(), GetClockHours()
    if (minutes <= 9) then
        minutes = "0" .. minutes
    end
    if (hours <= 9) then
        hours = "0" .. hours
    end
    return hours .. " : " .. minutes
end

RegisterNetEvent("esx:playerLoaded")
AddEventHandler("esx:playerLoaded", function ()
    while not IsNUIReady or not PlayerData do
        Citizen.Wait(5000)
    end
    SendNUIMessage({ action = 'setColors' })
    SendNUIMessage({ action = 'setPosition' })
    SendNUIMessage({ action = 'ShowAllHud' })
    SendNUIMessage({ action = 'HideElement' }) 
    SendNUIMessage({ action = 'resetPosition' }) 
    SendNUIMessage({ action = 'ResetColor' }) 
    SendNUIMessage({action = 'speed1'})
    TriggerThread()
end)

AddEventHandler('onResourceStart', function(resourceName)
    if (GetCurrentResourceName() == resourceName) then
        while not IsNUIReady or not PlayerData do
            Citizen.Wait(5000)
        end
        SendNUIMessage({ action = 'setColors' })
        SendNUIMessage({ action = 'setPosition' })
        SendNUIMessage({ action = 'ShowAllHud' })
        SendNUIMessage({ action = 'HideElement' }) 
        SendNUIMessage({ action = 'resetPosition' })
        SendNUIMessage({ action = 'ResetColor' })
        SendNUIMessage({action = 'speed1'})
        TriggerThread()
    end
end)

Citizen.CreateThread(function() 
    while not IsNUIReady or not PlayerData do
        Citizen.Wait(5000)
    end
    if Config.Microphone == false then 
        SendNUIMessage({action = 'microphoneHide'})
    end
    if Config.USEJob == false then 
        SendNUIMessage({action = 'jobHide'})
    end
    if Config.USEScorePlayer == false then 
        SendNUIMessage({action = 'pedONLINEHide'})
    end
    if Config.USEPlayerID == false then 
        SendNUIMessage({action = 'pedIDHide'})
    end
    if Config.USELogo == false then 
        SendNUIMessage({action = 'logoHide'})
    end
    if Config.USELogoTEXT == false then 
        SendNUIMessage({action = 'logoTextHide'})
    end
    if Config.USEAmmoHUD == false then 
        SendNUIMessage({action = 'hideAmmo'})
    end
    if Config.USEKeybindHUD == false then 
        SendNUIMessage({action = 'Hidekeybindsall'})
    end
    if Config.USESafeZone == false then 
        SendNUIMessage({action = 'zonehide'})
    end
    if Config.USEMoneyCash == false then 
        SendNUIMessage({action = 'hidecash'})
    end
    if Config.USEMoneyBank == false then 
        SendNUIMessage({action = 'hidebank'})
    end
    if Config.USEMoneyDuty == false then 
        SendNUIMessage({action = 'hideduty'})
    end
    if Config.USEClock == false then 
        SendNUIMessage({action = 'hideclock'})
    end
end)

RegisterCommand(Config.Openpanel,function ()
    SetNuiFocus(true, true) 
    SendNUIMessage({
        action = 'menuShow'
    })
end)

RegisterNUICallback("exit" , function(data, cb)
    SetNuiFocus(false, false)
    SendNUIMessage({
        action = 'menuHide'
    })
end)