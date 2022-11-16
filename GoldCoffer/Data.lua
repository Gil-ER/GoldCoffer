
local addon, ns = ...
local month = {
	[1] = "January ",
	[2] = "February ",
	[3] = "March ",
	[4] = "April ",
	[5] = "May ",
	[6] = "June ",
	[7] = "July ",
	[8] = "August ",
	[9] = "September ",
	[10] = "October ",
	[11] = "November ",
	[12] = "December "
}
-- limits for the number of each time intervals to save
local saveDays = 50;
local saveWeeks = 50;
local saveMonths = 25;
local saveYears = 10;

local function GetNextMonthTime(t)
	--returns the next time of the start of the next month
	local ret = t;
	local sub = 1000000;
	local m = date("%m", t) + 1;
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
	--returns the time at the start of the next year
	local ret = t;
	local sub = 10000000;
	local m = date("%m", t) + 1;
	while sub > 1 do
		while m > tonumber(date("%m", ret)) do
			ret = ret + sub;
		end;
		ret = ret - sub;
		sub = floor(sub /10);
	end;
	return ret;
end;

local function UpdateDayDetail(curGold)
	--Call when a day threashold is passed
	--copies todays data into element ["1"] after bumpint all other data down a row
	local key = month[tonumber(date("%m"))] .. date("%d");
	local one = "1";
	if GoldCoffer.History.Day[one] ~= nil then
		for k,v in pairs(GoldCoffer.History.Day[tostring(one)]) do
			if k == key then GoldCoffer.History.Day[tostring(one)] = {[key] = curGold};	return; end;
		end;
		local i = saveDays
		while i > 0 do
			local copyFrom = tostring(i);
			local copyTo = tostring(i + 1);			
			if GoldCoffer.History.Day[copyFrom] ~= nil then GoldCoffer.History.Day[copyTo] = GoldCoffer.History.Day[copyFrom]; end;
			i = i - 1;
		end;
	end;
	GoldCoffer.History.Day[one] = {[key] = curGold};
end;

local function UpdateWeekDetail(curGold)
	--Call when a week threashold is passed
	--copies todays data into element ["1"] after bumpint all other data down a row
	local key = month[tonumber(date("%m"))] .. date("%d");
	local one = "1";
	if GoldCoffer.History.Week[one] ~= nil then
		for k,v in pairs(GoldCoffer.History.Week[tostring(one)]) do
			if k == key then GoldCoffer.History.Week[tostring(one)] = {[key] = curGold};	return; end;
		end;
		local i = saveWeeks;
		while i > 0 do
			local copyFrom = tostring(i);
			local copyTo = tostring(i + 1);			
			if GoldCoffer.History.Week[copyFrom] ~= nil then GoldCoffer.History.Week[copyTo] = GoldCoffer.History.Week[copyFrom]; end;
			i = i - 1;
		end;
	end;
	GoldCoffer.History.Week[one] = {[key] = curGold};
end;

local function UpdateMonthDetail(curGold)	
	--Call when a month threashold is passed
	--copies todays data into element ["1"] after bumpint all other data down a row
	local key = month[tonumber(date("%m"))] .. date("%d");
	local one = "1";
	if GoldCoffer.History.Month[one] ~= nil then
		for k,v in pairs(GoldCoffer.History.Month[tostring(one)]) do
			if k == key then GoldCoffer.History.Month[tostring(one)] = {[key] = curGold};	return; end;
		end;
		local i = saveMonths;
		while i > 0 do
			local copyFrom = tostring(i);
			local copyTo = tostring(i + 1);			
			if GoldCoffer.History.Month[copyFrom] ~= nil then GoldCoffer.History.Month[copyTo] = GoldCoffer.History.Month[copyFrom]; end;
			i = i - 1;
		end;
	end;
	GoldCoffer.History.Month[one] = {[key] = curGold};
end;

local function UpdateYearDetail(curGold)
	--Call when a year threashold is passed
	--copies todays data into element ["1"] after bumpint all other data down a row
	local key = "December 31, " .. date("%Y");
	local one = "1";
	if GoldCoffer.History.Year[one] ~= nil then
		for k,v in pairs(GoldCoffer.History.Year[tostring(one)]) do
			if k == key then GoldCoffer.History.Year[tostring(one)] = {[key] = curGold};	return; end;
		end;
		local i = saveYears;
		while i > 0 do
			local copyFrom = tostring(i);
			local copyTo = tostring(i + 1);			
			if GoldCoffer.History.Year[copyFrom] ~= nil then GoldCoffer.History.Year[copyTo] = GoldCoffer.History.Year[copyFrom]; end;
			i = i - 1;
		end;
	end;
	GoldCoffer.History.Year[one] = {[key] = curGold};
end;

local function checkResets(curGold)
	--Reset time is the time the next reset would happen after now
	local curTime = time();
	local resetDay = curTime + C_DateAndTime.GetSecondsUntilDailyReset();
	local resetWeek = curTime + C_DateAndTime.GetSecondsUntilWeeklyReset();
	local resetMonth = GetNextMonthTime(curTime);
	local resetYear = GetNextYearTime(curTime);	
	
	--Check to see if we have passed a daily reset and advance data if we have
	if GoldCoffer.History.Resets.Day < time() then
		UpdateDayDetail(curGold);
		GoldCoffer.History.Resets.Day = resetDay;
	end;
	--Check to see if we have passed a weekly reset and advance data if we have
	if GoldCoffer.History.Resets.Week < time() then	
		UpdateWeekDetail(curGold);	
		GoldCoffer.History.Resets.Week = resetWeek;
	end;
	--Check to see if we have passed a daily reset and advance data if we have
	if GoldCoffer.History.Resets.Month < time() then
		UpdateMonthDetail(curGold);
		GoldCoffer.History.Resets.Month = resetMonth;
	end;
	--Check to see if we have passed a weekly reset and advance data if we have
	if GoldCoffer.History.Resets.Year < time() then
		UpdateYearDetail(curGold);
		GoldCoffer.History.Resets.Year = resetYear;
	end;
end;

function ns:iniData()
	--initializes the table
	local t = time() - (24 * 60 * 60);
	local key1 = month[tonumber(date("%m"))] .. date("%d");
	local key2 = month[tonumber(date("%m", t))] .. date("%d", t);
	local yearKey1 = "December 31, " .. date("%Y");
	local yearKey2 = "December 31, " .. date("%Y", time()) - 1;

	-- updates this toons gold
	ns.player = UnitName("player");
	ns.srv = GetRealmName();
	GoldCoffer = GoldCoffer or {};
	GoldCoffer.Servers = GoldCoffer.Servers or {};
	GoldCoffer.Servers[ns.srv] = GoldCoffer.Servers[ns.srv] or {};
	GoldCoffer.Servers[ns.srv][ns.player] = GetMoney();
	
	local curGold = ns:GetTotalGold(false);		--Total current gold
	
	--Reset time is the time the next reset would happen after now
	local curTime = time();
	local resetDay = curTime + C_DateAndTime.GetSecondsUntilDailyReset();
	local resetWeek = curTime + C_DateAndTime.GetSecondsUntilWeeklyReset();
	local resetMonth = GetNextMonthTime(curTime);
	local resetYear = GetNextYearTime(curTime);	
	-- initializes table structure if none exists
	GoldCoffer.History = GoldCoffer.History or {};
	GoldCoffer.History.Resets = GoldCoffer.History.Resets or {};
	GoldCoffer.History.Resets.Day = GoldCoffer.History.Resets.Day or resetDay;
	GoldCoffer.History.Resets.Week = GoldCoffer.History.Resets.Week or resetWeek;
	GoldCoffer.History.Resets.Month = GoldCoffer.History.Resets.Month or resetMonth;
	GoldCoffer.History.Resets.Year = GoldCoffer.History.Resets.Year or resetYear;

	GoldCoffer.History.Day = GoldCoffer.History.Day or {["1"] = {[key1] = curGold}};
	GoldCoffer.History.Week = GoldCoffer.History.Week or {["1"] = {[key1] = curGold}};
	GoldCoffer.History.Month = GoldCoffer.History.Month or {["1"] = {[key1] = curGold}};
	GoldCoffer.History.Year = GoldCoffer.History.Year or {["1"] = {[yearKey1] = curGold}};
	local g;
	if GoldCoffer.History.Today ~= nil then GoldCoffer.History.Today = nil; end;
	if GoldCoffer.History.Yesterday == nil then g = 0; else g = GoldCoffer.History.Yesterday; GoldCoffer.History.Yesterday = nil; end;
	GoldCoffer.History.Day["2"] = GoldCoffer.History.Day["2"] or {[key2] = g};
	if GoldCoffer.History.LastWeek == nil then g = 0; else g = GoldCoffer.History.LastWeek; GoldCoffer.History.LastWeek = nil; end;
	GoldCoffer.History.Week["2"] = GoldCoffer.History.Week["2"] or {[key2] = g};
	GoldCoffer.History.Month["2"] = GoldCoffer.History.Month["2"] or {[key2] = 0};
	GoldCoffer.History.Year["2"] = GoldCoffer.History.Year["2"] or {[yearKey2] = 0};
	
	checkResets(curGold);	
end;

function ns:updateGold()
	-- updates this toons gold
	ns.player = UnitName("player");
	ns.srv = GetRealmName();
	GoldCoffer = GoldCoffer or {};
	GoldCoffer.Servers = GoldCoffer.Servers or {};
	GoldCoffer.Servers[ns.srv] = GoldCoffer.Servers[ns.srv] or {};
	GoldCoffer.Servers[ns.srv][ns.player] = GetMoney();
	--Check to see if we have passed a daily reset and advance data if we have
	checkResets(ns:GetTotalGold(false));
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


function ns:ProfitLossColoring(gold)
	if gold < 0 then return ns:colorString("red", ns:GoldSilverCopper(gold)); end;
	return ns:colorString("green", ns:GoldSilverCopper(gold));
end;

----------------------------------------------------------------------------------------
--		Functions that return gold totals
----------------------------------------------------------------------------------------
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

function ns:GetYesterdaysGold(formatFlag)
	--Returns closing balance the last day played
	for _,v in pairs (GoldCoffer.History.Day["2"]) do
		if formatFlag then return ns:ProfitLossColoring(v)
		else return v; end;
	end;
	return 0;
end;

function ns:GetLastWeeksGold(formatFlag)
	--Returns closing balance the last day played
	for _,v in pairs (GoldCoffer.History.Week["2"]) do
		if formatFlag then return ns:ProfitLossColoring(v)
		else return v; end;
	end;
	return 0;
end;

function ns:GetLastMonthsGold(formatFlag)
	--Returns closing balance the last day played
	for _,v in pairs (GoldCoffer.History.Month["2"]) do
		if formatFlag then return ns:ProfitLossColoring(v)
		else return v; end;
	end;
	return 0;
end;

function ns:GetLastYearsGold(formatFlag)
	--Returns closing balance the last day played
	for _,v in pairs (GoldCoffer.History.Year["2"]) do
		if formatFlag then return ns:ProfitLossColoring(v)
		else return v; end;
	end;
	return 0;
end;

function ns:GetSessionChange()
	--returns Profit/Loss this session
	local curGold = ns:GetTotalGold(false);
	local diff = curGold - GoldCoffer.History.Today;
	return ns:ProfitLossColoring(diff);
end;

function ns:GetYesterdaysChange()
	--Returns Profit/Loss since yesterday
	local diff = ns:GetTotalGold(false) - ns:GetYesterdaysGold(false);
	return ns:ProfitLossColoring(diff);
end;

function ns:GetWeeksChange()
	local diff = ns:GetTotalGold(false) - ns:GetLastWeeksGold(false);
	return ns:ProfitLossColoring(diff);	
end;

function ns:GetMonthsChange()
	local diff = ns:GetTotalGold(false) - ns:GetLastMonthsGold(false);
	return ns:ProfitLossColoring(diff);	
end;

function ns:GetYearsChange()
	local diff = ns:GetTotalGold(false) - ns:GetLastYearsGold(false);
	return ns:ProfitLossColoring(diff);
end;

