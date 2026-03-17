local zones = {}
local debugEnabled = false
local debugYmapEnabled = false
local isNearROX = LocalPlayer.state.isNearROX or false

local allYmaps = {}
local losAngelesYmaps = {}
local newYorkYmaps = {}

local defaultRadius = 700
local debugColor = {255, 0, 0, 100}

-- ========================================
-- FUNÇÕES UTILITÁRIAS
-- ========================================

-- Pausa/despausa uma zona específica
local function pauseZone(zoneName, isPaused)
    if zones[zoneName] then
        zones[zoneName]:setPaused(isPaused)
    end
end

-- Calcula o ponto médio entre duas posições
local function calculateMidpoint(pos1, pos2)
    return vector3(
        (pos1[1] + pos2[1]) / 2,
        (pos1[2] + pos2[2]) / 2,
        (pos1[3] + pos2[3]) / 2
    )
end

-- Converte dados de YMap para formato de zona
local function convertYmapToZone(ymapData)
    ymapData.center = calculateMidpoint(ymapData.extends[1], ymapData.extends[2])
    ymapData.size = #(ymapData.extends[1] - ymapData.extends[2])
    
    return {
        position = ymapData.center,
        radius = ymapData.size,
        ipl = ymapData.name
    }
end

-- ========================================
-- FUNÇÕES DE GERENCIAMENTO DE IPL
-- ========================================

-- Estado de suspensão pelo NoClip e Altitude
local isManagerFrozen = false
local isHighAltitudeActive = false
local globalLoaderActive = false

local function TriggerGlobalLoader()
    if (isManagerFrozen or isHighAltitudeActive) and not globalLoaderActive then
        globalLoaderActive = true
        Citizen.CreateThread(function()
            local toggleCount = 0
            while isManagerFrozen or isHighAltitudeActive do
                Citizen.Wait(2000) -- Roda a cada 2 seg pra atualizar sem espancar a thread principal
                
                for _, ymapData in pairs(allYmaps) do
                    -- Solicita TODOS os mapas para não ter buracos de visão no NoClip e Voo Alto
                    if ymapData.ipl and not IsIplActive(ymapData.ipl) then
                        RequestIpl(ymapData.ipl)
                        toggleCount = toggleCount + 1
                        if toggleCount % 15 == 0 then Wait(0) end
                    end
                end
            end
            
            -- Quando desligar os dois modos, dá um refresh final massivo na área de pouso
            globalLoaderActive = false
            
            -- FORÇA A RENDERIZAÇÃO IMEDIATA DA ÁREA DE POUSO PRA NÃO CAIR NO LIMBO
            local landingCoords = GetEntityCoords(PlayerPedId())
            local landingToggleCount = 0
            
            for _, ymapData in pairs(allYmaps) do
                local distance = #(ymapData.position - landingCoords)
                -- Se a distância ao ponto de pouso estiver dentro de uma área extrema de visão:
                if distance < (ymapData.radius + 4000.0) then 
                    if ymapData.ipl and not IsIplActive(ymapData.ipl) then
                        RequestIpl(ymapData.ipl)
                        landingToggleCount = landingToggleCount + 1
                        if landingToggleCount % 15 == 0 then Wait(0) end
                    end
                end
            end
            
            -- Retorna o controle para o PolyZone clássico avaliar os unloads
            Wait(1000)
            local finalState = LocalPlayer.state.isNearROX or false
            onChangeRoxState(finalState)
        end)
    end
end

RegisterNetEvent("ayx-mapmanager:freezeSystem", function(state)
    isManagerFrozen = state
    if isManagerFrozen then
        TriggerGlobalLoader()
    end
end)

-- Carrega um IPL se não estiver ativo
local function loadIPL(data)
    if data.ipl then
        if not IsIplActive(data.ipl) then
            RequestIpl(data.ipl)
        end
    end
end

-- Remove um IPL se estiver ativo
local function removeIPL(data)
    if data.ipl then
        if IsIplActive(data.ipl) then
            RemoveIpl(data.ipl)
        end
    end
end

-- Carrega IPLs de uma lista de zonas
local function loadZoneIPLs(zoneList)
    if zoneList then
        for _, zone in pairs(zoneList) do
            if zone.data then
                loadIPL(zone.data)
            end
        end
    end
end

-- Remove IPLs de uma lista de zonas
local function removeZoneIPLs(zoneList)
    if zoneList then
        for _, zone in pairs(zoneList) do
            if zone.data then
                removeIPL(zone.data)
            end
        end
    end
end

-- ========================================
-- SISTEMA DE ZONAS
-- ========================================

-- Cria zonas de detecção para YMaps
local function createYmapZones(zoneName, ymapList, onEnterCallback, onExitCallback)
    -- Verifica se a zona já existe
    if zones[zoneName] then
        pauseZone(zoneName, false)
        return
    end
    
    local circleZones = {}
    local zoneList = {}
    
    -- Configurações específicas por tipo de zona
    local isROXZone = zoneName == "roxpoly"
    local isSharedZone = zoneName == "share"
    local isLAZone = zoneName == "lospoly"
    
    -- Cria zonas circulares para cada YMap
    for index, ymapData in pairs(ymapList) do
        local radius = ymapData.radius
        
        -- Ajusta raio para Los Angeles
        if isLAZone and radius < defaultRadius then
            radius = radius + defaultRadius
        end
        
        -- Exceção especial para um IPL específico
        if ymapList[index].ipl == "hei_ch1_01_strm_7" then
            radius = ymapList[index].radius
        end
        
        -- Cria zona circular
        local circleZone = CircleZone:Create(
            vector3(ymapData.position[1], ymapData.position[2], ymapData.position[3]),
            radius,
            {
                name = zoneName .. "_" .. index,
                data = ymapList[index],
                debugPoly = false,
                useZ = ymapData.useZ or (not debugEnabled and false),
                debugColor = ymapData.debugColor or debugColor
            }
        )
        
        circleZones[#circleZones + 1] = circleZone
        
        -- Previne freeze deixando a thread respirar a cada 50 áreas de mapa
        if #circleZones % 50 == 0 then
            Wait(0)
        end
    end
    
    -- Cria zona combinada
    local comboZone = ComboZone:Create(circleZones, {name = zoneName})
    zoneList = comboZone
    
    if not zoneList then
        return
    end
    
    -- Configura callbacks da zona
    zoneList:onPlayerInOutExhaustive(function(isPointInside, point, zone, insideZones, enteredZones)
        if isManagerFrozen or isHighAltitudeActive then return end -- IGNORA bloqueio se voando ou NoClip
        
        -- Callback de saída
        onExitCallback(enteredZones)
        
        if isROXZone then
            if not isNearROX and not isSharedZone then
                return
            end
        end
        
        if isLAZone then
            if isNearROX and not isSharedZone then
                return
            end
        end
        
        -- Callback de entrada
        onEnterCallback(insideZones)
    end, 1000)
    
    zones[zoneName] = zoneList
end

-- ========================================
-- SISTEMA DE REFRESH DE YMAPS
-- ========================================

-- Atualiza YMaps de uma cidade específica
function RefreshYmapsCity(pauseZoneName, activeZoneName, ymapList)
    Citizen.CreateThread(function()
        -- Pausa a zona especificada
        pauseZone(pauseZoneName, true)
        Wait(0)
        
        -- Cria nova zona ativa PRIMEIRO para já ter as bounderies corretas
        createYmapZones(activeZoneName, ymapList, loadZoneIPLs, removeZoneIPLs)
        
        -- Varre a cidade calculando o que está perto o suficiente para ser salvo
        local playerCoords = GetEntityCoords(PlayerPedId())
        local count = 0
        local safeIpls = {}
        
        for _, ymapData in pairs(ymapList) do
            local radius = ymapData.radius
            if activeZoneName == "lospoly" and radius < defaultRadius then
                radius = radius + defaultRadius
            end
            
            -- Exceções hardcoded legadas
            if ymapData.ipl == "hei_ch1_01_strm_7" then
                radius = ymapData.radius
            end
            
            local distance = #(ymapData.position - playerCoords)
            if distance < (radius + 200.0) then -- +200.0 de Threshold bônus pra segurança no popup
                safeIpls[ymapData.ipl] = true
                if not IsIplActive(ymapData.ipl) then
                    loadIPL({ipl = ymapData.ipl})
                end
            end
            
            count = count + 1
            if count % 25 == 0 then Wait(0) end
        end
        
        -- Verifica e limpa APENAS os mapas ativos longe do jogador (Wipe inteligente)
        local mapsToRemove = {}
        for _, ymapData in pairs(losAngelesYmaps) do
            if ymapData.ipl and IsIplActive(ymapData.ipl) and not safeIpls[ymapData.ipl] then
                mapsToRemove[ymapData.ipl] = true
            end
        end
        for _, ymapData in pairs(newYorkYmaps) do
            if ymapData.ipl and IsIplActive(ymapData.ipl) and not safeIpls[ymapData.ipl] then
                mapsToRemove[ymapData.ipl] = true
            end
        end
        
        count = 0
        for ipl, _ in pairs(mapsToRemove) do
            removeIPL({ipl = ipl})
            count = count + 1
            if count % 25 == 0 then Wait(0) end
        end
    end)
end

function onChangeRoxState(isInROX)
    if isInROX then
        RefreshYmapsCity("lospoly", "roxpoly", newYorkYmaps)
    else
        RefreshYmapsCity("roxpoly", "lospoly", losAngelesYmaps)
    end
end

-- ========================================
-- SISTEMA DE REGISTRO DE YMAPS
-- ========================================

-- Registra todos os YMaps no sistema
function RegisterYmaps()
    local count = 0
    -- Processa YMaps de Los Angeles
    for _, ymapData in pairs(losYmaps) do
        local zoneData = convertYmapToZone(ymapData)
        losAngelesYmaps[#losAngelesYmaps + 1] = zoneData
        allYmaps[#allYmaps + 1] = zoneData
        count = count + 1
        if count % 50 == 0 then Wait(0) end
    end
    
    -- Processa YMaps de New York
    for _, ymapData in pairs(roxYmaps) do
        local zoneData = convertYmapToZone(ymapData)
        newYorkYmaps[#newYorkYmaps + 1] = zoneData
        allYmaps[#allYmaps + 1] = zoneData
        count = count + 1
        if count % 50 == 0 then Wait(0) end
    end
    
    -- Processa YMaps compartilhados
    local sharedYmaps = {}
    for _, ymapData in pairs(shareYmaps) do
        local zoneData = convertYmapToZone(ymapData)
        sharedYmaps[#sharedYmaps + 1] = zoneData
        allYmaps[#allYmaps + 1] = zoneData
        count = count + 1
        if count % 50 == 0 then Wait(0) end
    end
    
    -- Cria zona para YMaps compartilhados
    createYmapZones("share", sharedYmaps, loadZoneIPLs, removeZoneIPLs)
end

-- Remove todos os IPLs ativos
function removeAllActiveIPLs()
    local count = 0
    -- Remove IPLs de Los Angeles
    for _, ymapData in pairs(losAngelesYmaps) do
        if ymapData.ipl and IsIplActive(ymapData.ipl) then
            removeIPL({ipl = ymapData.ipl})
        end
        count = count + 1
        if count % 50 == 0 then Wait(0) end
    end
    
    -- Remove IPLs de New York
    for _, ymapData in pairs(newYorkYmaps) do
        if ymapData.ipl and IsIplActive(ymapData.ipl) then
            removeIPL({ipl = ymapData.ipl})
        end
        count = count + 1
        if count % 50 == 0 then Wait(0) end
    end
end

-- ========================================
-- SISTEMA DE DEBUG
-- ========================================

-- Desenha texto 3D no mundo
local function draw3DText(x, y, z, text, color)
    SetTextScale(0.5, 0.5)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(color[1], color[2], color[3], 215)
    BeginTextCommandDisplayText("STRING")
    SetTextCentre(true)
    AddTextComponentSubstringPlayerName(text)
    SetDrawOrigin(x, y, z, 0)
    EndTextCommandDisplayText(0.0, 0.0)
    ClearDrawOrigin()
end

-- ========================================
-- COMANDOS DE DEBUG
-- ========================================

-- Comando para debug de distâncias
RegisterCommand("debugdist", function(source, args)
    debugEnabled = not debugEnabled
    
    Citizen.CreateThread(function()
        while debugEnabled do
            Citizen.Wait(0)
            
            local playerCoords = GetEntityCoords(PlayerPedId())
            
            for _, ymapData in pairs(allYmaps) do
                if IsIplActive(ymapData.ipl) then
                    local ymapPos = vector3(ymapData.position[1], ymapData.position[2], 0)
                    local playerPos = vector3(playerCoords.x, playerCoords.y, 0)
                    local distance = #(ymapPos - playerPos)
                    
                    if distance < 3000 then
                        -- Desenha marcador
                        DrawMarker(1, 
                            ymapData.position.x, ymapData.position.y, ymapData.position.z,
                            0, 0, 0, 0, 0, 0,
                            ymapData.radius * 2, ymapData.radius * 2, 800.0,
                            debugColor[1], debugColor[2], debugColor[3], debugColor[4],
                            false, false, 2, nil, nil, false
                        )
                        
                        -- Desenha texto
                        draw3DText(
                            ymapData.position.x, ymapData.position.y, ymapData.position.z + 2,
                            ymapData.ipl .. " - " .. ymapData.radius,
                            debugColor
                        )
                    end
                end
            end
        end
    end)
end, false)

-- Comando para debug de YMap específico
RegisterCommand("debugymap", function(source, args)
    debugYmapEnabled = not debugYmapEnabled
    local targetYmap = args[1]
    
    print("DebugYmap:", debugYmapEnabled, targetYmap)
    
    Citizen.CreateThread(function()
        while debugYmapEnabled do
            Citizen.Wait(0)
            
            for _, ymapData in pairs(allYmaps) do
                if targetYmap == ymapData.ipl then
                    -- Desenha marcador
                    DrawMarker(1,
                        ymapData.position.x, ymapData.position.y, ymapData.position.z,
                        0, 0, 0, 0, 0, 0,
                        ymapData.radius * 2, ymapData.radius * 2, 800.0,
                        debugColor[1], debugColor[2], debugColor[3], debugColor[4],
                        false, false, 2, nil, nil, false
                    )
                    
                    -- Desenha texto
                    draw3DText(
                        ymapData.position.x, ymapData.position.y, ymapData.position.z + 2,
                        ymapData.ipl .. " - " .. ymapData.radius,
                        debugColor
                    )
                end
            end
        end
    end)
end, false)

-- Comando para listar YMaps ativos
RegisterCommand("getactive", function(source, args)
    local activeYmaps = {}
    
    for _, ymapData in pairs(allYmaps) do
        if IsIplActive(ymapData.ipl) then
            activeYmaps[#activeYmaps + 1] = ymapData.ipl
        end
    end
    
    print("Active Ymaps: ", json.encode(activeYmaps))
end, false)

-- ========================================
-- INICIALIZAÇÃO
-- ========================================

AddEventHandler("onClientResourceStart", function(resourceName)
    if GetCurrentResourceName() ~= resourceName then
        return
    end
    
    Citizen.CreateThread(function()
        RegisterYmaps()
        
        local count = 0
        for _, ymapData in pairs(losYmaps) do
            removeIPL({ipl = ymapData.name})
            count = count + 1
            if count % 50 == 0 then Wait(0) end
        end
        
        for _, ymapData in pairs(roxYmaps) do
            removeIPL({ipl = ymapData.name})
            count = count + 1
            if count % 50 == 0 then Wait(0) end
        end
        
        Wait(0)
        
        local playerStateBag = "player:" .. GetPlayerServerId(PlayerId())
        AddStateBagChangeHandler("isNearROX", playerStateBag, function(bagName, key, value)
            isNearROX = value
            onChangeRoxState(isNearROX)
        end)
    local currentState = LocalPlayer.state.isNearROX or false
        onChangeRoxState(currentState)
    end)
    
    -- SISTEMA DE ALTITUDE / HELICOPTEROS, ETC...
    Citizen.CreateThread(function()
        local limitHeightZ = 60.0 -- Altura base para "voo"

        while true do
            Citizen.Wait(1000) -- Checa 1x por segundo para não pesar a CPU

            local ped = PlayerPedId()
            local coords = GetEntityCoords(ped)

            -- Se o jogador tá voando alto nos ares: ativa "Manager Frozen" autônomo.
            if coords.z > limitHeightZ and not isHighAltitudeActive then
                isHighAltitudeActive = true
                TriggerGlobalLoader()
            -- Se a altitude abaixou novamente, desativar
            elseif coords.z <= limitHeightZ and isHighAltitudeActive then
                isHighAltitudeActive = false
                -- A Global Thread irá desligar e engatilhar o fallback de Polyzone sozinha se o NoClip tambem não estiver ligado
            end
        end
    end)

    -- SISTEMA DE PRE-LOAD (CACHE) PARA EVITAR FREEZES
    Citizen.CreateThread(function()
        -- Aguarda o jogador conectar de fato no servidor
        while not NetworkIsSessionStarted() do
            Wait(100)
        end
        Wait(2000) -- Pequeno delay para a cidade inicial carregar
        
        print("^3[MAPMANAGER]^7 Pre-carregando texturas na cache para evitar travamentos...")
        
        local count = 0
        for _, ymapData in pairs(roxYmaps) do
            RequestIpl(ymapData.name)
            count = count + 1
            if count % 15 == 0 then
                Wait(0) -- Evita crash por excesso de processos na mesma frame
            end
        end
        
        print("^3[MAPMANAGER]^7 Mapas armazenados em cache. Aguardando processamento da engine...")
        Wait(15000) -- Deixa na memória ativamente por 15 segundos
        
        print("^2[MAPMANAGER]^7 Limpeza do cache feita! Retornando ao estado normal...")
        -- Atualiza os YMaps corretamente rodando novamente a função primária
        onChangeRoxState(isNearROX)
    end)
end)

print("^2[MAPMANAGER]^7 System loaded.")