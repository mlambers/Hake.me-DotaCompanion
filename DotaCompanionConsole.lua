------------------
-- Version 0.7a --
------------------

local DotaCompanion = {}

--*** Menu ***--
DotaCompanion.optionEnable = Menu.AddOption({ "mlambers", "Dota Companion Console" }, "1. Enable.", "Enable/Disable this script.")
DotaCompanion.TotalGames = Menu.AddOption({ "mlambers", "Dota Companion Console" }, "2. Total Games", "Total Last x games to parse", 25, 250, 25)
DotaCompanion.AutoBan = Menu.AddOption({ "mlambers", "Dota Companion Console" }, "3. Enable auto ban", "Enable auto ban")
DotaCompanion.Mode = Menu.AddOption({"mlambers", "Dota Companion Console"}, "4. Auto ban mode", "mode")
Menu.SetValueName(DotaCompanion.Mode, 0, "Confidence rate")
Menu.SetValueName(DotaCompanion.Mode, 1, "Total match")
--***********--

DotaCompanion.OutsideGameReset = false
DotaCompanion.CanDraw = false
DotaCompanion.NeedInit = true
DotaCompanion.NextTick = 0
local PlayerTable = {nil, nil, nil, nil, nil, nil, nil, nil, nil, nil}
local BanList = {}
local Ctr = 0
local Ctr2 = 0
local Ctr3 = 0
local Ctr4 = 0
local BanListSay = false
local OrderStatus = 0

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
	"npc_dota_hero_pangolier",
	"npc_dota_hero_grimstroke"
}

function DotaCompanion.OnScriptLoad()
	DotaCompanion.OutsideGameReset = false
	for i = #PlayerTable, 1, -1 do
		PlayerTable[i] = nil
	end
	PlayerTable = {nil, nil, nil, nil, nil, nil, nil, nil, nil, nil}
	
	for i = #BanList, 1, -1 do
		BanList[i] = nil
	end
	BanList = {}
	Ctr = 0
	Ctr2 = 0
	Ctr3 = 0
	Ctr4 = 0
	DotaCompanion.NextTick = 0
	
	DotaCompanion.CanDraw = false
	DotaCompanion.NeedInit = true
	OrderStatus = 0
	BanListSay = false

	Console.Print("DotaCompanion.OnScriptLoad()")
end

function DotaCompanion.OnGameEnd()
	DotaCompanion.OutsideGameReset = false
	for i = #PlayerTable, 1, -1 do
		PlayerTable[i] = nil
	end
	PlayerTable = {nil, nil, nil, nil, nil, nil, nil, nil, nil, nil}
	
	for i = #BanList, 1, -1 do
		BanList[i] = nil
	end
	BanList = {}
	Ctr = 0
	Ctr2 = 0
	Ctr3 = 0
	Ctr4 = 0
	DotaCompanion.NextTick = 0
	
	DotaCompanion.DoneLoadAll = false
	DotaCompanion.CanDraw = false
	DotaCompanion.NeedInit = true

	BanListSay = false
	OrderStatus = 0
	Console.Print("DotaCompanion.OnGameEnd()")
end

function DotaCompanion.RoundNumber(num, idp)
    local mult = 10^(idp or 0)
    return math.floor(num * mult + 0.5) / mult
end


function DotaCompanion.AgrestiCoullLower(n, k)
	local LocalSqrt = math.sqrt
	local kappa = 2.24140273
	local kest = k + (kappa * kappa) * 0.5
	local nest = n + (kappa * kappa)
	local pest = kest / nest
	local radius = kappa * LocalSqrt(pest * (1 - pest) / nest)
  
	if (0 > (pest - radius)) then 
		return 0 
	else
		return DotaCompanion.RoundNumber( (pest - radius), 3)
	end
end

function DotaCompanion.GetFriendsId(Input)
    return (tonumber(Input) - 76561197960265728)
end

function DotaCompanion.GetTableIndex(Finder)
	for i = 1, #BanList do
		local Val = BanList[i]
		if Val ~= nil then
			if Val[1] == Finder then return i end
		end
	end
end


function DotaCompanion.TableElementExist(Finder)
	for i = 1, #BanList do
		local Val = BanList[i]
		if Val ~= nil then
			if Val[1] == Finder then return true end
		end
	end
	
	return false
end

function DotaCompanion.StringBuilder(Text)
	local TextResult = string.sub(Text, 15)
	TextResult = TextResult:gsub("_", " ")
	return TextResult:gsub("^%l", string.upper)
end

function DotaCompanion.GetRole(id)
	if id == 1 then
		return '<font color="#00C0C0">Support</font>'
	elseif id == 0 then	
		return '<font color="#FF4000">Core</font>'
	else
		return "Unknown"
	end
end

function DotaCompanion.GetWinRate( ... )
	local arg = {...}
	local result = 100 * (arg[1] / arg[2])
	return DotaCompanion.RoundNumber(result, 2)
end

function DotaCompanion.GetMatchResult(id)
	if id == 0 then
		return '<font color="Green">W</font>'
	else
		return '<font color="Red">L</font>'
	end
end

function DotaCompanion.OnDraw()
	-- Check if Player in a match or not
	if Engine.IsInGame() == false then 
		-- If outside match and need to reset variable
		if DotaCompanion.OutsideGameReset == true then
			for i = #PlayerTable, 1, -1 do
				PlayerTable[i] = nil
			end
			PlayerTable = {nil, nil, nil, nil, nil, nil, nil, nil, nil, nil}
			
			for i = #BanList, 1, -1 do
				BanList[i] = nil
			end
			BanList = {}
			
			OrderStatus = 0
			Ctr = 0
			Ctr2 = 0
			Ctr3 = 0
			Ctr4 = 0
			BanListSay = false
			DotaCompanion.NextTick = 0
			DotaCompanion.CanDraw = false
			DotaCompanion.NeedInit = true
			
			DotaCompanion.OutsideGameReset = false
			Console.Print("DotaCompanion.OutsideGameReset()")
		end
	end
	
	if Engine.IsInGame() == true then
		if Menu.IsEnabled(DotaCompanion.optionEnable) == false then return end
		if GameRules.GetGameState() < 2 then return end
		if GameRules.GetGameState() > 3 then return end
		--if Entity.GetTeamNum(Players.GetLocal()) == 1 then return end
		
		if DotaCompanion.NeedInit == true then
			for i = 1, Players.Count() do
				local EntityPlayer = Players.Get(i)
				if EntityPlayer and Entity.IsPlayer(EntityPlayer) and Player.GetPlayerData(EntityPlayer) and Player.GetPlayerData(EntityPlayer).valid == true and Entity.IsSameTeam(Players.GetLocal(), EntityPlayer) == false
				
				--if EntityPlayer and Player.GetPlayerData(EntityPlayer) and Player.GetPlayerData(EntityPlayer).valid == true and Entity.GetTeamNum(EntityPlayer) == 2
				
				--if EntityPlayer and Entity.IsPlayer(EntityPlayer) and Player.GetPlayerData(EntityPlayer) and Player.GetPlayerData(EntityPlayer).valid == true and Entity.GetTeamNum(EntityPlayer) == 2
				then
					PlayerTable[Player.GetPlayerID(EntityPlayer) + 1] = {
						DotaCompanion.GetFriendsId(Player.GetPlayerData(EntityPlayer).steamid),
						Player.GetName(EntityPlayer),
						HTTP.NewConnection("https://api.stratz.com/api/v1/Player/" .. DotaCompanion.GetFriendsId(Player.GetPlayerData(EntityPlayer).steamid)):AsyncRequest("GET"),
						nil, -- Array number 4, This is reserved to indicate Private profile or not
						nil, -- Array number 5, This is reserved for API get behaviorChart
						nil, -- Array number 6, This is reserved for 10 games result to print in chat
						nil, --  Array number 7, This is reserved for roles API analysis
						nil -- Array number 8, store roles to print in chat
					}
					
				end
			end
			
			
			DotaCompanion.OutsideGameReset = true
			DotaCompanion.NextTick = os.clock() + 5.0
			DotaCompanion.CanDraw = true
			OrderStatus = 1
			Log.Write("Init done, order status = 1")
			DotaCompanion.NeedInit = false
		end
		
		if DotaCompanion.CanDraw == true then
			if Ctr == 5 and OrderStatus == 1 then
				OrderStatus = 2
				Log.Write("First phase, order enum: " .. OrderStatus)
				DotaCompanion.NextTick = os.clock() + 3.0
			end
			
			if Ctr2 == 5 and OrderStatus == 2 then
				OrderStatus = 3
				Log.Write("Second phase, order enum: " .. OrderStatus)
				BanListSay = true
			end
			
			if Ctr3 == 5 and OrderStatus == 3 then
				OrderStatus = 4
				Log.Write("Third phase, order enum: " .. OrderStatus .. " Debug CTR number: " .. Ctr3)
				DotaCompanion.NextTick = os.clock() + 3.0
			end
			
			if Ctr4 == 5 and OrderStatus == 4 then
				OrderStatus = 5
				Log.Write("Fourth phase, order enum: " .. OrderStatus .. " Debug CTR number: " .. Ctr4)
				Log.Write("Done all step.")
			end
			
			if BanListSay == true then
				if #BanList > 0 then
					for  i = 1, #BanList do
						local GetVal = BanList[i]
							
						if GetVal ~= nil then
							local AgrestiVal = DotaCompanion.AgrestiCoullLower(GetVal[2], GetVal[3])
							BanList[i][4] = AgrestiVal
						end
					end
						
					table.sort(BanList, function (left, right)
						return left[4] > right[4]
					end)
					
					local PrintText = ""
					Chat.Print("ConsoleChat", '<font color="White">Suggested bans (Confidence rate): </font>')
						
					for  i = 1, 5 do
						local GetVal = BanList[i]
									
						if GetVal ~= nil then
							PrintText = PrintText .. " " .. i .. ". " .. DotaCompanion.StringBuilder(GetVal[1])
							if Menu.IsEnabled(DotaCompanion.AutoBan) == true and Menu.GetValue(DotaCompanion.Mode) == 0 then 
								Engine.ExecuteCommand("dota_captain_ban_hero " .. GetVal[1])
								Console.Print("Auto ban: " .. GetVal[1])
							end
						end
					end
					Chat.Print("ConsoleChat", '<font color="Cyan">' .. PrintText .. '</font>')
						
					table.sort(BanList, function (left, right)
						return left[2] > right[2]
					end)
					PrintText = ""
					Chat.Print("ConsoleChat", '<font color="White">Suggested bans (Total match): </font>')
							
					for  i = 1, 5 do
						local GetVal = BanList[i]
									
						if GetVal ~= nil then
							PrintText = PrintText .. " " .. i .. ". " .. DotaCompanion.StringBuilder(GetVal[1])
							if Menu.IsEnabled(DotaCompanion.AutoBan) == true and Menu.GetValue(DotaCompanion.Mode) == 1 then 
								Engine.ExecuteCommand("dota_captain_ban_hero " .. GetVal[1])
								Console.Print("Auto ban: " .. GetVal[1])
							end
							
						end
					end
					Chat.Print("ConsoleChat", '<font color="Orange">' .. PrintText .. '</font>')
				else
					Log.Write("0 matches found from scanner")
					Chat.Print("ConsoleChat", '<font color="Orange">No matches found from scanner.</font>')
				end
				
				BanListSay = false
				Log.Write("Done with BanList")
				DotaCompanion.NextTick = os.clock() + 15.0
			end
			
			-- Order status : 1
			-- Job: Send API query
			-- Purpose: Get heroes from desired API parameter for banlist heroes
			if DotaCompanion.NextTick < os.clock() and OrderStatus == 1 then
				local GetTotalGames = Menu.GetValue(DotaCompanion.TotalGames)
				for i = 1, 10 do
					local TableValue = PlayerTable[i]
					if TableValue ~= nil then
						if TableValue[4] == nil and TableValue[3] ~= nil and TableValue[3]:IsResolved() then
							local body = TableValue[3]:Get()
							local result = JSON.Decode(body)
							if result ~= nil then
								if result.isAnonymous == false then
									PlayerTable[i][3] = nil
									PlayerTable[i][4] = false
									PlayerTable[i][5] = HTTP.NewConnection("https://api.stratz.com/api/v1/Player/" .. TableValue[1] .. "/behaviorChart?lobbyType=7&isParty=false&take=" .. GetTotalGames):AsyncRequest("GET")
									
									Log.Write("Steam ID: " .. TableValue[1] .. " Nickname: " .. TableValue[2] .. " - Not private")
								else
									PlayerTable[i][3] = nil
									PlayerTable[i][4] = true
									Ctr2 = Ctr2 + 1
									Log.Write("Steam ID: " .. TableValue[1] .. " Nickname: " .. TableValue[2] .. " - Private profile")
								end
							end
							Ctr = Ctr + 1
						end
					end
				end
			end
			
			-- Order status: 2
			-- Job: Retrieve API result from order status 1
			-- Purpose: Explained above
			if DotaCompanion.NextTick < os.clock() and OrderStatus == 2
			then
				for i = 1, 10 do
					local TableValue = PlayerTable[i]
					if TableValue ~= nil then
						if TableValue[4] == false and TableValue[5] ~= nil and TableValue[5]:IsResolved() then
							local body = TableValue[5]:Get()
							local result = JSON.Decode(body)
							
							if type(result) == "table" then
								Log.Write("Steam ID: " .. TableValue[1] .. " Nickname: " .. TableValue[2] .. " Matches: " ..result.matchCount)
								if result.matchCount > 0 then
									-- Dump last 10 result
									for y = 1, 10 do
										local TabVal = result.matches[y]
									
										if TabVal ~= nil then
											if y == 1 then
												PlayerTable[i][6] = '→ ' .. DotaCompanion.GetMatchResult(TabVal.gameResult)
											else
												PlayerTable[i][6] = PlayerTable[i][6] .. " " .. DotaCompanion.GetMatchResult(TabVal.gameResult)
											end
										end
									end
									
									local heroesResult = result.heroes
									
									table.sort(heroesResult, function (left, right)
											return left['matchCount'] > right['matchCount']
										end)
										
									for TableIndex = 1, #heroesResult do
										local Value = heroesResult[TableIndex]
										if Value ~= nil then
											local NameValue = HeroesID[Value.heroId]
												
											if DotaCompanion.TableElementExist(NameValue) == true then
												local idx = DotaCompanion.GetTableIndex(NameValue)
												BanList[idx][2] = BanList[idx][2] + Value.matchCount
												BanList[idx][3] = BanList[idx][3] + Value.winCount
											else
												BanList[#BanList + 1] = {
													NameValue,
													Value.matchCount,
													Value.winCount,
													nil
												}
													
											end
										end
									end
									
								end
							end
							
							Ctr2 = Ctr2 + 1
							PlayerTable[i][5] = nil
						end
					end
				end
			end
			
			-- Order status: 3
			-- Job: Send API query
			-- Purpose: Get player roles
			if DotaCompanion.NextTick < os.clock() and OrderStatus == 3 then
				for i = 1, #PlayerTable do
					local TableValue = PlayerTable[i]
					if TableValue ~= nil then
						if TableValue[4] == false then
							PlayerTable[i][7] = HTTP.NewConnection("https://api.stratz.com/api/v1/Player/" .. PlayerTable[i][1] .. "/summary"):AsyncRequest("GET")
						end
						Ctr3 = Ctr3 + 1
					end
				end
			end
			
			-- Order status: 4
			-- Job: Retrieve API query + Print roles & 10 matches history.
			-- Purpose: Explained above
			if DotaCompanion.NextTick < os.clock() and OrderStatus == 4 then
				for i = 1, #PlayerTable do
					local TableValue = PlayerTable[i]
					if TableValue ~= nil then
						if TableValue[4] == false then
							if TableValue[7] ~= nil and TableValue[7]:IsResolved() then
								local body = TableValue[7]:Get()
								local result = JSON.Decode(body)
								if result ~= nil then
									Console.Print("Get roles for " .. TableValue[2])
									local MathFloor = math.floor
									for k, v in pairs(result.allTime.roleMatches) do
										if k == 1 then
											PlayerTable[i][8] =  '<font color="White">Role: </font>' .. DotaCompanion.GetRole(v.id) .. '<font color="White"> Matches: ' .. MathFloor(v.matchCount) .. " Win rate: " .. DotaCompanion.GetWinRate(v.win, v.matchCount) .. "%</font>"
										else
											PlayerTable[i][8] = PlayerTable[i][8] .. '<font color="White"> | </font>' .. DotaCompanion.GetRole(v.id) .. '<font color="White"> Matches: ' .. MathFloor(v.matchCount) .. " Win rate: " .. DotaCompanion.GetWinRate(v.win, v.matchCount) .. "%</font>"
										end
									end
									Chat.Print("ConsoleChat", '<font color="#FF4040">' .. TableValue[2] .. '</font>')
									Chat.Print("ConsoleChat", TableValue[8])
									if TableValue[6] ~= nil then
										Chat.Print("ConsoleChat", TableValue[6])
									end
								else
									Chat.Print("ConsoleChat", '<font color="#FF4040">' .. TableValue[2] .. '</font>')
									Chat.Print("ConsoleChat", '<font color="White">Roles not found.</font>')
									if TableValue[6] ~= nil then
										Chat.Print("ConsoleChat", TableValue[6])
									end
								end
								PlayerTable[i][7] = nil
							end
						else
							
							Chat.Print("ConsoleChat", '<font color="#FF4040">' .. TableValue[2] .. '</font><font color="White"> (PRIVATE PROFILE, GDPR RELATED)</font>')
						end
						Ctr4 = Ctr4 + 1
					end
				end
			end
		end
	end
end

return DotaCompanion