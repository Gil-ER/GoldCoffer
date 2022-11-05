
local addon, ns = ...

local function GetNextMonthTime(t)
	local ret = t;
	local sub = 1000000;
	local m = date("%m", t) + 1;
	if m  == 13 then m = 1; end;
	while sub > 1 do
		while m > tonumber(date("%m", ret)) do
			ret = ret + sub;
		end;
		ret = ret - sub;
		sub = floor(sub /10);
	end;
	return ret;
end;

local function GetNextYearTime(t)
	local ret = t;
	local sub = 10000000;
	local m = date("%m", t) + 1;
	if m  == 13 then m = 1; end;
	while sub > 1 do
		while m > tonumber(date("%m", ret)) do
			ret = ret + sub;
		end;
		ret = ret - sub;
		sub = floor(sub /10);
	end;
	return ret;
end;

local function UpdateMonthDetail(curGold)
	if GoldCoffer.History.Month[1] ~= nil then
		for k,v in pairs(GoldCoffer.History.Month[1]) do
			if k == date("%m/%d/%y") then 
				GoldCoffer.History.Month[1] = {[date("%m/%d/%y")] = curGold}
				return; 
			end;
		end;
	end;
	if GoldCoffer.History.Month[1] ~= nil then
		local i = 30
		while i > 1 do
			if GoldCoffer.History.Month[i] ~= nil then GoldCoffer.History.Month[i + 1] = GoldCoffer.History.Month[i]; end;
			i = i - 1;
		end;
	end;
	print(date("%m/%d,%y"), " = ",curGold)
	GoldCoffer.History.Month[1] = {[date("%m/%d/%y")] = curGold};
end;

local function UpdateYearDetail(curGold)
	if GoldCoffer.History.Year[1] ~= nil then
		for k,v in pairs(GoldCoffer.History.Year[1]) do
			if k == date("%m/%d/%y") then 
				GoldCoffer.History.Year[1] = {[date("%m/%d/%y")] = curGold}
				return; 
			end;
		end;
	end;
	if GoldCoffer.History.Year[1] ~= nil then
		local i = 30
		while i > 1 do
			if GoldCoffer.History.Year[i] ~= nil then GoldCoffer.History.Year[i + 1] = GoldCoffer.History.Year[i]; end;
			i = i - 1;
		end;
	end;
	print(date("%m/%d,%y"), " = ",curGold)
	GoldCoffer.History.Year[1] = {[date("%m/%d/%y")] = curGold};
end;

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
	local curTime = time();						--Current time
	local curGold = ns:GetTotalGold(false);		--Total current gold
	--Reset time is the time the next reset would happen after now
	local resetDay = curTime + C_DateAndTime.GetSecondsUntilDailyReset();
	local resetWeek = curTime + C_DateAndTime.GetSecondsUntilWeeklyReset();
	local resetMonth = GetNextMonthTime(curTime);
	local resetYear = GetNextYearTime(curTime);
	
	--Initialize tables in a new database
	GoldCoffer.History = GoldCoffer.History or {};
	GoldCoffer.History.Today = GoldCoffer.History.Today or 0;
	GoldCoffer.History.Yesterday = GoldCoffer.History.Yesterday or GoldCoffer.History.Today;
	GoldCoffer.History.LastWeek = GoldCoffer.History.LastWeek or GoldCoffer.History.Yesterday;
	GoldCoffer.History.LastMonth = GoldCoffer.History.LastMonth or GoldCoffer.History.LastWeek;
	GoldCoffer.History.LastYear = GoldCoffer.History.LastYear or GoldCoffer.History.LastMonth;
	
	GoldCoffer.History.Previous = GoldCoffer.History.Previous or {};
	GoldCoffer.History.Previous.Day = GoldCoffer.History.Previous.Day or 0;
	GoldCoffer.History.Previous.Week = GoldCoffer.History.Previous.Week or 0;
	GoldCoffer.History.Previous.Month = GoldCoffer.History.Previous.Month or 0;
	GoldCoffer.History.Previous.Year = GoldCoffer.History.Previous.Year or 0;
	
	GoldCoffer.History.Resets = GoldCoffer.History.Resets or {};
	GoldCoffer.History.Resets.Day = GoldCoffer.History.Resets.Day or resetDay;
	GoldCoffer.History.Resets.Week = GoldCoffer.History.Resets.Week or resetWeek;
	GoldCoffer.History.Resets.Month = GoldCoffer.History.Resets.Month or resetMonth;
	GoldCoffer.History.Resets.Year = GoldCoffer.History.Resets.Year or resetYear;
	
	GoldCoffer.History.Month = GoldCoffer.History.Month or {};
	UpdateMonthDetail(curGold);
	
	GoldCoffer.History.Year = GoldCoffer.History.Year or {};
	UpdateYearDetail(curGold);	
	
	--Check to see if we have passed a daily reset and advance data if we have
	if GoldCoffer.History.Resets.Day < resetDay then
		GoldCoffer.History.Previous.Day = curGold - GoldCoffer.History.Yesterday;
		GoldCoffer.History.Yesterday = GoldCoffer.History.Today;
		GoldCoffer.History.Today = curGold;
		GoldCoffer.History.Resets.Day = resetDay;
	end;
	--Check to see if we have passed a weekly reset and advance data if we have
	if GoldCoffer.History.Resets.Week < resetWeek then	
		GoldCoffer.History.Previous.Week = curGold - GoldCoffer.History.LastWeek;
		GoldCoffer.History.LastWeek = curGold;		
		GoldCoffer.History.Resets.Week = resetWeek;
	end;
	--Check to see if we have passed a daily reset and advance data if we have
	if GoldCoffer.History.Resets.Month < resetMonth then
		GoldCoffer.History.Previous.Month = curGold - GoldCoffer.History.LastMonth
		GoldCoffer.History.LastMonth = curGold;
		GoldCoffer.History.Resets.Month = resetMonth;
	end;
	--Check to see if we have passed a weekly reset and advance data if we have
	if GoldCoffer.History.Resets.Year < resetYear then		
		GoldCoffer.History.Previous.Year = curGold - GoldCoffer.History.LastYear;		
		GoldCoffer.History.LastYear = curGold;
		GoldCoffer.History.Resets.Year = resetYear;
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

function ns:GetMonthsChange()
	local curGold = ns:GetTotalGold(false);
	local diff = curGold - GoldCoffer.History.LastMonth or curGold;
	return ProfitLossColoring(diff);	
end;

function ns:GetYearsChange()
	local curGold = ns:GetTotalGold(false);
	local diff = curGold - GoldCoffer.History.LastYear or curGold;
	return ProfitLossColoring(diff);
end;

function ns:GetYesterdayPL()
	return ProfitLossColoring(GoldCoffer.History.Previous.Day);	
end;

function ns:GetLastWeekPL()
	return ProfitLossColoring(GoldCoffer.History.Previous.Week);
end;

function ns:GetLastMonthPL()
	return ProfitLossColoring(GoldCoffer.History.Previous.Month);	
end;

function ns:GetLastYearPL()
	if GoldCoffer.History.Previous.Year == ".." then 
		return GoldCoffer.History.Previous.Year
	else
		return ProfitLossColoring(GoldCoffer.History.Previous.Year);	
	end;
end;

