local resourceName = GetCurrentResourceName()
local githubRepo = "dylakkj/ayx-mapmanager" 
local githubBranch = "main"
local githubRawUrl = "https://raw.githubusercontent.com/" .. githubRepo .. "/" .. githubBranch .. "/"


local updateFiles = {
    "fxmanifest.lua",
    "version.lua",
    "server.lua"
}

local function checkVersion()
    print("^3[" .. resourceName .. "] Verificando atualizações no GitHub...^7")
    
    local localVersionFile = LoadResourceFile(resourceName, "version.lua")
    if not localVersionFile then return end
    
    local localVersion = localVersionFile:match('HypeUpdater.Version = "(.-)"')
    
    PerformHttpRequest(githubRawUrl .. "version.lua", function(errorCode, resultData, resultHeaders)
        if errorCode == 200 then
            local remoteVersion = resultData:match('HypeUpdater.Version = "(.-)"')
            
            if remoteVersion and remoteVersion ~= localVersion then
                print("^2[" .. resourceName .. "] Nova versão encontrada: " .. remoteVersion .. " (Local: " .. localVersion .. ")^7")
                updateResource(remoteVersion)
            else
                print("^2[" .. resourceName .. "] Script está atualizado via GitHub (Versão: " .. localVersion .. ")^7")
            end
        else
            print("^1[" .. resourceName .. "] Erro ao verificar versão no GitHub: " .. errorCode .. "^7")
        end
    end, "GET")
end

function updateResource(newVersion)
    print("^3[" .. resourceName .. "] Iniciando download seguro da v" .. newVersion .. "...^7")
    
    local downloadedData = {}
    local filesFinished = 0

    for _, fileName in ipairs(updateFiles) do
        PerformHttpRequest(githubRawUrl .. fileName, function(errorCode, resultData)
            if errorCode == 200 then
                downloadedData[fileName] = resultData
                filesFinished = filesFinished + 1
                
                if filesFinished == #updateFiles then
                    for file, content in pairs(downloadedData) do
                        SaveResourceFile(resourceName, file, content, -1)
                        print("^5[" .. resourceName .. "] Arquivo salvo: " .. file .. "^7")
                    end
                    
                    print("^2[" .. resourceName .. "] Todos os arquivos foram atualizados!^7")
                    
                    -- Thread para enviar 5 notificações ao servidor
                    CreateThread(function()
                        for i = 1, 5 do
                            TriggerClientEvent("Notify", -1, "Atualização", "O script <b>" .. resourceName .. "</b> foi atualizado para v" .. newVersion .. ".<br>Por favor, reinicie o servidor para carregar a nova source.", "verde", 10000)
                            print("^3[" .. resourceName .. "] Notificação " .. i .. "/5 enviada aos jogadores.^7")
                            if i < 5 then
                                Wait(60000) -- Espera 1 minuto entre as notificações (ou ajuste conforme necessário)
                            end
                        end
                    end)
                end
            else
                print("^1[" .. resourceName .. "] Erro crítico ao baixar " .. fileName .. " (Abortando atualização)^7")
            end
        end, "GET")
    end
end

-- Inicia a verificação ao carregar o servidor
CreateThread(function()
    Wait(15000)
    checkVersion()
end)