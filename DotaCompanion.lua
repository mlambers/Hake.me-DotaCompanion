-----------------
-- Version 0.4 --
-----------------

local DotaCompanion = {}

--*** Menu ***--
DotaCompanion.optionEnable = Menu.AddOption({ "mlambers", "Dota Companion" }, "1. Enable.", "Enable/Disable this script.")
DotaCompanion.offsetX = Menu.AddOption({ "mlambers", "Dota Companion" }, "2. Menu x offset", "", 0, 500, 10)
DotaCompanion.offsetY = Menu.AddOption({"mlambers", "Dota Companion" }, "3. Menu y offset", "", 0, 500, 10)
DotaCompanion.size = Menu.AddOption({"mlambers", "Dota Companion" }, "4. Menu size", "", 1, 32, 1)
DotaCompanion.KeyShowHide = Menu.AddKeyOption({ "mlambers", "Dota Companion"}, "5. Key show/hide panel", Enum.ButtonCode.KEY_F)
--***********--

DotaCompanion.NeedInit = true
DotaCompanion.CanDraw = false

DotaCompanion.NextTick = 0
DotaCompanion.SecondSinceFirstLoad = 0
DotaCompanion.DoneLoadAll = false
DotaCompanion.OutsideGameReset = false

DotaCompanion.FontPlayerName = Renderer.LoadFont("Verdana", 20, Enum.FontWeight.EXTRABOLD)
DotaCompanion.FontTotalMatches = Renderer.LoadFont("Verdana", 17, Enum.FontWeight.NORMAL)
DotaCompanion.FontTotalMatches2 = Renderer.LoadFont("Tahoma", 10, Enum.FontWeight.EXTRABOLD)

DotaCompanion.StateShowButton = true

local ScreenWidth, ScreenHeight = nil, nil
local PlayerTable = {nil, nil, nil, nil, nil, nil, nil, nil, nil, nil}

local MathFunction = {}
MathFunction.Floor = math.floor
MathFunction.Ceil = math.ceil

local Assets = {}
Assets.Images = {}
Assets.PathMenu = "panorama/images/dota_plus/"
Assets.PathMenu2 = "panorama/images/control_icons/"
Assets.Path = "panorama/images/heroes/selection/"
Assets.DefaultWidthSize = 45
Assets.DefaultHeightSize = 55

local PlayerColor = {
	{51, 117, 255},
	{102, 255, 191},
	{191, 0, 191},
	{243, 240, 11},
	{255, 107, 0},
	{254, 134, 194},
	{161, 180, 71},
	{101, 217, 247},
	{0, 131, 33},
	{164, 105, 0}
}

local HeroesID = {
	"npc_dota_hero_antimage",
	"npc_dota_hero_axe",
	"npc_dota_hero_bane",
	"npc_dota_hero_bloodseeker",
	"npc_dota_hero_crystal_maiden",
	"npc_dota_hero_drow_ranger",
	"npc_dota_hero_earthshaker",
	"npc_dota_hero_juggernaut",
	"npc_dota_hero_mirana",
	"npc_dota_hero_morphling",
	"npc_dota_hero_nevermore",
	"npc_dota_hero_phantom_lancer",
	"npc_dota_hero_puck",
	"npc_dota_hero_pudge",
	"npc_dota_hero_razor",
	"npc_dota_hero_sand_king",
	"npc_dota_hero_storm_spirit",
	"npc_dota_hero_sven",
	"npc_dota_hero_tiny",
	"npc_dota_hero_vengefulspirit",
	"npc_dota_hero_windrunner",
	"npc_dota_hero_zuus",
	"npc_dota_hero_kunkka",
	nil,
	"npc_dota_hero_lina",
	"npc_dota_hero_lion",
	"npc_dota_hero_shadow_shaman",
	"npc_dota_hero_slardar",
	"npc_dota_hero_tidehunter",
	"npc_dota_hero_witch_doctor",
	"npc_dota_hero_lich",
	"npc_dota_hero_riki",
	"npc_dota_hero_enigma",
	"npc_dota_hero_tinker",
	"npc_dota_hero_sniper",
	"npc_dota_hero_necrolyte",
	"npc_dota_hero_warlock",
	"npc_dota_hero_beastmaster",
	"npc_dota_hero_queenofpain",
	"npc_dota_hero_venomancer",
	"npc_dota_hero_faceless_void",
	"npc_dota_hero_skeleton_king",
	"npc_dota_hero_death_prophet",
	"npc_dota_hero_phantom_assassin",
	"npc_dota_hero_pugna",
	"npc_dota_hero_templar_assassin",
	"npc_dota_hero_viper",
	"npc_dota_hero_luna",
	"npc_dota_hero_dragon_knight",
	"npc_dota_hero_dazzle",
	"npc_dota_hero_rattletrap",
	"npc_dota_hero_leshrac",
	"npc_dota_hero_furion",
	"npc_dota_hero_life_stealer",
	"npc_dota_hero_dark_seer",
	"npc_dota_hero_clinkz",
	"npc_dota_hero_omniknight",
	"npc_dota_hero_enchantress",
	"npc_dota_hero_huskar",
	"npc_dota_hero_night_stalker",
	"npc_dota_hero_broodmother",
	"npc_dota_hero_bounty_hunter",
	"npc_dota_hero_weaver",
	"npc_dota_hero_jakiro",
	"npc_dota_hero_batrider",
	"npc_dota_hero_chen",
	"npc_dota_hero_spectre",
	"npc_dota_hero_ancient_apparition",
	"npc_dota_hero_doom_bringer",
	"npc_dota_hero_ursa",
	"npc_dota_hero_spirit_breaker",
	"npc_dota_hero_gyrocopter",
	"npc_dota_hero_alchemist",
	"npc_dota_hero_invoker",
	"npc_dota_hero_silencer",
	"npc_dota_hero_obsidian_destroyer",
	"npc_dota_hero_lycan",
	"npc_dota_hero_brewmaster",
	"npc_dota_hero_shadow_demon",
	"npc_dota_hero_lone_druid",
	"npc_dota_hero_chaos_knight",
	"npc_dota_hero_meepo",
	"npc_dota_hero_treant",
	"npc_dota_hero_ogre_magi",
	"npc_dota_hero_undying",
	"npc_dota_hero_rubick",
	"npc_dota_hero_disruptor",
	"npc_dota_hero_nyx_assassin",
	"npc_dota_hero_naga_siren",
	"npc_dota_hero_keeper_of_the_light",
	"npc_dota_hero_wisp",
	"npc_dota_hero_visage",
	"npc_dota_hero_slark",
	"npc_dota_hero_medusa",
	"npc_dota_hero_troll_warlord",
	"npc_dota_hero_centaur",
	"npc_dota_hero_magnataur",
	"npc_dota_hero_shredder",
	"npc_dota_hero_bristleback",
	"npc_dota_hero_tusk",
	"npc_dota_hero_skywrath_mage",
	"npc_dota_hero_abaddon",
	"npc_dota_hero_elder_titan",
	"npc_dota_hero_legion_commander",
	"npc_dota_hero_techies",
	"npc_dota_hero_ember_spirit",
	"npc_dota_hero_earth_spirit",
	"npc_dota_hero_abyssal_underlord",
	"npc_dota_hero_terrorblade",
	"npc_dota_hero_phoenix",
	"npc_dota_hero_oracle",
	"npc_dota_hero_winter_wyvern",
	"npc_dota_hero_arc_warden",
	"npc_dota_hero_monkey_king",
	nil,
	nil,
	nil,
	nil,
	"npc_dota_hero_dark_willow",
	"npc_dota_hero_pangolier"
}


function DotaCompanion.OnScriptLoad()
	for k in pairs(Assets.Images) do
		Assets.Images[k] = nil
	end
	Assets.Images = {}
	
	for i = #PlayerTable, 1, -1 do
		PlayerTable[i] = nil
	end
	PlayerTable = {nil, nil, nil, nil, nil, nil, nil, nil, nil, nil}
	
	ScreenWidth, ScreenHeight = nil, nil
	DotaCompanion.NextTick = 0
	DotaCompanion.SecondSinceFirstLoad = 0
	DotaCompanion.DoneLoadAll = false
	DotaCompanion.OutsideGameReset = false
	DotaCompanion.StateShowButton = true
	DotaCompanion.CanDraw = false
	DotaCompanion.NeedInit = true
	Console.Print("DotaCompanion.OnScriptLoad()")
end

function DotaCompanion.OnGameStart()
	Console.Print("DotaCompanion.OnGameStart()")
end

function DotaCompanion.OnGameEnd()
	for k in pairs(Assets.Images) do
		Assets.Images[k] = nil
	end
	Assets.Images = {}
	
	for i = #PlayerTable, 1, -1 do
		PlayerTable[i] = nil
	end
	PlayerTable = {nil, nil, nil, nil, nil, nil, nil, nil, nil, nil}
	
	ScreenWidth, ScreenHeight = nil, nil
	DotaCompanion.NextTick = 0
	DotaCompanion.SecondSinceFirstLoad = 0
	DotaCompanion.DoneLoadAll = false
	DotaCompanion.OutsideGameReset = false
	
	DotaCompanion.StateShowButton = true
	DotaCompanion.CanDraw = false
	DotaCompanion.NeedInit = true
	Console.Print("DotaCompanion.OnGameEnd()")
end

function DotaCompanion.GetFriendsId(Input)
	local steam64 = tonumber(Input)
    local result = steam64 - 76561197960265728
    return result
end

function DotaCompanion.LoadImage(prefix, name, path)
	local imageHandle = Assets.Images[prefix .. name]

	if (imageHandle == nil) then
		
		imageHandle = Renderer.LoadImage(path .. name .. "_png.vtex_c")
		Assets.Images[prefix .. name] = imageHandle
		imageHandle = nil
	end
end

function DotaCompanion.LoadDire()
	for i = 1, Players.Count() do
		local EntityPlayer = Players.Get(i)
		if EntityPlayer and Entity.IsPlayer(EntityPlayer) and Player.GetPlayerData(EntityPlayer) and Player.GetPlayerData(EntityPlayer).valid == true and Player.GetPlayerID(EntityPlayer) > 4 then
			PlayerTable[Player.GetPlayerID(EntityPlayer) + 1] = {
				"Player " .. (Player.GetPlayerID(EntityPlayer) + 1),
				HTTP.NewConnection("https://api.stratz.com/api/v1/Player/" .. DotaCompanion.GetFriendsId(Player.GetPlayerData(EntityPlayer).steamid) .. "/behaviorChart?lobbyType=7&isParty=false"):AsyncRequest("GET"),
				false
			}
			--Console.Print(Player.GetPlayerID(EntityPlayer) .. " " .. Player.GetName(EntityPlayer) .. " Team num: " .. Entity.GetTeamNum(EntityPlayer))
		end
	end
end

function DotaCompanion.LoadRadiant()
	for i = 1, Players.Count() do
		local EntityPlayer = Players.Get(i)
		if EntityPlayer and Entity.IsPlayer(EntityPlayer) and Player.GetPlayerData(EntityPlayer) and Player.GetPlayerData(EntityPlayer).valid == true and Player.GetPlayerID(EntityPlayer) < 5 then
			PlayerTable[Player.GetPlayerID(EntityPlayer) + 1] = {
				"Player " .. (Player.GetPlayerID(EntityPlayer) + 1),
				HTTP.NewConnection("https://api.stratz.com/api/v1/Player/" .. DotaCompanion.GetFriendsId(Player.GetPlayerData(EntityPlayer).steamid) .. "/behaviorChart?lobbyType=7&isParty=false"):AsyncRequest("GET"),
				false
			}
			--Console.Print(Player.GetPlayerID(EntityPlayer) .. " " .. Player.GetName(EntityPlayer))
		end
	end
end

function DotaCompanion.OnDraw()
	-- Check if Player in a match or not
	if Engine.IsInGame() == false then 
		-- If outside match and need to reset variable
		if DotaCompanion.OutsideGameReset == true then
			for k in pairs(Assets.Images) do
				Assets.Images[k] = nil
			end
			Assets.Images = {}
			
			for i = #PlayerTable, 1, -1 do
				PlayerTable[i] = nil
			end
			PlayerTable = {nil, nil, nil, nil, nil}
			
			ScreenWidth, ScreenHeight = nil, nil
			DotaCompanion.NextTick = 0
			DotaCompanion.SecondSinceFirstLoad = 0
			DotaCompanion.DoneLoadAll = false
			DotaCompanion.StateShowButton = true
			DotaCompanion.CanDraw = false
			DotaCompanion.NeedInit = true
			DotaCompanion.OutsideGameReset = false
			Console.Print("DotaCompanion.OutsideGameReset()")
		end
	end
	
	if not Menu.IsEnabled(DotaCompanion.optionEnable) then return end
	if GameRules.GetGameState() < 2 then return end

	if DotaCompanion.NeedInit == true then
		local GetMyTeam = Entity.GetTeamNum(Players.GetLocal())
		--Console.Print(GetMyTeam)
		if GetMyTeam == 1 or GetMyTeam == 3 then -- If my team number equal 1, I'm spectator or I'm watching replay
			DotaCompanion.LoadRadiant()
		elseif GetMyTeam == 2 then
			DotaCompanion.LoadDire()
		end
		
		DotaCompanion.LoadImage("Menu_", "dotaplus_logo", Assets.PathMenu)
		DotaCompanion.LoadImage("Menu_", "quit", Assets.PathMenu2)
		
		ScreenWidth, ScreenHeight = Renderer.GetScreenSize()
		DotaCompanion.CanDraw = true
		DotaCompanion.OutsideGameReset = true
		DotaCompanion.SecondSinceFirstLoad = os.clock() + 5
		DotaCompanion.NeedInit = false
	end
	
	if DotaCompanion.CanDraw == true then
		local xDefault = MathFunction.Ceil(ScreenWidth * 0.18)
		local yDefault = MathFunction.Ceil(ScreenHeight * 0.05)
		
		if DotaCompanion.StateShowButton == true then
			Renderer.SetDrawColor(47, 44, 54, 255)
			Renderer.DrawFilledRect(xDefault, yDefault, 860, 600)
		end
		xDefault = xDefault + 10
		yDefault = yDefault + 10
		
		if DotaCompanion.DoneLoadAll == false and DotaCompanion.SecondSinceFirstLoad < os.clock() then
			local GetMyTeam = Entity.GetTeamNum(Players.GetLocal())
			if GetMyTeam == 1 or GetMyTeam == 3 then
				DotaCompanion.LoadDire()
				
				Console.Print("Done load all")
				DotaCompanion.DoneLoadAll = true
			elseif GetMyTeam == 2 then
				DotaCompanion.LoadRadiant()
				
				Console.Print("Done load all")
				DotaCompanion.DoneLoadAll = true
			end
		end
		
		for i = 1, 10 do
			local TableValue = PlayerTable[i]
			if TableValue ~= nil and TableValue[2] ~= nil then
				if TableValue[3] == false and TableValue[2]:IsResolved() then
					if DotaCompanion.NextTick < os.clock() then
						if i < 6 then
							local body = TableValue[2]:Get()
							local result = JSON.Decode(body)
							if result ~= nil then
								-- Get the heroes table
								local heroesResult = result.heroes
								
								table.sort(heroesResult, function (left, right)
									return left['matchCount'] > right['matchCount']
								end)
								
								PlayerTable[i] = {
									TableValue[1],
									heroesResult,
									true,
									{nil, nil, nil, nil},
									{nil, nil, nil},
									{nil, nil, nil},
									{
										{nil, nil, nil, nil, nil},
										{nil, nil, nil, nil, nil},
										{nil, nil, nil, nil, nil},
										{nil, nil, nil, nil, nil},
										{nil, nil, nil, nil, nil},
										{nil, nil, nil, nil, nil},
										{nil, nil, nil, nil, nil},
										{nil, nil, nil, nil, nil},
										{nil, nil, nil, nil, nil}
									}
								}
								
								local Separator = (i - 1) * 10
								local OffsetXcoor = (160 * (i-1)) + xDefault + Separator
								
								-- Setup for Text Player Name
								local WidthTemp, HeightTemp = Renderer.MeasureText(DotaCompanion.FontPlayerName, TableValue[1])
								-- Get mid position x,y for player name
								local CoorXTemp = OffsetXcoor + MathFunction.Floor((160 - WidthTemp) * 0.5)
								local CoorYTemp = yDefault + MathFunction.Floor((250 * 0.1) - HeightTemp)
								PlayerTable[i][4][1] = OffsetXcoor
								PlayerTable[i][4][2] = yDefault
								PlayerTable[i][4][3] = CoorXTemp
								PlayerTable[i][4][4] = CoorYTemp
								
								
								-- Setup for Text Total Matches found from STRATZ API
								WidthTemp, HeightTemp = Renderer.MeasureText(DotaCompanion.FontTotalMatches, "Matches: " .. result.matchCount .. "/25")
								CoorXTemp = (OffsetXcoor + 10) + MathFunction.Floor((160 - WidthTemp) * 0.5)
								CoorYTemp = CoorYTemp + HeightTemp + 20
								PlayerTable[i][5][1] = "Matches: " .. MathFunction.Floor(result.matchCount) .. "/25"
								PlayerTable[i][5][2] = CoorXTemp
								PlayerTable[i][5][3] = CoorYTemp

								-- Setup for Text Win Count from Total Matches
								WidthTemp, HeightTemp = Renderer.MeasureText(DotaCompanion.FontTotalMatches, "Win: " .. result.winCount)
								CoorXTemp = (OffsetXcoor + 10) + MathFunction.Floor((160 - WidthTemp) * 0.5)
								CoorYTemp = CoorYTemp + HeightTemp
								PlayerTable[i][6][1] = "Win: " .. MathFunction.Floor(result.winCount)
								PlayerTable[i][6][2] = CoorXTemp
								PlayerTable[i][6][3] = CoorYTemp
								
								if #heroesResult > 0 then
									for TableIndex = 1, 9 do
										local Value = heroesResult[TableIndex]
										if Value ~= nil then
											if TableIndex >= 1 and TableIndex <= 3 then
												local CoordinateX = (OffsetXcoor + 10) + ((TableIndex - 1) * 45) + ((TableIndex - 1) * 5)
												local CoordinateY = CoorYTemp + 40
												PlayerTable[i][7][TableIndex][1] = CoordinateX
												PlayerTable[i][7][TableIndex][2] = CoordinateY
												
												DotaCompanion.LoadImage("icon_", HeroesID[Value.heroId], Assets.Path)
												
												WidthTemp, HeightTemp = Renderer.MeasureText(DotaCompanion.FontTotalMatches2, MathFunction.Floor(Value.matchCount))
												PlayerTable[i][7][TableIndex][3] = MathFunction.Floor(Value.matchCount)
												PlayerTable[i][7][TableIndex][4] = CoordinateX + (45 - (WidthTemp * 2))
												PlayerTable[i][7][TableIndex][5] = CoordinateY + (40 - (HeightTemp * 1.5))
											elseif TableIndex >= 4 and TableIndex <= 6 then
												local CoordinateX = (OffsetXcoor + 10) + ((TableIndex - 4) * 45) + ((TableIndex - 4) * 5)
												local CoordinateY = CoorYTemp + 40 + 40 + 10
												PlayerTable[i][7][TableIndex][1] = CoordinateX
												
												PlayerTable[i][7][TableIndex][2] = CoordinateY
												
												DotaCompanion.LoadImage("icon_", HeroesID[Value.heroId], Assets.Path)
												
												WidthTemp, HeightTemp = Renderer.MeasureText(DotaCompanion.FontTotalMatches2, MathFunction.Floor(Value.matchCount))
												PlayerTable[i][7][TableIndex][3] = MathFunction.Floor(Value.matchCount)
												PlayerTable[i][7][TableIndex][4] = CoordinateX + (45 - (WidthTemp * 2))
												PlayerTable[i][7][TableIndex][5] = CoordinateY + (40 - (HeightTemp * 1.5))
												
											elseif TableIndex >= 7 and TableIndex <= 9 then
												local CoordinateX = (OffsetXcoor + 10) + ((TableIndex - 7) * 45) + ((TableIndex - 7) * 5)
												local CoordinateY = CoorYTemp + 40 + 80 + 20
												PlayerTable[i][7][TableIndex][1] = CoordinateX
												
												PlayerTable[i][7][TableIndex][2] = CoordinateY
												
												DotaCompanion.LoadImage("icon_", HeroesID[Value.heroId], Assets.Path)
												
												WidthTemp, HeightTemp = Renderer.MeasureText(DotaCompanion.FontTotalMatches2, MathFunction.Floor(Value.matchCount))
												PlayerTable[i][7][TableIndex][3] = MathFunction.Floor(Value.matchCount)
												PlayerTable[i][7][TableIndex][4] = CoordinateX + (45 - (WidthTemp * 2))
												PlayerTable[i][7][TableIndex][5] = CoordinateY + (40 - (HeightTemp * 1.5))
											end
										end
									end
								end
								
							else
								PlayerTable[i] = nil
							end
						else
							local body = TableValue[2]:Get()
							local result = JSON.Decode(body)
							if result ~= nil then
								-- Get the heroes table
								local heroesResult = result.heroes
								
								table.sort(heroesResult, function (left, right)
									return left['matchCount'] > right['matchCount']
								end)
								
								--for ii = 1, #heroesResult do
									--Console.Print(heroesResult[ii].matchCount)
								--end
								--Console.Print(#heroesResult)
								PlayerTable[i] = {
									TableValue[1],
									heroesResult,
									true,
									{nil, nil, nil, nil},
									{nil, nil, nil},
									{nil, nil, nil},
									{
										{nil, nil, nil, nil, nil},
										{nil, nil, nil, nil, nil},
										{nil, nil, nil, nil, nil},
										{nil, nil, nil, nil, nil},
										{nil, nil, nil, nil, nil},
										{nil, nil, nil, nil, nil},
										{nil, nil, nil, nil, nil},
										{nil, nil, nil, nil, nil},
										{nil, nil, nil, nil, nil}
									}
								}
								
								local Separator = (i - 6) * 10
								local OffsetXcoor = (160 * (i-6)) + xDefault + Separator
								
								-- Setup for Text Player Name
								local WidthTemp, HeightTemp = Renderer.MeasureText(DotaCompanion.FontPlayerName, TableValue[1])
								-- Get mid position x,y for player name
								local CoorXTemp = OffsetXcoor + MathFunction.Floor((160 - WidthTemp) * 0.5)
								local CoorYTemp = yDefault + 330 + MathFunction.Floor((250 * 0.1) - HeightTemp)
								PlayerTable[i][4][1] = OffsetXcoor
								PlayerTable[i][4][2] = yDefault + 330
								PlayerTable[i][4][3] = CoorXTemp
								PlayerTable[i][4][4] = CoorYTemp
								
								
								-- Setup for Text Total Matches found from STRATZ API
								WidthTemp, HeightTemp = Renderer.MeasureText(DotaCompanion.FontTotalMatches, "Matches: " .. result.matchCount .. "/25")
								CoorXTemp = (OffsetXcoor + 10) + MathFunction.Floor((160 - WidthTemp) * 0.5)
								CoorYTemp = CoorYTemp + HeightTemp + 20
								PlayerTable[i][5][1] = "Matches: " .. MathFunction.Floor(result.matchCount) .. "/25"
								PlayerTable[i][5][2] = CoorXTemp
								PlayerTable[i][5][3] = CoorYTemp

								-- Setup for Text Win Count from Total Matches
								WidthTemp, HeightTemp = Renderer.MeasureText(DotaCompanion.FontTotalMatches, "Win: " .. result.winCount)
								CoorXTemp = (OffsetXcoor + 10) + MathFunction.Floor((160 - WidthTemp) * 0.5)
								CoorYTemp = CoorYTemp + HeightTemp
								PlayerTable[i][6][1] = "Win: " .. MathFunction.Floor(result.winCount)
								PlayerTable[i][6][2] = CoorXTemp
								PlayerTable[i][6][3] = CoorYTemp
								
								if #heroesResult > 0 then
									for TableIndex = 1, 9 do
										local Value = heroesResult[TableIndex]
										if Value ~= nil then
											if TableIndex >= 1 and TableIndex <= 3 then
												local CoordinateX = (OffsetXcoor + 10) + ((TableIndex - 1) * 45) + ((TableIndex - 1) * 5)
												local CoordinateY = CoorYTemp + 40
												PlayerTable[i][7][TableIndex][1] = CoordinateX
												
												PlayerTable[i][7][TableIndex][2] = CoordinateY
												
												DotaCompanion.LoadImage("icon_", HeroesID[Value.heroId], Assets.Path)
												
												
												WidthTemp, HeightTemp = Renderer.MeasureText(DotaCompanion.FontTotalMatches2, MathFunction.Floor(Value.matchCount))
												PlayerTable[i][7][TableIndex][3] = MathFunction.Floor(Value.matchCount)
												PlayerTable[i][7][TableIndex][4] = CoordinateX + (45 - (WidthTemp * 2))
												PlayerTable[i][7][TableIndex][5] = CoordinateY + (40 - (HeightTemp * 1.5))
											elseif TableIndex >= 4 and TableIndex <= 6 then
												local CoordinateX = (OffsetXcoor + 10) + ((TableIndex - 4) * 45) + ((TableIndex - 4) * 5)
												local CoordinateY = CoorYTemp + 40 + 40 + 10
												PlayerTable[i][7][TableIndex][1] = CoordinateX
												
												PlayerTable[i][7][TableIndex][2] = CoordinateY
												
												DotaCompanion.LoadImage("icon_", HeroesID[Value.heroId], Assets.Path)
												
												
												WidthTemp, HeightTemp = Renderer.MeasureText(DotaCompanion.FontTotalMatches2, MathFunction.Floor(Value.matchCount))
												PlayerTable[i][7][TableIndex][3] = MathFunction.Floor(Value.matchCount)
												PlayerTable[i][7][TableIndex][4] = CoordinateX + (45 - (WidthTemp * 2))
												PlayerTable[i][7][TableIndex][5] = CoordinateY + (40 - (HeightTemp * 1.5))
											elseif TableIndex >= 7 and TableIndex <= 9 then
												local CoordinateX = (OffsetXcoor + 10) + ((TableIndex - 7) * 45) + ((TableIndex - 7) * 5)
												local CoordinateY = CoorYTemp + 40 + 80 + 20
												PlayerTable[i][7][TableIndex][1] = CoordinateX
												
												PlayerTable[i][7][TableIndex][2] = CoordinateY
												
												DotaCompanion.LoadImage("icon_", HeroesID[Value.heroId], Assets.Path)
												
												WidthTemp, HeightTemp = Renderer.MeasureText(DotaCompanion.FontTotalMatches2, MathFunction.Floor(Value.matchCount))
												PlayerTable[i][7][TableIndex][3] = MathFunction.Floor(Value.matchCount)
												PlayerTable[i][7][TableIndex][4] = CoordinateX + (45 - (WidthTemp * 2))
												PlayerTable[i][7][TableIndex][5] = CoordinateY + (40 - (HeightTemp * 1.5))
											end
										end
									end
								end
							else
								PlayerTable[i] = nil
							end -- End if result ~= nil
						end
						DotaCompanion.NextTick = os.clock() + 0.7
					end -- End if DotaCompanion.NextTick < os.clock()
				elseif TableValue[3] == true and DotaCompanion.StateShowButton == true then
					Renderer.SetDrawColor(93, 117, 124, 255)
					Renderer.DrawFilledRect(TableValue[4][1], TableValue[4][2], 160, 250)
					Renderer.SetDrawColor(PlayerColor[i][1], PlayerColor[i][2], PlayerColor[i][3], 255)
					Renderer.DrawText(DotaCompanion.FontPlayerName, TableValue[4][3], TableValue[4][4], TableValue[1])
					
					Renderer.SetDrawColor(255, 255, 255, 255)
					Renderer.DrawText(DotaCompanion.FontTotalMatches, TableValue[5][2], TableValue[5][3], TableValue[5][1])
					
					Renderer.SetDrawColor(255, 255, 255, 255)
					Renderer.DrawText(DotaCompanion.FontTotalMatches, TableValue[6][2], TableValue[6][3], TableValue[6][1])
					
					for TableIndex = 1, 9 do
						local Value = TableValue[2][TableIndex]
						if Value ~= nil and TableValue[7][TableIndex] ~= nil then
							--Console.Print(HeroesID[MathFunction.Floor(Value.heroId)])
							Renderer.DrawImage(Assets.Images["icon_" .. HeroesID[Value.heroId] ], TableValue[7][TableIndex][1], TableValue[7][TableIndex][2], 45, 40)
							
							Renderer.DrawText(DotaCompanion.FontTotalMatches, TableValue[7][TableIndex][4], TableValue[7][TableIndex][5], TableValue[7][TableIndex][3])
						end
					end
					
					
				end -- End if TableValue[3] == false and TableValue[2]:IsResolved()
			end -- End if TableValue ~= nil and TableValue[2] ~= nil
		end
		
		if DotaCompanion.StateShowButton == true then
			Renderer.SetDrawColor(255, 255, 255, 255)
			Renderer.DrawImage(Assets.Images["Menu_quit"], Menu.GetValue(DotaCompanion.offsetX),Menu.GetValue(DotaCompanion.offsetY), Menu.GetValue(DotaCompanion.size), Menu.GetValue(DotaCompanion.size))
		else
			Renderer.SetDrawColor(255, 255, 255, 255)
			Renderer.DrawImage(Assets.Images["Menu_dotaplus_logo"], Menu.GetValue(DotaCompanion.offsetX),  Menu.GetValue(DotaCompanion.offsetY), Menu.GetValue(DotaCompanion.size), Menu.GetValue(DotaCompanion.size))
		end
		
		if Input.IsCursorInRect(Menu.GetValue(DotaCompanion.offsetX),  Menu.GetValue(DotaCompanion.offsetY), Menu.GetValue(DotaCompanion.size), Menu.GetValue(DotaCompanion.size)) then
			if Input.IsKeyDownOnce( Enum.ButtonCode.MOUSE_LEFT) then
				if DotaCompanion.StateShowButton == false then
					DotaCompanion.StateShowButton = true
				else
					DotaCompanion.StateShowButton = false
				end
			end
		end
		
		if Menu.IsKeyDownOnce(DotaCompanion.KeyShowHide) then
			if DotaCompanion.StateShowButton == false then
				DotaCompanion.StateShowButton = true
			else
				DotaCompanion.StateShowButton = false
			end
		end
	end
end

return DotaCompanion