-- Edited Apr 10, 2023 

local Addon, ns = ...;
local groups = {	
	"Dragonflight",
	"Dungeon and Raid",
	"Player vs. Player", 
	"Miscellaneous",
	"Shadowlands",
	"Battle for Azeroth",
	"Legion",
	"Warlords of Draenor",
	"Mists of Pandaria",
	"Cataclysm",
	"Wrath of the Lich King",
	"Burning Crusade"
}
local function SaveCurrencyOLD(group, name, toon, qty, icon)
	GoldCofferCurrency = GoldCofferCurrency or {};
	GoldCofferCurrency[group] = GoldCofferCurrency[group] or {};
	GoldCofferCurrency[group][name] = GoldCofferCurrency[group][name] or {};
	GoldCofferCurrency[group][name][toon] = qty; 
	GoldCofferCurrencyIcon = GoldCofferCurrencyIcon or {};
	GoldCofferCurrencyIcon[name] = icon;
end;
local function GetIcon(id)
	local ci = C_CurrencyInfo.GetCurrencyInfo(id)
	local color = ci.quality and ITEM_QUALITY_COLORS[ci.quality].hex or ""
	return (ci.iconFileID and "|T"..ci.iconFileID..":12|t " or "") .. color .. ci.name .. "|r";
end;
function ns.GetCurrencyGroupList()
	local ret = {};		
	local idx = 1;
	if GoldCofferCurrency then
		for k,v in pairs (GoldCofferCurrency) do
			local flag = true;
			for i=1, #groups do
				if k == groups[i] then flag = false; break; end;
			end;
			if flag then ret[idx] = k; idx = idx + 1; end;
		end;	
		idx = idx -1;
		for i=1, #groups do ret[idx + i] = groups[i]; end;
	end;	
	return ret;
end;
function ns.GetGroupsCurrencyList(group)
	local ret = {};
	if GoldCofferCurrency and GoldCofferCurrency[group] then
		for k,v in pairs (GoldCofferCurrency[group]) do
			tinsert(ret, k);
		end;	
	end;	
	return ret;
end;
function ns.GetToonsWithCurrencyOLD(group, cur)
	local ret = {};
	if GoldCofferCurrency and GoldCofferCurrency[group] and GoldCofferCurrency[group][cur] then
		for k,v in pairs (GoldCofferCurrency[group][cur]) do
			if v > 0 then tinsert(ret, k); end;
		end;	
	end;	
	sort(ret)
	return ret;
end;
