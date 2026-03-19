-----------------------------------------------------------------------------------------------------------------------------------------
-- VRP
-----------------------------------------------------------------------------------------------------------------------------------------
local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
local vRP = Proxy.getInterface("vRP")

-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES
-----------------------------------------------------------------------------------------------------------------------------------------
-- Load state from KVP "database"
local isLibertyActive = GetResourceKvpString("libertyCityActive") == "true"
GlobalState.libertyCityActive = isLibertyActive

-----------------------------------------------------------------------------------------------------------------------------------------
-- CONFIGURAÇÃO DE BUCKETS (PERMANENTE E DINÂMICA)
-----------------------------------------------------------------------------------------------------------------------------------------
local defaultBuckets = {
    [200] = true,
    [201] = true,
    [0] = true
}

local dynamicBuckets = {}

-----------------------------------------------------------------------------------------------------------------------------------------
-- BUCKET SYSTEM
-----------------------------------------------------------------------------------------------------------------------------------------
Citizen.CreateThread(function()
    while true do
        Wait(1000)
        local players = GetPlayers()
        for _, playerId in ipairs(players) do
            local bucket = GetPlayerRoutingBucket(playerId)
            local isActive = nil
            
            if dynamicBuckets[bucket] ~= nil then
                isActive = dynamicBuckets[bucket]
            elseif defaultBuckets[bucket] ~= nil then
                isActive = defaultBuckets[bucket]
            end
            
            if Player(playerId).state.libertyCityActiveBucket ~= isActive then
                Player(playerId).state.libertyCityActiveBucket = isActive
            end
        end
    end
end)

-----------------------------------------------------------------------------------------------------------------------------------------
-- ATIVAR LIBERTY
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("loadny", function(source, args, rawCommand)
    local user_id = vRP.getUserId(source)
    local bucketArg = tonumber(args[1])
    
    if user_id then
        if vRP.hasPermission(user_id, "admin.permissao") or vRP.hasPermission(user_id, "Admin") then
            if bucketArg then
                dynamicBuckets[bucketArg] = true
                TriggerClientEvent("Notify", source, "Sucesso", "Liberty City successfully activated on bucket "..bucketArg..".", "verde",5000)
            else
                if not GlobalState.libertyCityActive then
                    SetResourceKvp("libertyCityActive", "true")
                    GlobalState.libertyCityActive = true
                    TriggerClientEvent("Notify", source, "Sucesso", "Liberty City successfully activated for all players without a specific bucket.", "verde",5000)
                else
                    TriggerClientEvent("Notify", source, "Negado", "Liberty City is already activated globally.", "vermelho",5000)
                end
            end
        end
    elseif source == 0 then -- Console console
        if bucketArg then
            dynamicBuckets[bucketArg] = true
            print("Liberty City activated via console on bucket "..bucketArg..".")
        else
            SetResourceKvp("libertyCityActive", "true")
            GlobalState.libertyCityActive = true
            print("Liberty City activated via console for everyone.")
        end
    end
end)

-----------------------------------------------------------------------------------------------------------------------------------------
-- DESATIVAR LIBERTY
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("unloadny", function(source, args, rawCommand)
    local user_id = vRP.getUserId(source)
    local bucketArg = tonumber(args[1])
    
    if user_id then
        if vRP.hasPermission(user_id, "admin.permissao") or vRP.hasPermission(user_id, "Admin") then
            if bucketArg then
                dynamicBuckets[bucketArg] = false
                TriggerClientEvent("Notify", source, "Sucesso", "Liberty City successfully deactivated on bucket "..bucketArg..".", "verde",5000)
            else
                if GlobalState.libertyCityActive then
                    SetResourceKvp("libertyCityActive", "false")
                    GlobalState.libertyCityActive = false
                    TriggerClientEvent("Notify",source,"Sucesso","Liberty City successfully deactivated globally for players without a specific bucket.","verde",5000)
                else
                    TriggerClientEvent("Notify", source, "Negado", "Liberty City is already deactivated globally.", "vermelho",5000)
                end
            end
        end
    elseif source == 0 then -- Console console
        if bucketArg then
            dynamicBuckets[bucketArg] = false
            print("Liberty City deactivated via console on bucket "..bucketArg..".")
        else
            SetResourceKvp("libertyCityActive", "false")
            GlobalState.libertyCityActive = false
            print("Liberty City deactivated globally via console.")
        end
    end
end)
