-- Edited Jun 20, 2023

local addon, ns = ...
ns.GroupOrder = {
	[1] = "DF",
	[2] = "D&R",
	[3] = "Misc",
	[4] = "PvP",
	[5] = "SL",
	[6] = "BFA",
	[7] = "Legion",
	[8] = "Warlords",
	[9] = "Mist",
	[10] = "Cata",
	[11] = "Wrath",
}
local groupIDs = {
	["Dragonflight"] = "DF",
	["Revoada Dragônica"] = "DF",
	["용군단"] = "DF",
	["巨龙时代"] = "DF",
	["巨龍軍團"] = "DF",
	["Dungeon and Raid"] = "D&R",
	["Spedizioni e Incursioni"] = "D&R",
	["Masmorras e Raides"] = "D&R",
	["Подземелья и рейды"] = "D&R",
	["Donjons & Raids"] = "D&R",
	["Calabozo y banda"] = "D&R",
	["Dungeon und Schlachtzug"] = "D&R",
	["Mazmorra y banda"] = "D&R",
	["던전 및 공격대"] = "D&R",
	["地下城与团队副本"] = "D&R",
	["地城與團隊"] = "D&R",
	["Miscellaneous"] = "Misc",
	["Varie"] = "Misc",
	["Diversos"] = "Misc",
	["Разное"] = "Misc",
	["Divers"] = "Misc",
	["Miscelánea"] = "Misc",
	["Verschiedenes"] = "Misc",
	["Miscelánea"] = "Misc",
	["기타"] = "Misc",
	["其它"] = "Misc",
	["玩家對玩家"] = "Misc",
	["Player vs. Player"] = "PvP",
	["Personaggio vs Personaggio"] = "PvP",
	["Jogador x Jogador"] = "PvP",
	["PvP"] = "PvP",
	["JcJ"] = "PvP",
	["Jugador contra Jugador"] = "PvP",
	["Spieler gegen Spieler"] = "PvP",
	["Jugador contra Jugador"] = "PvP",
	["플레이어 간 전투"] = "PvP",
	["PvP"] = "PvP",
	["雜項"] = "PvP",
	["Shadowlands"] = "SL",
	["어둠땅"] = "SL",
	["暗影国度"] = "SL",
	["暗影之境"] = "SL",
	["Battle for Azeroth"] = "BFA",
	["격전의 아제로스"] = "BFA",
	["争霸艾泽拉斯"] = "BFA",
	["決戰艾澤拉斯"] = "BFA",
	["Legion"] = "Legion",
	["군단"] = "Legion",
	["军团再临"] = "Legion",
	["軍團"] = "Legion",
	["Warlords of Draenor"] = "Warlords",
	["드레노어의 전쟁군주"] = "Warlords",
	["德拉诺之王"] = "Warlords",
	["德拉諾之霸"] = "Warlords",
	["Mists of Pandaria"] = "Mist",
	["판다리아의 안개"] = "Mist",
	["熊猫人之谜"] = "Mist",
	["潘達利亞之謎"] = "Mist",
	["Cataclysm"] = "Cata",
	["대격변"] = "Cata",
	["大地的裂变"] = "Cata",
	["浩劫與重生"] = "Cata",
	["Wrath of the Lich King"] = "Wrath",
	["리치 왕의 분노"] = "Wrath",
	["巫妖王之怒"] = "Wrath",
	["巫妖王之怒"] = "Wrath",
}
function ns.GetGroupID(n)
	for k, v in pairs (groupIDs) do
		if k == n then return v; end;
	end;
	return n;
end;
local headings = {
	["DF"] = {
		["enUS"] = "Dragonflight",
		["itIT"] = "Dragonflight",
		["ptBR"] = "Revoada Dragônica",
		["ruRU"] = "Dragonflight",
		["frFR"] = "Dragonflight",
		["esMX"] = "Dragonflight",
		["deDE"] = "Dragonflight",
		["esES"] = "Dragonflight",
		["koKR"] = "용군단",
		["zhCN"] = "巨龙时代",
		["zhTW"] = "巨龍軍團",
	},
	["D&R"] = {
		["enUS"] = "Dungeon and Raid",
		["itIT"] = "Spedizioni e Incursioni",
		["ptBR"] = "Masmorras e Raides",
		["ruRU"] = "Подземелья и рейды",
		["frFR"] = "Donjons & Raids",
		["esMX"] = "Calabozo y banda",
		["deDE"] = "Dungeon und Schlachtzug",
		["esES"] = "Mazmorra y banda",
		["koKR"] = "던전 및 공격대",
		["zhCN"] = "地下城与团队副本",
		["zhTW"] = "地城與團隊",
	},	
	["Misc"] = {
		["enUS"] = "Miscellaneous",
		["itIT"] = "Varie",
		["ptBR"] = "Diversos",
		["ruRU"] = "Разное",
		["frFR"] = "Divers",
		["esMX"] = "Miscelánea",
		["deDE"] = "Verschiedenes",
		["esES"] = "Miscelánea",
		["koKR"] = "기타",
		["zhCN"] = "其它",
		["zhTW"] = "玩家對玩家",
	},	
	["PvP"] = {
		["enUS"] = "Player vs. Player",
		["itIT"] = "Personaggio vs Personaggio",
		["ptBR"] = "Jogador x Jogador",
		["ruRU"] = "PvP",
		["frFR"] = "JcJ",
		["esMX"] = "Jugador contra Jugador",
		["deDE"] = "Spieler gegen Spieler",
		["esES"] = "Jugador contra Jugador",
		["koKR"] = "플레이어 간 전투",
		["zhCN"] = "PvP",
		["zhTW"] = "雜項",
	},	
	["SL"] = {
		["enUS"] = "Shadowlands",
		["itIT"] = "Shadowlands",
		["ptBR"] = "Shadowlands",
		["ruRU"] = "Shadowlands",
		["frFR"] = "Shadowlands",
		["esMX"] = "Shadowlands",
		["deDE"] = "Shadowlands",
		["esES"] = "Shadowlands",
		["koKR"] = "어둠땅",
		["zhCN"] = "暗影国度",
		["zhTW"] = "暗影之境",
	},	
	["BFA"] = {
		["enUS"] = "Battle for Azeroth",
		["itIT"] = "Battle for Azeroth",
		["ptBR"] = "Battle for Azeroth",
		["ruRU"] = "Battle for Azeroth",
		["frFR"] = "Battle for Azeroth",
		["esMX"] = "Battle for Azeroth",
		["deDE"] = "Battle for Azeroth",
		["esES"] = "Battle for Azeroth",
		["koKR"] = "격전의 아제로스",
		["zhCN"] = "争霸艾泽拉斯",
		["zhTW"] = "決戰艾澤拉斯",
	},	
	["Legion"] = {
		["enUS"] = "Legion",
		["itIT"] = "Legion",
		["ptBR"] = "Legion",
		["ruRU"] = "Legion",
		["frFR"] = "Legion",
		["esMX"] = "Legion",
		["deDE"] = "Legion",
		["esES"] = "Legion",
		["koKR"] = "군단",
		["zhCN"] = "军团再临",
		["zhTW"] = "軍團",
	},	
	["Warlords"] = {
		["enUS"] = "Warlords of Draenor",
		["itIT"] = "Warlords of Draenor",
		["ptBR"] = "Warlords of Draenor",
		["ruRU"] = "Warlords of Draenor",
		["frFR"] = "Warlords of Draenor",
		["esMX"] = "Warlords of Draenor",
		["deDE"] = "Warlords of Draenor",
		["esES"] = "Warlords of Draenor",
		["koKR"] = "드레노어의 전쟁군주",
		["zhCN"] = "德拉诺之王",
		["zhTW"] = "德拉諾之霸",
	},	
	["Mist"] = {
		["enUS"] = "Mists of Pandaria",
		["itIT"] = "Mists of Pandaria",
		["ptBR"] = "Mists of Pandaria",
		["ruRU"] = "Mists of Pandaria",
		["frFR"] = "Mists of Pandaria",
		["esMX"] = "Mists of Pandaria",
		["deDE"] = "Mists of Pandaria",
		["esES"] = "Mists of Pandaria",
		["koKR"] = "판다리아의 안개",
		["zhCN"] = "熊猫人之谜",
		["zhTW"] = "潘達利亞之謎",
	},	
	["Cata"] = {
		["enUS"] = "Cataclysm",
		["itIT"] = "Cataclysm",
		["ptBR"] = "Cataclysm",
		["ruRU"] = "Cataclysm",
		["frFR"] = "Cataclysm",
		["esMX"] = "Cataclysm",
		["deDE"] = "Cataclysm",
		["esES"] = "Cataclysm",
		["koKR"] = "대격변",
		["zhCN"] = "大地的裂变",
		["zhTW"] = "浩劫與重生",
	},	
	["Wrath"] = {
		["enUS"] = "Wrath of the Lich King",
		["itIT"] = "Wrath of the Lich King",
		["ptBR"] = "Wrath of the Lich King",
		["ruRU"] = "Wrath of the Lich King",
		["frFR"] = "Wrath of the Lich King",
		["esMX"] = "Wrath of the Lich King",
		["deDE"] = "Wrath of the Lich King",
		["esES"] = "Wrath of the Lich King",
		["koKR"] = "리치 왕의 분노",
		["zhCN"] = "巫妖王之怒",
		["zhTW"] = "巫妖王之怒",
	},	
}
function ns.GetGroupFromID ( ID, lang )
	if not headings then return nil; end;
	if not headings[ID] then return nil; end;	
	return headings[ID][lang];
end;
function ns.GetToonsWithCurrency(group, cur)
	local ret = {};
	if GoldCofferCurrencies and GoldCofferCurrencies[group] and GoldCofferCurrencies[group][cur] then
		for k,v in pairs (GoldCofferCurrencies[group][cur]) do
			if v > 0 and k ~= "iconFileID" then tinsert(ret, k); end;
		end;	
	end;	
	sort(ret)
	return ret;
end;
local function SaveCurrency(groupID, id, iconFileID, toon, qty)
	GoldCofferCurrencies = GoldCofferCurrencies or {};
	GoldCofferCurrencies[groupID] = GoldCofferCurrencies[groupID] or {};
	GoldCofferCurrencies[groupID][id] = GoldCofferCurrencies[groupID][id] or {};
	GoldCofferCurrencies[groupID][id]["iconFileID"] = iconFileID;	
	GoldCofferCurrencies[groupID][id][toon] = qty;
end;
function ns.UpdateCurrency()
	local group = "Ungrouped";	
	local groupID = "Ungrouped";
	local toon = GetRealmName() .. "-" .. UnitName("player");
	if GoldCofferCurrency and GoldCofferCurrency.Currency then GoldCofferCurrency.Currency = nil; end;	
	local ls = C_CurrencyInfo.GetCurrencyListSize();
	for i = 1,ls do
		local cl = C_CurrencyInfo.GetCurrencyListLink(i);
		if cl then
			local id = C_CurrencyInfo.GetCurrencyIDFromLink(cl);
			local curInfo = C_CurrencyInfo.GetCurrencyInfo(id);			
			SaveCurrency(groupID, id, curInfo.iconFileID, toon, curInfo.quantity);
		else
			local link = C_CurrencyInfo.GetCurrencyListInfo(i);
			groupID = ns.GetGroupID(link.name)
		end;
	end; 
end;
