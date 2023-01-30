local Addon, ns = ...;

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

function ns.GetCurrencies()
	local ret = {};
	if GoldCofferCurrencies and GoldCofferCurrencies.Currency then
		for k,v in pairs (GoldCofferCurrencies.Currency) do
			tinsert(ret, k);
		end;	
	end;	
	sort(ret);
	return ret;
end;

function ns.GetToonsWith(curr)
	local tbl = {};
	if GoldCofferCurrencies and GoldCofferCurrencies.Currency then
		for k,v in pairs (GoldCofferCurrencies.Currency) do
			if k == curr then
				for t,q in pairs(v) do
					tbl[t] = q;
				end; 
				return tbl;
			end;	
		end;	
	end;	
	return tbl;
end;