-- Edited Jun 20, 2023

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
local saveDays = 50;
local saveWeeks = 50;
local saveMonths = 25;
local saveYears = 10;
local function GetNextMonthTime(t)
	local ret = t;							
	local chunk = 1000000;					
	local m = tonumber(date("%m", t)) + 1;	
	if m == 13 then m = 1; end;				
	while chunk > 1 do
		while m ~= tonumber(date("%m", ret)) do
			ret = ret + chunk;
		end;
		ret = ret - chunk;					
		chunk = floor(chunk /10);				
	end;
	ret = ret + 60;	
	return ret;
end;
local function GetNextYearTime(t)
	local ret = t;							
	local chunk = 10000000;					
	local m = date("%Y", t) + 1;			
	while chunk > 1 do
		while m > tonumber(date("%Y", ret)) do
			ret = ret + chunk;
		end;
		ret = ret - chunk;					
		chunk = floor(chunk /10);			
	end;
	ret = ret + 60;
	return ret;
end;
local function UpdateDayDetail(curGold)
	local key = month[tonumber(date("%m"))] .. date("%d");
	local one = "1";
	if GoldCoffer.History.Day["1"] ~= nil then
		for k,v in pairs(GoldCoffer.History.Day[tostring("1")]) do
			if k == key then GoldCoffer.History.Day[tostring("1")] = {[key] = curGold};	return; end;
		end;
		local i = saveDays
		while i > 0 do
			local copyFrom = tostring(i);
			local copyTo = tostring(i + 1);			
			if GoldCoffer.History.Day[copyFrom] ~= nil then GoldCoffer.History.Day[copyTo] = GoldCoffer.History.Day[copyFrom]; end;
			i = i - 1;
		end;
	end;
	GoldCoffer.History.Day["1"] = {[key] = curGold};
end;
local function UpdateWeekDetail(curGold)
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
	local curTime = time();
	local resetDay = curTime + C_DateAndTime.GetSecondsUntilDailyReset();
	local resetWeek = curTime + C_DateAndTime.GetSecondsUntilWeeklyReset();
	local resetMonth = GetNextMonthTime(curTime);
	local resetYear = GetNextYearTime(curTime);	
	for s, v in pairs(GoldCoffer.Servers) do
		for t, v in pairs (v) do
			local m = GoldCoffer.Servers[s][t].Current;
			if GoldCoffer.History.Resets.Day < time() then 
				GoldCoffer.Servers[s][t].Yesterday = m - GoldCoffer.Servers[s][t].DayStart;
				GoldCoffer.Servers[s][t].DayStart = m; 
			end;
			if GoldCoffer.History.Resets.Week < time() then	 
				GoldCoffer.Servers[s][t].LastWeek = m - GoldCoffer.Servers[s][t].WeekStart;
				GoldCoffer.Servers[s][t].WeekStart = m; 
			end;
			if GoldCoffer.History.Resets.Month < time() then
				GoldCoffer.Servers[s][t].LastMonth = m - GoldCoffer.Servers[s][t].MonthStart;
				GoldCoffer.Servers[s][t].MonthStart = m; 
			end;
			if GoldCoffer.History.Resets.Year < time() then 
				GoldCoffer.Servers[s][t].LastYear = m - GoldCoffer.Servers[s][t].DayStart;
				GoldCoffer.Servers[s][t].YearStart = m; 
			end;
		end;
	end;	
	if GoldCoffer.History.Resets.Day < time() then
		UpdateDayDetail(curGold);
		GoldCoffer.History.Resets.Day = resetDay;
	end;
	if GoldCoffer.History.Resets.Week < time() then	
		UpdateWeekDetail(curGold);	
		GoldCoffer.History.Resets.Week = resetWeek;
	end;
	if GoldCoffer.History.Resets.Month < time() then
		UpdateMonthDetail(curGold);
		GoldCoffer.History.Resets.Month = resetMonth;
	end;
	if GoldCoffer.History.Resets.Year < time() then
		UpdateYearDetail(curGold);
		GoldCoffer.History.Resets.Year = resetYear;
	end;
end;
local function newRecord(srv, toon, gold)
	GoldCoffer.Servers[srv][toon] = {};
	GoldCoffer.Servers[srv][toon].Current = gold;
	GoldCoffer.Servers[srv][toon].SessionStart = gold;
	GoldCoffer.Servers[srv][toon].DayStart = 0;
	GoldCoffer.Servers[srv][toon].WeekStart = 0;
	GoldCoffer.Servers[srv][toon].MonthStart = 0;
	GoldCoffer.Servers[srv][toon].YearStart = 0;	
	GoldCoffer.Servers[srv][toon].Yesterday = 0;
	GoldCoffer.Servers[srv][toon].LastWeek = 0;
	GoldCoffer.Servers[srv][toon].LastMonth = 0;
	GoldCoffer.Servers[srv][toon].LastYear = 0;
end;
function ns:iniData()
	local t = time() - (24 * 60 * 60);
	local key1 = month[tonumber(date("%m"))] .. date("%d");
	local key2 = month[tonumber(date("%m", t))] .. date("%d", t);
	local yearKey1 = "December 31, " .. date("%Y");
	local yearKey2 = "December 31, " .. date("%Y", time()) - 1;
	ns.player = UnitName("player");
	ns.srv = GetRealmName();
	GoldCoffer = GoldCoffer or {};
	GoldCoffer.Servers = GoldCoffer.Servers or {};
	GoldCoffer.Servers[ns.srv] = GoldCoffer.Servers[ns.srv] or {};
	GoldCoffer.Servers[ns.srv][ns.player] = GoldCoffer.Servers[ns.srv][ns.player] or {};
	if (type(GoldCoffer.Servers[ns.srv][ns.player]) ~= "table") then 
		for k, v in pairs(GoldCoffer.Servers) do
			for toon, gold in pairs(v) do
				local m = GoldCoffer.Servers[k][toon] or 0;
				if toon == ns.player then m = GetMoney(); end;
				newRecord(k, toon, m)				
			end;
		end;			
	end;
	if GoldCoffer.Servers[ns.srv][ns.player].Current == nil then
		newRecord(ns.srv, ns.player, GetMoney());
	else
		GoldCoffer.Servers[ns.srv][ns.player].SessionStart = GetMoney();
		GoldCoffer.Servers[ns.srv][ns.player].Current = GetMoney();
	end;
	local curGold = ns:GetTotalGold(false);		
	local curTime = time();
	local resetDay = curTime + C_DateAndTime.GetSecondsUntilDailyReset();
	local resetWeek = curTime + C_DateAndTime.GetSecondsUntilWeeklyReset();
	local resetMonth = GetNextMonthTime(curTime);
	local resetYear = GetNextYearTime(curTime);	
	GoldCoffer.History = GoldCoffer.History or {};
	GoldCoffer.History.Resets = GoldCoffer.History.Resets or {};
	GoldCoffer.History.Resets.Day = GoldCoffer.History.Resets.Day or resetDay;
	GoldCoffer.History.Resets.Week = GoldCoffer.History.Resets.Week or resetWeek;
	GoldCoffer.History.Resets.Month = GoldCoffer.History.Resets.Month or resetMonth;
	if GoldCoffer.History.Resets.Month > resetMonth then GoldCoffer.History.Resets.Month = resetMonth; end;
	GoldCoffer.History.Resets.Year = GoldCoffer.History.Resets.Year or resetYear;
	if GoldCoffer.History.Resets.Year > resetYear then GoldCoffer.History.Resets.Year = resetYear; end;
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
	ns.player = UnitName("player");
	ns.srv = GetRealmName();
	GoldCoffer = GoldCoffer or {};
	GoldCoffer.Servers = GoldCoffer.Servers or {};
	GoldCoffer.Servers[ns.srv] = GoldCoffer.Servers[ns.srv] or {};	
	if GoldCoffer.Servers[ns.srv][ns.player] == nil then
		newRecord(ns.srv, ns.player, GetMoney())
	end;
	GoldCoffer.Servers[ns.srv][ns.player].Current = GetMoney();	
	checkResets(ns:GetTotalGold(false));
end;
function ns:GetServers()
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
function ns:GetTotalGold(iconFlag) 
	local tg = 0;	
	local s = ns:GetServers();
	for k, v in pairs(GoldCoffer.Servers) do
		for t, g in pairs(GoldCoffer.Servers[k]) do
			tg = tg + (g.Current or 0);
		end; 	
	end;	
	if iconFlag then tg = ns:GoldSilverCopper(tg); end;
	return tg;
end;
function ns:GetServerGold(s, iconFlag) 
	local sg = 0;
	for t, toon in pairs(GoldCoffer.Servers[s]) do
		sg = sg + (toon.Current or 0);
	end; 	
	if iconFlag then sg = ns:GoldSilverCopper(sg); end;
	return sg;
end;
function ns:GetYesterdaysGold(formatFlag)
	for _,v in pairs (GoldCoffer.History.Day["2"]) do
		if formatFlag then return ns:ProfitLossColoring(v)
		else return v; end;
	end;
	return 0;
end;
function ns:GetLastWeeksGold(formatFlag)
	for _,v in pairs (GoldCoffer.History.Week["2"]) do
		if formatFlag then return ns:ProfitLossColoring(v)
		else return v; end;
	end;
	return 0;
end;
function ns:GetLastMonthsGold(formatFlag)
	for _,v in pairs (GoldCoffer.History.Month["2"]) do
		if formatFlag then return ns:ProfitLossColoring(v)
		else return v; end;
	end;
	return 0;
end;
function ns:GetLastYearsGold(formatFlag)
	for _,v in pairs (GoldCoffer.History.Year["2"]) do
		if formatFlag then return ns:ProfitLossColoring(v)
		else return v; end;
	end;
	return 0;
end;
function ns:GetSessionChange()
	local curGold = ns:GetTotalGold(false);
	local diff = curGold - GoldCoffer.History.Today;
	return ns:ProfitLossColoring(diff);
end;
function ns:GetYesterdaysChange()
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
function ns:GetToonHistory(name)
	local ret = {};
	local temp = GoldCoffer.Servers[ns.srv][name]
	ret.session = ns:ProfitLossColoring(GetMoney() - temp.SessionStart);
	ret.today = ns:ProfitLossColoring(GetMoney() - temp.DayStart);
	ret.week = ns:ProfitLossColoring(GetMoney() - temp.WeekStart);
	ret.month = ns:ProfitLossColoring(GetMoney() - temp.MonthStart);
	ret.yesterday = ns:ProfitLossColoring(temp.Yesterday);
	ret.lweek = ns:ProfitLossColoring(temp.LastWeek);
	ret.lmonth = ns:ProfitLossColoring(temp.LastMonth);
	ret.lyear = ns:ProfitLossColoring(temp.LastYear);
	return ret;
end;
function ns:GetServerHistory(srv)
	local ret = {};
	local current, sessionS, yesterday, dayS, weekS, monthS, yearS, lweek, lmonth, lyear = 0,0,0,0,0,0,0,0,0,0;
	local temp = GoldCoffer.Servers[srv];
	for k,v in pairs(temp) do
		current = current + v.Current;
		sessionS = sessionS + v.SessionStart;
		yesterday = yesterday + v.Yesterday;
		dayS  = dayS  + v.DayStart;
		weekS = weekS + v.WeekStart;
		monthS = monthS + v.MonthStart;
		yearS = yearS + v.YearStart;
		lweek = lweek + v.LastWeek;
		lmonth = lmonth + v.LastMonth;
		lyear = lyear + v.LastYear;
	end;
	ret.session = ns:ProfitLossColoring(GetMoney() - GoldCoffer.Servers[ns.srv][ns.player].SessionStart);
	ret.today = ns:ProfitLossColoring(current - dayS);
	ret.week = ns:ProfitLossColoring(current - weekS);
	ret.month = ns:ProfitLossColoring(current - monthS);
	ret.yesterday = ns:ProfitLossColoring(yesterday);
	ret.lweek = ns:ProfitLossColoring(lweek);
	ret.lmonth = ns:ProfitLossColoring(lmonth);
	ret.lyear = ns:ProfitLossColoring(lyear);
	return ret;
end;
