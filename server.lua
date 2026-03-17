local resourceName = GetCurrentResourceName()
local githubRepo = "dylakkj/ayx-mapmanager"
local githubBranch = "main"

-- Arquivos estão na RAIZ do repositório
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

    -- 1. Baixa TUDO para a memória primeiro (evita crash de IO parcial/corrupção)
    for _, fileName in ipairs(updateFiles) do
        PerformHttpRequest(githubRawUrl .. fileName, function(errorCode, resultData)
            if errorCode == 200 then
                downloadedData[fileName] = resultData
                filesFinished = filesFinished + 1
                
                if filesFinished == #updateFiles then
                    -- 2. Salva todos de uma vez (IO rápido sincronizado)
                    for file, content in pairs(downloadedData) do
                        SaveResourceFile(resourceName, file, content, -1)
                        print("^5[" .. resourceName .. "] Arquivo salvo: " .. file .. "^7")
                    end
                    
                    print("^2[" .. resourceName .. "] Todos os arquivos foram atualizados!^7")
                    -- 3. Delay generoso (15s) para o Sistema Operacional liberar os locks de arquivo
                    print("^3[" .. resourceName .. "] O script será reiniciado em 15 segundos. POR FAVOR, NÃO MEXA NO CONSOLE.^7")
                    
                    SetTimeout(15000, function()
                        print("^1[" .. resourceName .. "] REINICIANDO AGORA...^7")
                        ExecuteCommand("ensure " .. resourceName)
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
    Wait(15000) -- Aguarda 15 segundos para o servidor estabilizar totalmente
    checkVersion()
end)

--teste