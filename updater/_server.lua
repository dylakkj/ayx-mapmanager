local resourceName = GetCurrentResourceName()
local githubRepo = "dylakkj/ayx-mapmanager" 
local githubBranch = "main"
local githubRawUrl = "https://raw.githubusercontent.com/" .. githubRepo .. "/" .. githubBranch .. "/"


local updateFiles = {
    "fxmanifest.lua",
    "updater/_version.lua",
    "updater/_server.lua",
    "adapter/core.client.lua",
    "adapter/core.server.lua",
    "adapter/startup.server.lua",
    "adapter/ymaps.client.lua",
    "data/water/newyork.xml",
    "data/water/water.xml",
    "data/xml/timecycle_mods_lc.xml"
}

local function checkVersion()
    --[[ print("^3[mapmanager] Verificando atualizações no GitHub...^7") ]]
    
    local localVersionFile = LoadResourceFile(resourceName, "updater/_version.lua")
    if not localVersionFile then return end
    
    local localVersion = localVersionFile:match('HypeUpdater.Version = "(.-)"')
    
    PerformHttpRequest(githubRawUrl .. "updater/_version.lua", function(errorCode, resultData, resultHeaders)
        if errorCode == 200 then
            local remoteVersion = resultData:match('HypeUpdater.Version = "(.-)"')
            
            if remoteVersion and remoteVersion ~= localVersion then
                print("^2[mapmanager] Nova versão encontrada: " .. remoteVersion .. " (Local: " .. localVersion .. ")^7")
                updateResource(remoteVersion)
            else
                print("^2[mapmanager] O mapmanager está utilizando a última versão.^7")
            end
        else
            print("^1[mapmanager] Erro ao verificar versão no GitHub: " .. errorCode .. "^7")
        end
    end, "GET")
end

function updateResource(newVersion)
    --[[ print("^3[mapmanager] Iniciando download seguro da v" .. newVersion .. "...^7") ]]
    
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
                        print("^5[mapmanager] Arquivo atualizado: " .. file .. "^7")
                    end
                    
                    print("^2[mapmanager] Arquivos atualizados com sucesso!^7")
                    
                    -- Thread para enviar 5 alertas no console CMD
                    CreateThread(function()
                        for i = 1, 5 do
                            print("^1[mapmanager] Novas atualizações aplicadas reinicie o servidor...^7")
                            
                            if i < 5 then
                                Wait(1000) -- Intervalo de 1 minuto entre os alertas no console
                            end
                        end
                    end)
                end
            else
                print("^1[mapmanager] Erro crítico ao baixar " .. fileName .. " (Abortando atualização)^7")
            end
        end, "GET")
    end
end

-- Inicia a verificação ao carregar o servidor
CreateThread(function()
    Wait(10000)
    checkVersion()
end)