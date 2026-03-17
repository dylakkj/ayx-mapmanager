-- Lista completa de IPLs do mapa
local roxwood_ipls = {

}

-- ========================================
-- FUNÇÕES PRINCIPAIS
-- ========================================

local function manageROXIPLs(enable)
    if enable then
        TriggerEvent("lod:client:reloadMaps")
    end
    
    for _, iplName in pairs(roxwood_ipls) do
        if not enable then
            if IsIplActive(iplName) then
                RemoveIpl(iplName)
            end
        end
    end
end

-- Função para remover IPLs do Cayo Perico
local function removeCayoPericoIPLs()   
    local cayoIPLs = {
        -- Aeroporto da Ilha
        "h4_islandairstrip", "h4_islandairstrip_props", "h4_islandairstrip_propsb",
        "h4_islandairstrip_hangar_props", "h4_islandairstrip_doorsclosed",
        
        -- Mansão
        "h4_islandx_mansion", "h4_islandx_mansion_props", "h4_IslandX_Mansion_Vault",
        "h4_islandx_Mansion_Office", "h4_islandx_Mansion_LockUp_01", "h4_islandx_Mansion_LockUp_02",
        "h4_islandx_Mansion_LockUp_03", "h4_IslandX_Mansion_B", "h4_IslandX_Mansion_GuardFence",
        "h4_IslandX_Mansion_Entrance_Fence", "h4_IslandX_Mansion_B_Side_Fence", "h4_IslandX_Mansion_Lights",
        
        -- Docas
        "h4_islandxdock", "h4_islandxdock_props", "h4_islandxdock_props_2",
        "h4_islandx_maindock", "h4_islandx_maindock_props", "h4_islandx_maindock_props_2",
        "h4_islandxdock_water_hatch",
        
        -- Torre e Props
        "h4_islandxtower", "h4_islandxtower_veg", "h4_islandx_props",
        
        -- Praia
        "h4_beach", "h4_beach_props", "h4_beach_bar_props", "h4_beach_props_party", "h4_beach_party",
        
        -- Quartel e Checkpoint
        "h4_islandx_barrack_props", "h4_islandx_barrack_hatch",
        "h4_islandx_checkpoint", "h4_islandx_checkpoint_props",
        
        -- Portões e Cercas
        "h4_Underwater_Gate_Closed", "h4_mansion_gate_closed",
        
        -- Armas AA e Canal
        "h4_aa_guns", "h4_islandxcanal_props",
        
        -- Terreno e Minas
        "h4_islandx_sea_mines", "h4_islandx",
        
        -- Terrenos (01-06)
        "H4_islandx_terrain_01", "H4_islandx_terrain_02", "H4_islandx_terrain_03",
        "H4_islandx_terrain_04", "H4_islandx_terrain_05", "H4_islandx_terrain_06",
        
        -- Props do Terreno
        "h4_islandX_Terrain_props_06_a", "h4_islandX_Terrain_props_06_b", "h4_islandX_Terrain_props_06_c",
        "h4_islandX_Terrain_props_05_a", "h4_islandX_Terrain_props_05_b", "h4_islandX_Terrain_props_05_c",
        "h4_islandX_Terrain_props_05_d", "h4_islandX_Terrain_props_05_e", "h4_islandX_Terrain_props_05_f",
        
        -- IPLs Direcionais (NE, NW, SE, SW)
        "h4_ne_ipl_00", "h4_ne_ipl_01", "h4_ne_ipl_02", "h4_ne_ipl_03", "h4_ne_ipl_04",
        "h4_ne_ipl_05", "h4_ne_ipl_06", "h4_ne_ipl_07", "h4_ne_ipl_08", "h4_ne_ipl_09",
        
        "h4_nw_ipl_00", "h4_nw_ipl_01", "h4_nw_ipl_02", "h4_nw_ipl_03", "h4_nw_ipl_04",
        "h4_nw_ipl_05", "h4_nw_ipl_06", "h4_nw_ipl_07", "h4_nw_ipl_08", "h4_nw_ipl_09",
        
        "h4_se_ipl_00", "h4_se_ipl_01", "h4_se_ipl_02", "h4_se_ipl_03", "h4_se_ipl_04",
        "h4_se_ipl_05", "h4_se_ipl_06", "h4_se_ipl_07", "h4_se_ipl_08", "h4_se_ipl_09",
        
        "h4_sw_ipl_00", "h4_sw_ipl_01", "h4_sw_ipl_02", "h4_sw_ipl_03", "h4_sw_ipl_04",
        "h4_sw_ipl_05", "h4_sw_ipl_06", "h4_sw_ipl_07", "h4_sw_ipl_08", "h4_sw_ipl_09"
    }
    
    for _, iplName in pairs(cayoIPLs) do
        RemoveIpl(iplName)
    end
end

-- ========================================
-- VARIÁVEIS GLOBAIS
-- ========================================

local roxSpawnPoint = vector3(5583.06, -2988.54, 112.17)
local isNearROXC = false
local isLoading = true
local roxZone = nil

-- ========================================
-- FUNÇÃO PRINCIPAL DE CONTROLE
-- ========================================

local function toggleROXMap(enable)
    if enable then
        isNearROXC = true
        
        Citizen.SetTimeout(50, function()
            --[[ SetWaterAreaClipRect(-4000, -4000, 4500, 8000)
            LoadWaterFromPath("cfx-hype-maps", "water.xml") ]]
        end)
    else
        isNearROXC = false
        
        
        Citizen.SetTimeout(50, function()
            manageROXIPLs(false)
            --[[ SetWaterAreaClipRect(-4000, -4000, 4500, 8000)
            LoadWaterFromPath("cfx-ghsxth-mapmanager", "data/water/lossantos.xml") ]]
        end)
    end
    
    isLoading = false
end

-- ========================================
-- EXPORTS
-- ========================================

exports("isInROXc", function(coords)
    if roxZone == nil then
        return false
    end
    return roxZone:isPointInside(coords)
end)

-- ========================================
-- THREAD PRINCIPAL
-- ========================================

Citizen.CreateThread(function()
    -- Configurações iniciais
    LocalPlayer.state:set("isNearROX", false)
    TriggerEvent("core:nearbyRox", false)
    
    -- Desabilita zona do Cayo Perico
    SetZoneEnabled(GetZoneFromNameId("PrLog"), false)
    SetAmbientZoneListStatePersistent("AZL_DLC_Hei4_Island_Zones", 1, 1)
    SetAmbientZoneListStatePersistent("AZL_DLC_Hei4_Island_Disabled_Zones", 0, 1)
    
    roxZone = PolyZone:Create({
        vector2(3524.34, 5164),
        vector2(3266.72, 5110.33),
        vector2(3192.23, 5095.27),
        vector2(3131.45, 5072.1),
        vector2(3052.52, 5064.44),
        vector2(2965.23, 5066.3),
        vector2(2895.69, 5057.12),
        vector2(2846.44, 5034.14),
        vector2(2422.67, 4608.9),
        vector2(2475.89, 4509.75),
        vector2(2478.46, 4418.56),
        vector2(2441.97, 4284.65),
        vector2(2457.02, 4185.12),
        vector2(2490.43, 4137.08),
        vector2(2500.68, 4124.95),
        vector2(2436.86, 3992.75),
        vector2(2342.72, 3892.7),
        vector2(2279.29, 3852.93),
        vector2(1627.77, 3488.96),
        vector2(1262.59, 3542.18),
        vector2(554.77, 3512.4),
        vector2(340.41, 3457.85),
        vector2(263.9, 3407.65),
        vector2(171.6, 3408.42),
        vector2(96.04, 3450.73),
        vector2(108.93, 3569.22),
        vector2(-14.5, 3611.12),
        vector2(-143.69, 3651.91),
        vector2(-209.72, 3829.29),
        vector2(-224.24, 3906.92),
        vector2(-220.64, 4019.15),
        vector2(-213.64, 4161.73),
        vector2(-761.38, 4410.07),
        vector2(-1593.26, 4352.43),
        vector2(-1984.47, 4492.53),
        vector2(-4313.13, 5814.11),
        vector2(-4271.32, 7474.75),
        vector2(-5772.11, 7222.85),
        vector2(-6538.17, 8143.29),
        vector2(-6091.75, 8720.79),
        vector2(-4375.67, 9850.56),
        vector2(-2800, 9324.16),
        vector2(-1488.37, 9788.45),
        vector2(-350.89, 9048.86),
        vector2(1174.65, 6826.16),
        vector2(2841.54, 6932.61),
        vector2(3771.2, 5657.59),
    }, {
        name = "Roxwood",
        debugPoly = false,
        maxZ = 98000.0,
        minZ = -4000.0
    })
    
    toggleROXMap(false)
    
    while true do
        Wait(1000)
        
        if roxZone == nil then
            return
        end
        
        local playerCoords = GetEntityCoords(PlayerPedId())
        local isInsideROX = roxZone:isPointInside(playerCoords)
        
        if isInsideROX ~= LocalPlayer.state.isNearROX then
            onEnterOrLeaveRoxwood(isInsideROX)
        end
    end
end)

-- ========================================
-- FUNÇÕES DE EVENTO
-- ========================================

function onEnterOrLeaveRoxwood(isInside)
    toggleROXMap(isInside)
    LocalPlayer.state:set("isNearROX", isInside)
    TriggerEvent("core:nearbyRox", isInside)
    
    if isInside then
        print("^2[MAPMANAGER]^7 Player state update to Roxwood.")
    else
        print("^3[MAPMANAGER]^7 Player state update to Los Santos.")
    end
end

-- Event handler para toggle manual
AddEventHandler("maps:toggleRox", function(enable)
    onEnterOrLeaveRoxwood(enable)
end)

-- ========================================
-- EXTENSÃO DOS LIMITES DO MUNDO
-- ========================================

CreateThread(function()
    while true do
        ExtendWorldBoundaryForPlayer(-99999999999999999.0, -99999999999999999.0, 99999999999999999.0)
        ExtendWorldBoundaryForPlayer(99999999999999999.0, 99999999999999999.0, 99999999999999999.0)
        Wait(0)
    end
end)

print("^2[MAPMANAGER]^7 System loaded!")