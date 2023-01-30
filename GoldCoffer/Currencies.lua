local Addon, ns = ...;

local function SaveCurrency(group, name, toon, qty)
	GoldCofferCurrency = GoldCofferCurrency or {};
	GoldCofferCurrency[group] = GoldCofferCurrency[group] or {};
	GoldCofferCurrency[group][name] = GoldCofferCurrency[group][name] or {};
	GoldCofferCurrency[group][name][toon] = qty; 
end;

function ns.UpdateCurrency()
--	Step through this toons currencies and save them to the table 
	local ls, name, count;
	local group = "Ungrouped";
	local toon = ns.srv .. "-" .. ns.player;
	
	--Clean up some old data
	if GoldCofferCurrency and GoldCofferCurrency.Currency then GoldCofferCurrency.Currency = nil; end;	
	ls = C_CurrencyInfo.GetCurrencyListSize();
	print ("Currency list size is ", ls);
	for i = 1,ls do
		--get the name and amount for each one
		local ci = C_CurrencyInfo.GetCurrencyListInfo(i)
		name = ci.name;
		count = ci.quantity;
		--if this is a header then save the name as group
		if ci.isHeader then group = name; end;
		--no count on header so don't save, group will remain set 
		if count and count > 1 then SaveCurrency(group, name, toon, count); end;
	end; --/for(i)
end;

-- function ns.UpdateCurrency()
	-- --step through each currency
	-- local ls, name, count, header
	-- GoldCofferCurrencies = GoldCofferCurrencies or {};
	-- ls = C_CurrencyInfo.GetCurrencyListSize();
	-- for i = 1,ls do
		-- --get the name and amount for each one
		-- name = C_CurrencyInfo.GetCurrencyListInfo(i).name;
		-- count = C_CurrencyInfo.GetCurrencyListInfo(i).quantity;
		-- header = C_CurrencyInfo.GetCurrencyListInfo(i).isHeader
		-- local toon = ns.srv .. "-" .. ns.player
		-- if count and count > 1 then
				-- GoldCofferCurrencies.Currency = GoldCofferCurrencies.Currency or {};
				-- GoldCofferCurrencies.Currency[name] = GoldCofferCurrencies.Currency[name] or {};
				-- GoldCofferCurrencies.Currency[name][toon] = count; 
		-- end --/if count
	-- end --/for(i)
-- end

function ns.GetCurrencies()
	local ret = {};
	if GoldCofferCurrencies and GoldCofferCurrencies.Currency then
		for k,v in pairs (GoldCofferCurrencies.Currency) do
			tinsert(ret, k);
		end;	--/for
	end;	--/if
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
				end;  -- /for t,q
				return tbl;
			end;	--/if k
		end;	--/for k,v
	end;	--/if table exists
	return tbl;
end;