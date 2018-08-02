-----------------
-- Version 0.3 --
-----------------

local DotaCompanion = {}

--*** Menu ***--
DotaCompanion.optionEnable = Menu.AddOption({ "mlambers", "Dota Companion" }, "1. Enable.", "Enable/Disable this script.")
DotaCompanion.offsetX = Menu.AddOption({ "mlambers", "Dota Companion" }, "2. Menu x offset", "", 0, 500, 10)
DotaCompanion.offsetY = Menu.AddOption({"mlambers", "Dota Companion" }, "3. Menu y offset", "", 0, 500, 10)
DotaCompanion.size = Menu.AddOption({"mlambers", "Dota Companion" }, "4. Menu size", "", 1, 32, 1)
DotaCompanion.KeyShowHide = Menu.AddKeyOption({ "mlambers", "Dota Companion"}, "5. Key show/hide panel", Enum.ButtonCode.KEY_F)

DotaCompanion.NeedInit = true
DotaCompanion.CanDraw = false

DotaCompanion.NextTick = 0
DotaCompanion.OutsideGameReset = false

DotaCompanion.FontCooldown = Renderer.LoadFont("Verdana", 20, Enum.FontWeight.NORMAL)

DotaCompanion.StateShowButton = true

local ScreenWidth, ScreenHeight = nil, nil
local PlayerTable = {nil, nil, nil, nil, nil}

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
	PlayerTable = {nil, nil, nil, nil, nil}
	
	ScreenWidth, ScreenHeight = nil, nil
	DotaCompanion.NextTick = 0
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
	PlayerTable = {nil, nil, nil, nil, nil}
	
	ScreenWidth, ScreenHeight = nil, nil
	DotaCompanion.NextTick = 0
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

function DotaCompanion.OnDraw()
	if Engine.IsInGame() == false then 
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
		--Console.Print(GameRules.GetServerGameState())
		for i = 1, Players.Count() do
			local EntityPlayer = Players.Get(i)
			if EntityPlayer and Entity.IsPlayer(EntityPlayer) and Player.GetPlayerData(EntityPlayer) and Player.GetPlayerData(EntityPlayer).valid == true and Entity.IsSameTeam(Players.GetLocal(), EntityPlayer) == false then
			--if EntityPlayer and Entity.IsPlayer(EntityPlayer) and Player.GetPlayerData(EntityPlayer) and Player.GetPlayerData(EntityPlayer).valid == true and Player.GetPlayerID(EntityPlayer) < 5 then
				if Player.GetPlayerID(EntityPlayer) < 5 then
					PlayerTable[Player.GetPlayerID(EntityPlayer) + 1] = {
						Player.GetName(EntityPlayer),
						HTTP.NewConnection("https://api.stratz.com/api/v1/Player/" .. DotaCompanion.GetFriendsId(Player.GetPlayerData(EntityPlayer).steamid) .. "/behaviorChart?lobbyType=7&isParty=false"):AsyncRequest("GET"),
						false
					}
					--Console.Print((Player.GetPlayerID(EntityPlayer) + 1) .. " " .. Player.GetName(EntityPlayer))
				else
					PlayerTable[Player.GetPlayerID(EntityPlayer) - 4] = {
						Player.GetName(EntityPlayer),
						HTTP.NewConnection("https://api.stratz.com/api/v1/Player/" .. DotaCompanion.GetFriendsId(Player.GetPlayerData(EntityPlayer).steamid) .. "/behaviorChart?lobbyType=7&isParty=false"):AsyncRequest("GET"),
						false
					}
					--Console.Print((Player.GetPlayerID(EntityPlayer) - 4) .. " " .. Player.GetName(EntityPlayer))
				end
					
			end
		end
		DotaCompanion.LoadImage("Menu_", "dotaplus_logo", Assets.PathMenu)
		DotaCompanion.LoadImage("Menu_", "quit", Assets.PathMenu2)
		DotaCompanion.CanDraw = true
		ScreenWidth, ScreenHeight = Renderer.GetScreenSize()
		DotaCompanion.OutsideGameReset = true
		DotaCompanion.NeedInit = false
	end
	
	if DotaCompanion.CanDraw == true then
		local xDefault = MathFunction.Ceil(ScreenWidth * 0.05)
		local yDefault = MathFunction.Ceil(ScreenHeight * 0.1)
		local Longest = 0
		local HeightBox = 0
		Renderer.SetDrawColor(0, 0, 0, 255)
		local TextWidth2, TextHeight2 = Renderer.MeasureText(DotaCompanion.FontCooldown,	"G: ")
		local HeightBackground = (Assets.DefaultHeightSize + TextHeight2 + TextHeight2) * 5
		if DotaCompanion.StateShowButton == true then
			Renderer.DrawFilledRect(xDefault, yDefault, MathFunction.Ceil(ScreenWidth * 0.9), HeightBackground+10)
		end
		
		for i = 1, 5 do
			local TableValue = PlayerTable[i]
			if TableValue ~= nil and TableValue[2] ~= nil then
				
				if TableValue[3] == false  and TableValue[2]:IsResolved() then
					if DotaCompanion.NextTick < os.clock() then
						-- Check midpoint pos of Player name
						
						local body = TableValue[2]:Get()
							local result = JSON.Decode(body)
						
						if result ~= nil then
							
							result = result.heroes
							table.sort(result, function (left, right)
								return left['matchCount'] > right['matchCount']
							end)

							PlayerTable[i] = {
								TableValue[1],
								result,
								true,
								{},
								{
									{nil,nil},
									{nil,nil},
									{nil,nil},
									{nil,nil},
									{nil,nil},
									{nil,nil},
									{nil,nil},
									{nil,nil},
									{nil,nil},
									{nil,nil},
									{nil,nil},
									{nil,nil},
									{nil,nil},
									{nil,nil},
									{nil,nil},
									{nil,nil},
									{nil,nil},
									{nil,nil},
									{nil,nil},
									{nil,nil},
									{nil,nil},
									{nil,nil},
									{nil,nil},
									{nil,nil},
									{nil,nil}
								},
								{
									{nil,nil},
									{nil,nil},
									{nil,nil},
									{nil,nil},
									{nil,nil},
									{nil,nil},
									{nil,nil},
									{nil,nil},
									{nil,nil},
									{nil,nil},
									{nil,nil},
									{nil,nil},
									{nil,nil},
									{nil,nil},
									{nil,nil},
									{nil,nil},
									{nil,nil},
									{nil,nil},
									{nil,nil},
									{nil,nil},
									{nil,nil},
									{nil,nil},
									{nil,nil},
									{nil,nil},
									{nil,nil}
								},
								{
									{nil,nil},
									{nil,nil},
									{nil,nil},
									{nil,nil},
									{nil,nil},
									{nil,nil},
									{nil,nil},
									{nil,nil},
									{nil,nil},
									{nil,nil},
									{nil,nil},
									{nil,nil},
									{nil,nil},
									{nil,nil},
									{nil,nil},
									{nil,nil},
									{nil,nil},
									{nil,nil},
									{nil,nil},
									{nil,nil},
									{nil,nil},
									{nil,nil},
									{nil,nil},
									{nil,nil},
									{nil,nil}
								},
								nil
							}
							local TextWidth, TextHeight = Renderer.MeasureText(DotaCompanion.FontCooldown, TableValue[1] .. " : ")
							
							local MidPoint = MathFunction.Floor( ( (Assets.DefaultHeightSize + TextHeight2 + TextHeight2) - TextHeight) * 0.5)
							
							local HeightYnew = 0
							if i == 1 then
								HeightYnew = yDefault
							elseif i > 1 then
								HeightYnew = ((i-1) * ( Assets.DefaultHeightSize + TextHeight2 + TextHeight2)) + yDefault
							end
							-- Set player name x, y coordinate
							PlayerTable[i][4][1] = 5 + xDefault
							PlayerTable[i][4][2] = 10 + (HeightYnew + MidPoint)
							
							if #result > 0 then
								
								for SizeTable = 1, #result do
									
									local Value = result[SizeTable]
									if Value then
										local PositionX = (5 + xDefault) + TextWidth + (SizeTable * Assets.DefaultWidthSize) + ((SizeTable - 1) * 8)
										--Console.Print(PositionX)
										-- Set Heroes images x, y coordinate
										PlayerTable[i][5][SizeTable][1] = PositionX
										PlayerTable[i][5][SizeTable][2] = 10 + HeightYnew
										-- Set Heroes total games y coordinate and text
										PlayerTable[i][6][SizeTable][1] = 10 + HeightYnew + Assets.DefaultHeightSize
										PlayerTable[i][6][SizeTable][2] =  "G: " .. MathFunction.Floor(Value.matchCount)
										--Console.Print(type(Value.matchCount))
										-- Set Heroes total win with that heroes y coordinate and text
										PlayerTable[i][7][SizeTable][1] = 10 + HeightYnew + Assets.DefaultHeightSize + TextHeight2
										PlayerTable[i][7][SizeTable][2] =  "W: " .. MathFunction.Floor(Value.winCount)
										
										-- Now try to load Images
										
										DotaCompanion.LoadImage("icon_", HeroesID[Value.heroId], Assets.Path)
									end
								end
							end
							
							
						else
							PlayerTable[i] = nil
						end
						DotaCompanion.NextTick = os.clock() + 0.7
					end
				elseif TableValue[3] == true and DotaCompanion.StateShowButton == true then	
					if #TableValue[2] > 0 then
						Renderer.SetDrawColor(255, 255, 255, 255)
						
						local TableSize = #TableValue[2]
						for HeroesTable = 1, TableSize do
							local Value = TableValue[2][HeroesTable]
							if Value then
								Renderer.DrawImage(Assets.Images["icon_" .. HeroesID[Value.heroId]], TableValue[5][HeroesTable][1], TableValue[5][HeroesTable][2], Assets.DefaultWidthSize, Assets.DefaultHeightSize)
						
								Renderer.DrawText(DotaCompanion.FontCooldown, TableValue[5][HeroesTable][1], TableValue[6][HeroesTable][1], TableValue[6][HeroesTable][2] )
								
								Renderer.DrawText(DotaCompanion.FontCooldown, TableValue[5][HeroesTable][1], TableValue[7][HeroesTable][1], TableValue[7][HeroesTable][2] )
							end
						end
						Renderer.SetDrawColor(255, 255, 100, 255)
						Renderer.DrawText(DotaCompanion.FontCooldown, TableValue[4][1], TableValue[4][2], TableValue[1] .. " : ")
					else
						Renderer.SetDrawColor(255, 255, 100, 255)
						Renderer.DrawText(DotaCompanion.FontCooldown, TableValue[4][1], TableValue[4][2], TableValue[1] .. " : Data not found")
					end
					
				end
			end
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
		
		if DotaCompanion.StateShowButton == true then
			Renderer.SetDrawColor(255, 255, 255, 255)
			Renderer.DrawImage(Assets.Images["Menu_quit"], Menu.GetValue(DotaCompanion.offsetX),  Menu.GetValue(DotaCompanion.offsetY), Menu.GetValue(DotaCompanion.size), Menu.GetValue(DotaCompanion.size))
		else
			Renderer.SetDrawColor(255, 255, 255, 255)
			Renderer.DrawImage(Assets.Images["Menu_dotaplus_logo"], Menu.GetValue(DotaCompanion.offsetX),  Menu.GetValue(DotaCompanion.offsetY), Menu.GetValue(DotaCompanion.size), Menu.GetValue(DotaCompanion.size))
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

return DotaCompanion