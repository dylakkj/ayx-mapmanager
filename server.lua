local resourceName = GetCurrentResourceName()
local githubRepo = "dylakkj/ayx-mapmanager" -- EXEMPLO: Troque pelo seu repo real
local githubBranch = "main"
local githubRawUrl = "https://raw.githubusercontent.com/" .. githubRepo .. "/" .. githubBranch .. "/"

-- Arquivos que serão atualizados
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
    print("^3[" .. resourceName .. "] Baixando atualizações...^7")
    
    local filesDownloaded = 0
    for _, fileName in ipairs(updateFiles) do
        PerformHttpRequest(githubRawUrl .. fileName, function(errorCode, resultData, resultHeaders)
            if errorCode == 200 then
                SaveResourceFile(resourceName, fileName, resultData, -1)
                filesDownloaded = filesDownloaded + 1
                
                if filesDownloaded == #updateFiles then
                    print("^2[" .. resourceName .. "] Atualização finalizada para a versão " .. newVersion .. "!^7")
                    print("^3[" .. resourceName .. "] Reiniciando script em 5 segundos...^7")
                    SetTimeout(5000, function()
                        ExecuteCommand("restart " .. resourceName)
                    end)
                end
            else
                print("^1[" .. resourceName .. "] Falha ao baixar arquivo: " .. fileName .. " (Erro: " .. errorCode .. ")^7")
            end
        end, "GET")
    end
end

-- Inicia a verificação ao carregar o servidor
CreateThread(function()
    Wait(5000) -- Aguarda um pouco para o servidor estabilizar
    checkVersion()
end)

teste