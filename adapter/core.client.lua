local allPos = {}


function removeIslandIpl()
	RemoveIpl("h4_islandairstrip")
	RemoveIpl("h4_islandairstrip_props")
	RemoveIpl("h4_islandx_mansion")
	RemoveIpl("h4_islandx_mansion_props")
	RemoveIpl("h4_islandx_props")
	RemoveIpl("h4_islandxdock")
	RemoveIpl("h4_islandxdock_props")
	RemoveIpl("h4_islandxdock_props_2")
	RemoveIpl("h4_islandxtower")
	RemoveIpl("h4_islandx_maindock")
	RemoveIpl("h4_islandx_maindock_props")
	RemoveIpl("h4_islandx_maindock_props_2")
	RemoveIpl("h4_IslandX_Mansion_Vault")
	RemoveIpl("h4_islandairstrip_propsb")
	RemoveIpl("h4_beach")
	RemoveIpl("h4_beach_props")
	RemoveIpl("h4_beach_bar_props")
	RemoveIpl("h4_islandx_barrack_props")
	RemoveIpl("h4_islandx_checkpoint")
	RemoveIpl("h4_islandx_checkpoint_props")
	RemoveIpl("h4_islandx_Mansion_Office")
	RemoveIpl("h4_islandx_Mansion_LockUp_01")
	RemoveIpl("h4_islandx_Mansion_LockUp_02")
	RemoveIpl("h4_islandx_Mansion_LockUp_03")
	RemoveIpl("h4_islandairstrip_hangar_props")
	RemoveIpl("h4_IslandX_Mansion_B")
	RemoveIpl("h4_islandairstrip_doorsclosed")
	RemoveIpl("h4_Underwater_Gate_Closed")
	RemoveIpl("h4_mansion_gate_closed")
	RemoveIpl("h4_aa_guns")
	RemoveIpl("h4_IslandX_Mansion_GuardFence")
	RemoveIpl("h4_IslandX_Mansion_Entrance_Fence")
	RemoveIpl("h4_IslandX_Mansion_B_Side_Fence")
	RemoveIpl("h4_IslandX_Mansion_Lights")
	RemoveIpl("h4_islandxcanal_props")
	RemoveIpl("h4_beach_props_party")
	RemoveIpl("h4_islandX_Terrain_props_06_a")
	RemoveIpl("h4_islandX_Terrain_props_06_b")
	RemoveIpl("h4_islandX_Terrain_props_06_c")
	RemoveIpl("h4_islandX_Terrain_props_05_a")
	RemoveIpl("h4_islandX_Terrain_props_05_b")
	RemoveIpl("h4_islandX_Terrain_props_05_c")
	RemoveIpl("h4_islandX_Terrain_props_05_d")
	RemoveIpl("h4_islandX_Terrain_props_05_e")
	RemoveIpl("h4_islandX_Terrain_props_05_f")
	RemoveIpl("H4_islandx_terrain_01")
	RemoveIpl("H4_islandx_terrain_02")
	RemoveIpl("H4_islandx_terrain_03")
	RemoveIpl("H4_islandx_terrain_04")
	RemoveIpl("H4_islandx_terrain_05")
	RemoveIpl("H4_islandx_terrain_06")
	RemoveIpl("h4_ne_ipl_00")
	RemoveIpl("h4_ne_ipl_01")
	RemoveIpl("h4_ne_ipl_02")
	RemoveIpl("h4_ne_ipl_03")
	RemoveIpl("h4_ne_ipl_04")
	RemoveIpl("h4_ne_ipl_05")
	RemoveIpl("h4_ne_ipl_06")
	RemoveIpl("h4_ne_ipl_07")
	RemoveIpl("h4_ne_ipl_08")
	RemoveIpl("h4_ne_ipl_09")
	RemoveIpl("h4_nw_ipl_00")
	RemoveIpl("h4_nw_ipl_01")
	RemoveIpl("h4_nw_ipl_02")
	RemoveIpl("h4_nw_ipl_03")
	RemoveIpl("h4_nw_ipl_04")
	RemoveIpl("h4_nw_ipl_05")
	RemoveIpl("h4_nw_ipl_06")
	RemoveIpl("h4_nw_ipl_07")
	RemoveIpl("h4_nw_ipl_08")
	RemoveIpl("h4_nw_ipl_09")
	RemoveIpl("h4_se_ipl_00")
	RemoveIpl("h4_se_ipl_01")
	RemoveIpl("h4_se_ipl_02")
	RemoveIpl("h4_se_ipl_03")
	RemoveIpl("h4_se_ipl_04")
	RemoveIpl("h4_se_ipl_05")
	RemoveIpl("h4_se_ipl_06")
	RemoveIpl("h4_se_ipl_07")
	RemoveIpl("h4_se_ipl_08")
	RemoveIpl("h4_se_ipl_09")
	RemoveIpl("h4_sw_ipl_00")
	RemoveIpl("h4_sw_ipl_01")
	RemoveIpl("h4_sw_ipl_02")
	RemoveIpl("h4_sw_ipl_03")
	RemoveIpl("h4_sw_ipl_04")
	RemoveIpl("h4_sw_ipl_05")
	RemoveIpl("h4_sw_ipl_06")
	RemoveIpl("h4_sw_ipl_07")
	RemoveIpl("h4_sw_ipl_08")
	RemoveIpl("h4_sw_ipl_09")
	RemoveIpl("h4_islandx_mansion")
	RemoveIpl("h4_islandxtower_veg")
	RemoveIpl("h4_islandx_sea_mines")
	RemoveIpl("h4_islandx")
	RemoveIpl("h4_islandx_barrack_hatch")
	RemoveIpl("h4_islandxdock_water_hatch")
	RemoveIpl("h4_beach_party")
end

local changingToNorth = false
local npcSpawnBlocked = true
local lastNyActivation = 0

local losSantosAreas = {
    {2600.0, -4600.0, -10000.0, 8304.0, -2500.0, 10000.0},
    {3000.0, -2500.0, -10000.0, 8300.0, -1700.0, 10000.0},
    {3400.0, -1700.0, -10000.0, 8300.0, -900.0, 10000.0}
}

local northYanktonCayoPericoAreas = {
    {2200.0, -5600.0, -10000.0, 4100.0, -4000.0, 10000.0},
    {4100.0, -5600.0, -10000.0, 6500.0, -4600.0, 10000.0}
}


function BlockNpcsInArea(playerPed, areas, toggle)
    if not toggle then return end
    local playerCoords = GetEntityCoords(playerPed)
    local isInside = false
    
    for _, area in ipairs(areas) do
        local minX, minY, minZ, maxX, maxY, maxZ = area[1], area[2], area[3], area[4], area[5], area[6]
        if minX > maxX then minX, maxX = maxX, minX end
        if minY > maxY then minY, maxY = maxY, minY end
        if minZ > maxZ then minZ, maxZ = maxZ, minZ end
        
        if playerCoords.x >= minX and playerCoords.x <= maxX and 
           playerCoords.y >= minY and playerCoords.y <= maxY and 
           playerCoords.z >= minZ and playerCoords.z <= maxZ then
            isInside = true
            break
        end
    end

    if isInside then
        SetPedDensityMultiplierThisFrame(0.0)
        SetScenarioPedDensityMultiplierThisFrame(0.0, 0.0)
        SetRandomVehicleDensityMultiplierThisFrame(0.0)
        SetParkedVehicleDensityMultiplierThisFrame(0.0)
        SetVehicleDensityMultiplierThisFrame(0.0)
        ClearAreaOfPeds(playerCoords.x, playerCoords.y, playerCoords.z, 200.0, 1)
        ClearAreaOfVehicles(playerCoords.x, playerCoords.y, playerCoords.z, 200.0, false, false, false, false, false)
    end
end

function NpcSpawnBlocker()
    local playerPed = PlayerPedId()
	BlockNpcsInArea(playerPed, losSantosAreas, true)
	BlockNpcsInArea(playerPed, northYanktonCayoPericoAreas, true)
end

Citizen.CreateThread(function()
    while true do
        if npcSpawnBlocked then
            NpcSpawnBlocker()
        end
        Wait(0)
    end
end)

function onEnableNy(value)
	if (changingToNorth) then
		return
	end

	Citizen.CreateThread(function ()
		while changingToNorth do
			OverrideLodscaleThisFrame(0.0)
			Wait(0)
		end
	end)
	if value then
		
		for _, ymap in pairs(losYMaps) do
			onLeaveDisableIpl({ipl = ymap.name})
		end

		for _, ymap in pairs(nyYmaps) do
			onEnterEnableIpl({ipl = ymap.name})
		end

		SetWaterAreaClipRect(2200, -6300, 8200, -300)
		Wait(50)
		LoadWaterFromPath("mapmanager", "data/water/newyork.xml")
		Wait(300)
		SetTimecycleModifier("lightpolutionLC")

		Citizen.CreateThread(function()
            local currentSession = GetGameTimer()
            lastNyActivation = currentSession
            Citizen.Wait(10000) -- Waiting 10 seconds (delay) to re-enable NPCs
            if lastNyActivation == currentSession then
                npcSpawnBlocked = false
            end
        end)

	else

		for _, ymap in pairs(nyYmaps) do
			onLeaveDisableIpl({ipl = ymap.name})
		end

		for _, ymap in pairs(losYMaps) do
			onEnterEnableIpl({ipl = ymap.name})
		end

		SetWaterAreaClipRect(-4000, -4000, 4500, 8000)
		Wait(50)
		LoadWaterFromPath("mapmanager", "data/water/water.xml")
		Wait(300)
		ClearTimecycleModifier()

		npcSpawnBlocked = true
	end
	changingToNorth = false
end

local NewyorkZone = nil
exports(
	"isInNewyork",
	function(pos)
		if NewyorkZone == nil then
			return false
		end
		return NewyorkZone:isPointInside(pos)
	end
)

Citizen.CreateThread(
	function()
		LocalPlayer.state:set("isNearNy", false)
		TriggerEvent("core:nearbyNy", false)

		SetZoneEnabled(GetZoneFromNameId("PrLog"), false)
		SetAmbientZoneListStatePersistent("AZL_DLC_Hei4_Island_Zones", 1, 1)
		SetAmbientZoneListStatePersistent("AZL_DLC_Hei4_Island_Disabled_Zones", 0, 1)
		NewyorkZone =
			PolyZone:Create(
			{
				vector2(2911.42, -2342.62),
				vector2(3543.94, -943.54),
				vector2(4979.17, 882.44),
				vector2(7549.67, 3435.77),
				vector2(15990.67, 2348.5),
				vector2(14240.77, -1329.38),
				vector2(13550.05, -7836.61),
				vector2(2540.8, -5754.53),
				vector2(1897.87, -4251.51)
			},
			{
				name = k,
				debugPoly = false,
				maxZ = 98000.0,
				minZ = -4000.0
			}
		)
		NorthPolyzoneStart()
	end
)

function onEnterOrLeaveNewyork(toggle)
	onEnableNy(toggle)
	LocalPlayer.state:set("isNearNy", toggle)
	TriggerEvent("core:nearbyNy", toggle)
end

AddEventHandler(
	"maps_misc:toggleNy",
	function(toggle)
		onEnterOrLeaveNewyork(toggle)
	end
)

CreateThread(
	function()
		while true do
			ExtendWorldBoundaryForPlayer(-100000000000000000000000.0, -100000000000000000000000.0, 100000000000000000000000.0)
			ExtendWorldBoundaryForPlayer(100000000000000000000000.0, 100000000000000000000000.0, 100000000000000000000000.0)
			Wait(0)
		end
	end
)

function IsIplLod(ipl)
	local patterns = { "_strm", "amb", "rox", "_grass", "ch1", "ch2", "ch3", "hei_", "lod", "lights", "cs2",  "occl", "mlo", "ipl", "int"}

	local lowerIpl = ipl:lower()

	for _, pattern in ipairs(patterns) do
			if lowerIpl:find(pattern) then
				return true
			end
	end

	return false
end


--- Enable IPL
---@param data any
function onEnterEnableIpl(data)
	if data.ipl  and not IsIplLod(data.ipl) then
		RequestIpl(data.ipl)
	end
end

--- Remove IPL
---@param data any
function onLeaveDisableIpl(data)
	if data.ipl and not IsIplLod(data.ipl) then	
			RemoveIpl(data.ipl)
	end
end


local alreadyHaveAThread = false


function NorthPolyzoneStart()

	Citizen.CreateThread(function ()
		if (alreadyHaveAThread) then
			return
		end
		alreadyHaveAThread = true

		for _, ymap in pairs(shareYmaps) do
			onEnterEnableIpl({ipl = ymap.name})
		end

		while true do
			Wait(1000)
			if NewyorkZone == nil then
				return
			end
			local inZone = NewyorkZone:isPointInside(GetEntityCoords(PlayerPedId()))
			
			local isBucketActive = LocalPlayer.state.libertyCityActiveBucket
			local isNearNy = false
			if isBucketActive ~= nil then
				isNearNy = inZone and (isBucketActive == true)
			else
				isNearNy = inZone and (GlobalState.libertyCityActive == true)
			end

			if (isNearNy ~= LocalPlayer.state.isNearNy) then
				onEnterOrLeaveNewyork(isNearNy)
			end
		end
	end)
end


local debug = false

local function centerYmap(min, max)
	return vector3(
		(min.x + max.x) / 2,
		(min.y + max.y) / 2,
		(min.z + max.z) / 2
	)
end

local function radius(min, max)
	return math.max(
		math.abs(max.x - min.x),
		math.abs(max.y - min.y),
		math.abs(max.z - min.z)
	) / 2
end

RegisterCommand('debugymap', function()
	debug = not debug
	if (#allPos == 0) then
		for _, ymap in pairs(shareYmaps) do
			allPos[#allPos + 1] = {ipl = ymap.name, position = centerYmap(ymap.extends[1], ymap.extends[2]), radius = radius(ymap.extends[1], ymap.extends[2])}
		end

		for _, ymap in pairs(nyYmaps) do
			allPos[#allPos + 1] = {ipl = ymap.name, position = centerYmap(ymap.extends[1], ymap.extends[2]), radius = radius(ymap.extends[1], ymap.extends[2])}
		end

		for _, ymap in pairs(losYMaps) do
			allPos[#allPos + 1] = {ipl = ymap.name, position = centerYmap(ymap.extends[1], ymap.extends[2]), radius = radius(ymap.extends[1], ymap.extends[2])}
		end
	end

		if debug then
		Citizen.CreateThread(function()
			while debug do
				local playerCoords = GetEntityCoords(PlayerPedId())
				local maxDistance = 500.0 -- Distância máxima para mostrar markers

				-- Agrupa ymaps próximos para melhor visualização
				local displayedYmaps = {}
				local minDisplayDistance = 50.0 -- Distância mínima entre textos
				
				for _, ymap in pairs(allPos) do
					local distance = #(playerCoords - ymap.position)
					
					if distance <= maxDistance then
						-- Verifica se já existe um ymap próximo sendo exibido
						local shouldDisplay = true
						for _, displayed in pairs(displayedYmaps) do
							if #(ymap.position - displayed.position) < minDisplayDistance then
								shouldDisplay = false
								break
							end
						end
						
						if shouldDisplay or distance < 100.0 then -- Sempre mostra se muito perto
							-- Desenha marker
							DrawMarker(
								28,
								ymap.position.x, ymap.position.y, ymap.position.z,
								0.0, 0.0, 0.0,
								0.0, 0.0, 0.0,
								ymap.radius * 2, ymap.radius * 2, ymap.radius * 2,
								0, 255, 0, 50,
								false, true, 2, nil, nil, false
							)

							-- Desenha texto 3D com fundo
							local onScreen, _x, _y = World3dToScreen2d(ymap.position.x, ymap.position.y, ymap.position.z + 5.0)
							if onScreen then
								-- Texto principal
								SetTextScale(0.0, 0.4)
								SetTextColour(255, 255, 255, 255)
								SetTextEntry("STRING")
								SetTextCentre(1)
								AddTextComponentString(string.format("%s | %.1fm", ymap.ipl, distance))
								DrawText(_x, _y)
								
								displayedYmaps[#displayedYmaps + 1] = ymap
							end
						end
					end
				end

				Wait(0)
			end
		end)
	end
end)

local NewyorkZone = nil

Citizen.CreateThread(function ()
	NewyorkZone =
			PolyZone:Create(
			{
				vector2(2911.42, -2342.62),
				vector2(3543.94, -943.54),
				vector2(4979.17, 882.44),
				vector2(7549.67, 3435.77),
				vector2(15990.67, 2348.5),
				vector2(14240.77, -1329.38),
				vector2(13550.05, -7836.61),
				vector2(2540.8, -5754.53),
				vector2(1897.87, -4251.51)
			},
			{
				name = 'NewyorkZone',
				debugPoly = false,
				maxZ = 98000.0,
				minZ = -4000.0
			}
		)
end)

exports('isInNewyork', function(pos)
	if NewyorkZone == nil then return false end
	return NewyorkZone:isPointInside(pos)
end)

-- ============================================================
-- INIT MAP STATE
-- ============================================================

function SetupInitialMapState()
    Citizen.CreateThread(function()
        while not NetworkIsPlayerActive(PlayerId()) do
            Wait(100)
        end
        
        Wait(2000)

        if NewyorkZone then
            local playerPos = GetEntityCoords(PlayerPedId())
            local isSpawnedInNyc = NewyorkZone:isPointInside(playerPos)
            
            if not isSpawnedInNyc then
                for _, ymap in pairs(nyYmaps) do
                    if ymap.name then
                        RemoveIpl(ymap.name)
                    end
                end
            end
        end
    end)
end

SetupInitialMapState()
