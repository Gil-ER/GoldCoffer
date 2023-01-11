local Addon, ns = ...;

function ns.UpdateCurrency()
	--step through each currency
	local ls, name, count
	GoldCofferCurrencies = GoldCofferCurrencies or {};
	ls = C_CurrencyInfo.GetCurrencyListSize();
	for i = 1,ls do
		--get the name and amount for each one
		name = C_CurrencyInfo.GetCurrencyListInfo(i).name;
		count = C_CurrencyInfo.GetCurrencyListInfo(i).quantity;
		local toon = ns.srv .. "-" .. ns.player
		if count ~= nil and count > 0 then
			GoldCofferCurrencies.Currency = GoldCofferCurrencies.Currency or {};
			GoldCofferCurrencies.Currency[name] = GoldCofferCurrencies.Currency[name] or {};
			GoldCofferCurrencies.Currency[name][toon] = count; 
		end --/if count
	end --/for(i)
end

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