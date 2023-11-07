-- Edited Nov 06, 2023

local _, ns = ...
local TB_LIMIT = 3;
local tRJ = {};
for i=1, TB_LIMIT do
	tRJ[i] = ns.sChild:CreateFontString(nil, "OVERLAY", "GameFontWhite");
	tRJ[i]:SetJustifyH("RIGHT");
end;
local tLJ = {};
for i=1, TB_LIMIT do
	tLJ[i] = ns.sChild:CreateFontString(nil, "OVERLAY", "GameFontWhite");
	tLJ[i]:SetJustifyH("LEFT");
end;
local function WipeFrame()
	for i=1, TB_LIMIT do
		tRJ[i]:SetText("");
		tRJ[i]:Hide();
		tLJ[i]:SetText("");
		tLJ[i]:Hide();
	end;
end;
function ns.GoldReport()
	WipeFrame();	
	local left = tRJ[1];
	local right = tLJ[1];
	left:Show();
	right:Show();
	left:ClearAllPoints();
	local w = (ns.sChild:GetWidth() - 50 )/2;
	left:SetWidth(w + 30);
	left:SetPoint("TOPLEFT", ns.sChild, "TOPLEFT", 10, -10);
	left:SetTextColor(GameFontWhite:GetTextColor());
	right:ClearAllPoints();
	right:SetWidth(w - 30);
	right:SetPoint("TOPLEFT", left, "TOPRIGHT", 20, 0);
	right:SetTextColor(GameFontNormal:GetTextColor());
	local lText = "Gold per hour";
	local rText = ns:GetGPH(false);
	lText = lText .. "\nTotal gold on this character, " .. ns.player;
	rText = rText .. "\n" .. ns:GoldSilverCopper(GetMoney());
	lText = lText .. "\nTotal gold on this realm, " .. GetRealmName() .. "\n";
	rText = rText .. "\n" .. ns:GetServerGold(GetRealmName(), true) .. "\n"	
	lText = lText .. "~~~~~~~~~~~~~~~~~~~~~~~~\nCurrent Gold\n";
	rText = rText .. "~~~~~~~~~~~~~~~~~~~~~~~~\nCharacter\n";
	local tList = ns:GetToonsInfo(GetRealmName());
	if tList ~= nil then
		for k,v in ipairs(tList) do
			lText = lText .. ns:ProfitLossColoring(v.gold) .. "\n";
			rText = rText .. v.name .. "\n";
		end;
	end;
	lText = lText .. "\nTotal gold on this Account\n";
	rText = rText .. "\n" .. ns:GetTotalGold(true) .. "\n";
	local sList = ns:GetServers();
	local i = 1;
	lText = lText .. ns:colorString("yellow", "\nBreakdown of all servers and Guilds");
	rText = rText .. "\n";	
	while i <= #sList do	
		lText = lText .. "\nTotal Gold on " .. sList[i];
		rText = rText .. "\n" .. ns:GetServerGold(sList[i], true);
		local srv = sList[i]:gsub("%s+", "");
		if GoldCoffer.Guilds and GoldCoffer.Guilds[srv] then
			for k, v in pairs(GoldCoffer.Guilds[srv]) do
				lText = lText .. ns:colorString("green", "\nGuild - " .. k);
				rText = rText .. "\n" .. ns:GoldSilverCopper(v.Current or 0);
			end;
		end;
		i = i + 1;
	end;
	left:SetText(lText);
	right:SetText(rText);
end;
local function HistorySetup()
	WipeFrame();	
	local left = tLJ[1];
	local middle = tRJ[1];
	local right = tRJ[2];	
	left:SetWidth(100);
	left:SetPoint("TOPLEFT", ns.sChild, "TOPLEFT", 30, -00);
	left:SetTextColor(GameFontNormal:GetTextColor());
	middle:SetWidth(190);
	middle:SetPoint("TOPLEFT", left, "TOPRIGHT", 20, 0);
	middle:SetTextColor(GameFontNormal:GetTextColor());	
	right:SetWidth(190);
	right:SetPoint("TOPLEFT", middle, "TOPRIGHT", 20, 0);
	right:SetTextColor(GameFontNormal:GetTextColor());
	left:Show();
	middle:Show();
	right:Show();
	return left, middle, right;
end;
local function TwoColRLSetup()
	WipeFrame();
	local left = tRJ[1];
	local right = tLJ[1];
	left:SetWidth(300);
	left:SetPoint("TOPLEFT", ns.sChild, "TOPLEFT", 10, -10);
	left:SetTextColor(GameFontNormal:GetTextColor());
	right:SetWidth(300);
	right:SetPoint("TOPLEFT", left, "TOPRIGHT", 20, 0);
	right:SetTextColor(GameFontNormal:GetTextColor());	
	left:Show();
	right:Show();	
	return left, right;
end;
function ns.DailyHistory()
	local left, middle, right = HistorySetup();	
	local l, m, r = "Date", "Days Closing Gold", "Daily Gain/Loss"	
	local i = "1";
	local gt = 0;
	local prev = -1;
	while (GoldCoffer.History.Day[i] ~= nil) do	
		for d,g in pairs(GoldCoffer.History.Day[i]) do
			l = l .. "\n" .. d;
			m = m .. "\n" .. ns:ProfitLossColoring(g);
			if prev > -1 then
				r = r .. "\n" .. ns:ProfitLossColoring(prev - g);
			end;
			prev = g;
		end; 
		i = tostring(tonumber(i) + 1);
	end;	
	left:SetText(l);
	middle:SetText(m);
	right:SetText(r);	
end;
function ns.WeeklyHistory()
	local left, middle, right = HistorySetup();	
	local l, m, r = "Date", "Weeks Closing Gold", "Weekly Gain/Loss"	
	local i = "1";
	local gt = 0;
	local prev = -1;
	while (GoldCoffer.History.Week[i] ~= nil) do	
		for d,g in pairs(GoldCoffer.History.Week[i]) do
			l = l .. "\n" .. d;
			m = m .. "\n" .. ns:ProfitLossColoring(g);
			if prev > -1 then
				r = r .. "\n" .. ns:ProfitLossColoring(prev - g);
			end;
			prev = g;
		end; 
		i = tostring(tonumber(i) + 1);
	end;	
	left:SetText(l);
	middle:SetText(m);
	right:SetText(r);
end;
function ns.YearlyHistory()
	local left, middle, right = HistorySetup();	
	left:SetWidth(150);	
	local l, m, r = "Date          ", "Years Closing Gold", "Yearly Gain/Loss"	
	local i = "1";
	local gt = 0;
	local prev = -1;
	while (GoldCoffer.History.Year[i] ~= nil) do	
		for d,g in pairs(GoldCoffer.History.Year[i]) do
			l = l .. "\n" .. d;
			m = m .. "\n" .. ns:ProfitLossColoring(g);
			if prev > -1 then
				r = r .. "\n" .. ns:ProfitLossColoring(prev - g);
			end;
			prev = g;
		end; 
		i = tostring(tonumber(i) + 1);
	end;	
	left:SetText(l);
	middle:SetText(m);
	right:SetText(r);
end;
local function AccountHistory()
	local left, right = TwoColRLSetup();
	local l = "Account Profit/loss Summary\n" .. 
			"This session\n" .. ns:GetSessionChange() .. "\n\n" .. 
			"Today\n" .. ns:GetYesterdaysChange() .. "\n\n" .. 
			"This Week\n" .. ns:GetWeeksChange() .. "\n\n" .. 
			"This Month\n" .. ns:GetYearsChange();
	local r = "Account Closing Totals\n" .. 
			"Yesterday\n" .. ns:GetYesterdaysGold(true) .. "\n\n" .. 
			"Last Week\n" .. ns:GetLastWeeksGold(true) .. "\n\n" .. 
			"Last Month\n" .. ns:GetLastMonthsGold(true) .. "\n\n" .. 
			"Last Year\n" .. ns:GetLastYearsGold(true);
	left:SetText(l);
	right:SetText(r);
end;
local function ServerHistory(server)
	local left, right = TwoColRLSetup();
	local hist = ns:GetServerHistory(server);
	if hist == nil then return; end;
	local l = server .. "\nProfit/loss Summary \n" .. 
				"Today\n" .. hist.session .. "\n" .. 
				"This Week\n" .. hist.today .. "\n" .. 
				"This Month\n" .. hist.week .. "\n" .. 
				"This Year\n" .. hist.month .. "\n";		
	local r = 	 "All Characters\nClosing Totals\n" .. 
				"Yesterday\n" .. hist.yesterday .. "\n" .. 
				"Last Week\n" .. hist.lweek .. "\n" .. 
				"Last Month\n" ..hist.lmonth .. "\n" .. 
				"Last Year\n" .. hist.lyear .. "\n";	
	local tList = ns:GetToonsInfo(server);
	if tList ~= nil then
		l = l .. "~~~~~~~~~~~~~~~~~~~~~~~~\nCurrent Gold\n";
		r = r .. "~~~~~~~~~~~~~~~~~~~~~~~~\nCharacter\n";
		for k,v in ipairs(tList) do
			l = l .. ns:ProfitLossColoring(v.gold) .. "\n";
			r = r .. v.name .. "\n";
		end;
	end;
	left:SetText(l .. "\n\n\n\n");
	right:SetText(r .. "\n\n\n\n");
end;
local function ToonHistory(srv, toon)
	local left, right = TwoColRLSetup();
	local hist = ns:GetToonHistory(srv, toon);
	if hist == nil then return; end;
	local l = toon .. " - " .. srv .. "\nCurrent Gold\n\n" .. 
				"Profit/loss Summary\n" .. 
				"Today\n" .. hist.today .. "\n\n" .. 
				"This Week\n" .. hist.week .. "\n\n" .. 
				"This Month\n" .. hist.month .. "\n\n" .. 
				"This Year\n" .. hist.year .. "\n\n\n"
	local r = 	"Last played " .. hist.lastPlayed .. "\n" .. 
				hist.current .. "\n\n" .. 
				"Closing Totals\n" .. 
				"Yesterday\n" .. hist.yesterday .. "\n\n" .. 
				"Last Week\n" .. hist.lweek .. "\n\n" .. 
				"Last Month\n" ..hist.lmonth .. "\n\n" .. 
				"Last Year\n" .. hist.lyear .. "\n\n\n";	
	left:SetText(l);
	right:SetText(r);	
end;
local function GuildHistory(srv, guild)
	local left, right = TwoColRLSetup();
	local hist = ns:GetGuildHistory(srv, guild);
	if hist == nil then return; end;
	local l = 	guild .. " - " .. srv .. 
				"\nCurrent Gold\n" .. 
				"\nProfit/loss Summary\n" .. 
				"Today\n" .. hist.today .. "\n\n" .. 
				"This Week\n" .. hist.week .. "\n\n" .. 
				"This Month\n" .. hist.month .. "\n\n" .. 
				"This Year\n" .. hist.year;
	local r = 	"Updated " .. hist.lastPlayed .. "\n" ..
				hist.current .. "\n\nClosing Totals\n" .. 
				"Yesterday\n" .. hist.yesterday .. "\n\n" .. 
				"Last Week\n" .. hist.lweek .. "\n\n" .. 
				"Last Month\n" ..hist.lmonth .. "\n\n" .. 
				"Last Year\n" .. hist.lyear;	
	left:SetText(l);
	right:SetText(r);
end;
function ns:GoldSummary(srv, toon, guild)
	toon = toon or "";
	guild = guild or "";
	if srv == "All Servers" then
		AccountHistory();
	else
		if guild == "Select a Guild" then
			if toon == "All Characters" then
				ServerHistory(srv);
			else
				ToonHistory(srv, toon);
			end;
		else
			GuildHistory(srv, guild);
		end;
	end;
end;
function ns:Clear()
	WipeFrame();
end;
