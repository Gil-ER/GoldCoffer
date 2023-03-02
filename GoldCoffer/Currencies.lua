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

local function SaveCurrency(group, name, toon, qty)
	GoldCofferCurrency = GoldCofferCurrency or {};
	GoldCofferCurrency[group] = GoldCofferCurrency[group] or {};
	GoldCofferCurrency[group][name] = GoldCofferCurrency[group][name] or {};
	GoldCofferCurrency[group][name][toon] = qty; 
end;

function ns.UpdateCurrency()
	local ls, name, count;
	local group = "Ungrouped";
	local toon = ns.srv .. "-" .. ns.player;

	if GoldCofferCurrency and GoldCofferCurrency.Currency then GoldCofferCurrency.Currency = nil; end;	
	ls = C_CurrencyInfo.GetCurrencyListSize();
	for i = 1,ls do
		local ci = C_CurrencyInfo.GetCurrencyListInfo(i)
		name = ci.name;
		count = ci.quantity;
		if ci.isHeader then group = name; end;
		if count and count > 1 then SaveCurrency(group, name, toon, count); end;
	end; 
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
function ns.GetToonsWithCurrency(group, cur)
	local ret = {};
	if GoldCofferCurrency and GoldCofferCurrency[group] and GoldCofferCurrency[group][cur] then
		for k,v in pairs (GoldCofferCurrency[group][cur]) do
			if v > 0 then tinsert(ret, k); end;
		end;
	end;	
	sort(ret)
	return ret;
end;
