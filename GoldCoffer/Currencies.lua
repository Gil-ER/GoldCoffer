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
	return ret;
end;

function ns.GetToonsWith(curr)
	local tbl = {};
	if GoldCofferCurrencies and GoldCofferCurrencies.Currency then
		for k,v in pairs (GoldCofferCurrencies.Currency) do
			if k == curr then
				for t,q in pairs(k)
					
				end;  -- /for t,q
			end;	--/if k
		end;	--/for k,v
	
	end;	--/if table exists
	
	local qty;
	local toon;
	
	return qty, toon;
end;