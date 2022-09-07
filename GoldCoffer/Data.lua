
local addon, ns = ...

function ns:updateGold()
	-- initializes table structure if none exists
	
	-- updates this toons gold
	ns.player = UnitName("player");
	ns.srv = GetRealmName();
	GoldCoffer = GoldCoffer or {};
	GoldCoffer.Servers = GoldCoffer.Servers or {};
	GoldCoffer.Servers[ns.srv] = GoldCoffer.Servers[ns.srv] or {};
	GoldCoffer.Servers[ns.srv][ns.player] = GetMoney();
	
	--Date history data
	local curTime = time();
	local curGold = ns:GetTotalGold(false);
	local resetDay = curTime + C_DateAndTime.GetSecondsUntilDailyReset();
	local resetWeek = curTime + C_DateAndTime.GetSecondsUntilWeeklyReset();
	
	--Initialize tables in a new database
	GoldCoffer.History = GoldCoffer.History or {};
	GoldCoffer.History.Today = GoldCoffer.History.Today or curGold;
	GoldCoffer.History.Yesterday = GoldCoffer.History.Yesterday or curGold;
	GoldCoffer.History.LastWeek = GoldCoffer.History.LastWeek or curGold;
	GoldCoffer.History.Resets = GoldCoffer.History.Resets or {};
	GoldCoffer.History.Resets.Day = GoldCoffer.History.Resets.Day or resetDay;
	GoldCoffer.History.Resets.Week = GoldCoffer.History.Resets.Week or resetWeek;
	
	--Check to see if we have passed a daily reset and advance data if we have
	if GoldCoffer.History.Resets.Day < resetDay then
		GoldCoffer.History.Yesterday = curGold;
		--GoldCoffer.History.Today = curGold;		--	when the day advances don't advance Today (This session)
		GoldCoffer.History.Resets.Day = resetDay;
	end;

	--Check to see if we have passed a weekly reset and advance data if we have
	if GoldCoffer.History.Resets.Week < resetWeek then		
		GoldCoffer.History.LastWeek = curGold;		
		GoldCoffer.History.Resets.Week = resetWeek;
	end;
end;

function ns:GetServers()
	--returns a table containing all servers in the data table sorted alphabetically 
	local s = {};
	for k, v in pairs (GoldCoffer.Servers) do
		table.insert(s, k);
	end;
	table.sort(s);
	return s;	
end;

function ns:GetTotalGold(iconFlag)
	--iconFlag:	- true return is formated with icons for gold silver copper
	--			- false of nil returns total in copper
	local tg = 0;	
	local s = ns:GetServers();
	for k, v in pairs(GoldCoffer.Servers) do
		for t, g in pairs(GoldCoffer.Servers[k]) do
			tg = tg + g;
		end; 	--in pairs t,g
	end;	--in pairs k,v
	if iconFlag then tg = ns:GoldSilverCopper(tg); end;
	return tg;
end;

function ns:GetServerGold(s, iconFlag)
	--iconFlag:	- true return is formated with icons for gold silver copper
	--			- false of nil returns total in copper
	local sg = 0;
	for t, g in pairs(GoldCoffer.Servers[s]) do
		sg = sg + g;
	end; 	--in pairs t,g	
	if iconFlag then sg = ns:GoldSilverCopper(sg); end;
	return sg;
end;

local function ProfitLossColoring(gold)
	if gold < 0 then return ns:colorString("red", ns:GoldSilverCopper(gold)); end;
	return ns:colorString("green", ns:GoldSilverCopper(gold));
end;

function ns:GetTodaysChange()
	local curGold = ns:GetTotalGold(false);
	local diff = curGold - GoldCoffer.History.Today or curGold;
	return ProfitLossColoring(diff);
end;

function ns:GetYesterdaysChange()
	local curGold = ns:GetTotalGold(false);
	local diff = curGold - GoldCoffer.History.Yesterday or curGold;
	return ProfitLossColoring(diff);
end;

function ns:GetWeeksChange()
	local curGold = ns:GetTotalGold(false);
	local diff = curGold - GoldCoffer.History.LastWeek or curGold;
	return ProfitLossColoring(diff);	
end;