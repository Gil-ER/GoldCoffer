-- Edited Jun 20, 2023

local Addon, ns = ...;
	local opts = {
		title = "Gold Coffer",
		name = "gcReportFrame",
		anchor = "CENTER", 
		parent = UIParent,
		relFrame = UIParent,
		relPoint = "CENTER",
		xOff = 0,
		yOff = 0,
		width = 700,
		height = 500,
		isMovable = true,
		isSizable = false
	}
local ReportFrame = ns:createFrame(opts)
ReportFrame:SetFrameStrata("DIALOG");
if select(4, GetBuildInfo()) >= 100100 then
	ReportFrame.ScrollFrame = CreateFrame("ScrollFrame", nil, ReportFrame, "ScrollFrameTemplate");
	ReportFrame.ScrollFrame:SetPoint("TOPLEFT", gcReportFrame, "TOPLEFT", 4, -70);
	ReportFrame.ScrollFrame:SetPoint("BOTTOMRIGHT", gcReportFrame, "BOTTOMRIGHT", -25, 30);
	ReportFrame.ScrollChild = CreateFrame("Frame");
	ReportFrame.ScrollFrame:SetScrollChild(ReportFrame.ScrollChild);
else
	ReportFrame.ScrollFrame = CreateFrame("ScrollFrame", nil, ReportFrame, "UIPanelScrollFrameTemplate");
	ReportFrame.ScrollFrame:SetPoint("TOPLEFT", gcReportFrame, "TOPLEFT", 4, -65);
	ReportFrame.ScrollFrame:SetPoint("BOTTOMRIGHT", gcReportFrame, "BOTTOMRIGHT", -8, 30);
	ReportFrame.ScrollFrame:SetClipsChildren(true);
	ReportFrame:EnableMouseWheel(1)
	ReportFrame.ScrollFrame.ScrollBar:ClearAllPoints();
	ReportFrame.ScrollFrame.ScrollBar:SetPoint("TOPLEFT", ReportFrame.ScrollFrame, "TOPRIGHT", -12, -18);
	ReportFrame.ScrollFrame.ScrollBar:SetPoint("BOTTOMRIGHT", ReportFrame.ScrollFrame, "BOTTOMRIGHT", -7, 18);
end
_G[ReportFrame:GetName() .. "Portrait"]:SetTexture("Interface\\AddOns\\GoldCoffer\\GC_Button.blp")
local TabServers, TabSummery, TabDaily, TabWeekly, TabYearly, TabCurrencies;
if select(4, GetBuildInfo()) > 40000 then
	TabServers, TabSummery, TabDaily, TabWeekly, TabYearly, TabCurrencies = ns:SetTabs (ReportFrame, 6, 
			"Gold Report", "Gold Summery", "Daily History", "Weekly History", "Yearly History", "Currencies")
else
	TabServers, TabSummery, TabDaily, TabWeekly, TabYearly = ns:SetTabs (ReportFrame, 5, 
			"Gold Report", "Gold Summery", "Daily History", "Weekly History", "Yearly History")
end;
function TabServers.tabShow()
	TabServers.goldTitle:SetText("Total gold = " .. ns:GetTotalGold(true));
	local s = ns:GetServers();
	for i=1, #s do
		if ns.srv == s[i] then TabServers.cb[i]:SetChecked(true); else TabServers.cb[i]:SetChecked(false); end;
		TabServers.cbText[i]:SetText(s[i] .. " - " ..  ns:GoldSilverCopper(ns:GetServerGold(s[i])));
		TabServers.cb[i]:Show();
	end;	
	TabServers.cbClick();
end;
function TabServers.cbClick(index)
	local idx = 1;	
	for i=1, 100 do					
		TabServers.leftTxt[i]:SetText("");
		TabServers.rightTxt[i]:SetText("");
	end;
	for i=1, 50 do
		if TabServers.cb[i]:GetChecked() then
			local s = TabServers.cbText[i]:GetText();		
			local g = "";
			s,g = strsplit("-", s, 2);			
			s = strtrim(s, " ");				
			g = g or " ";
			g = strtrim(g, " -");				
			TabServers.leftTxt[idx]:SetText(s);			
			TabServers.rightTxt[idx]:SetText(g);
			if idx > 1 then
				TabServers.leftTxt[idx]:ClearAllPoints();
				TabServers.leftTxt[idx]:SetPoint("TOPLEFT", TabServers.leftTxt[idx-1], "TOPLEFT", -10, -30);				
				TabServers.rightTxt[idx]:ClearAllPoints();				
				TabServers.rightTxt[idx]:SetPoint("TOPRIGHT", TabServers.rightTxt[idx-1], "TOPRIGHT", 0, -30);
			end;	
			idx = idx + 1;			
			local stepIn = 10;		
			local stepDown = -20;
			local list = {};
			if GoldCoffer.Servers[s] ~= nil then
				for k, v in pairs (GoldCoffer.Servers[s]) do		
					list [#list+1] = {["name"] = k; ["gold"] = v.Current};
				end;
			end;
			table.sort (list, function(a,b) return a.gold > b.gold; end);
			for k, v in pairs(list) do							
				TabServers.leftTxt[idx]:SetText(v.name);	
				TabServers.rightTxt[idx]:SetText(ns:GoldSilverCopper(v.gold));
				TabServers.leftTxt[idx]:ClearAllPoints();
				TabServers.leftTxt[idx]:SetPoint("TOPLEFT", TabServers.leftTxt[idx-1], "TOPLEFT", stepIn, stepDown);
				TabServers.rightTxt[idx]:ClearAllPoints();				
				TabServers.rightTxt[idx]:SetPoint("TOPRIGHT", TabServers.rightTxt[idx-1], "TOPRIGHT", 0, stepDown);
				idx = idx + 1;
				stepIn = 0;
				stepDown = -20;
			end; 
		end; 
	end; 
end;
TabServers.goldTitle = TabServers:CreateFontString (nil, "OVERLAY", "GameFontNormalLarge");
TabServers.goldTitle:SetPoint("TOPLEFT", TabServers, "TOPLEFT", 0, -25);
TabServers.goldTitle:SetWidth(700);
TabServers.goldTitle:SetJustifyH("CENTER");
local params = {
	name = nil,					
	parent = TabServers,		
	relFrame = TabServers,		
	anchor = "TOPLEFT", 		
	relPoint = "TOPLEFT",		
	xOff = 25,					
	yOff = -55,				
	caption = "",				
	ttip = "",					
}
TabServers.cbText = {};			
TabServers.cb = {};
TabServers.leftTxt = {};
TabServers.rightTxt = {};
TabServers.cb[1], TabServers.cbText[1] = ns:createCheckBox(params);
TabServers.cb[1]:Hide();
TabServers.cb[1]:SetScript( "OnClick", function() TabServers.cbClick(1); end);
for i=2, 50 do
	params = {	
		name = nil,
		parent = TabServers,
		relFrame = TabServers.cb[i-1],	
		anchor = "TOPLEFT", 
		relPoint = "TOPLEFT",
		xOff = 0,
		yOff = -30,
		caption = "",
		ttip = "",	
	}
	TabServers.cb[i], TabServers.cbText[i] = ns:createCheckBox(params);
	TabServers.cb[i]:SetScript( "OnClick", function() TabServers.cbClick(i); end);
	TabServers.cb[i]:Hide();
end;
TabServers.leftTxt[1] = TabServers:CreateFontString (nil, "OVERLAY", "GameFontNormal");
TabServers.leftTxt[1]:SetPoint("TOPLEFT", TabServers, "TOPLEFT", 360, -65);
TabServers.leftTxt[1]:SetWidth(150);
TabServers.leftTxt[1]:SetJustifyH("LEFT");
TabServers.rightTxt[1] = TabServers:CreateFontString (nil, "OVERLAY", "GameFontNormal");
TabServers.rightTxt[1]:SetPoint("TOPLEFT", TabServers.leftTxt[1], "TOPRIGHT", 0, 0)
TabServers.rightTxt[1]:SetWidth(150);
TabServers.rightTxt[1]:SetJustifyH("RIGHT");
for i=2, 100 do			
	TabServers.leftTxt[i] = TabServers:CreateFontString (nil, "OVERLAY", "GameFontNormal");
	TabServers.leftTxt[i]:SetPoint("TOPLEFT", TabServers.leftTxt[i-1], "TOPLEFT", 0, -15);
	TabServers.leftTxt[i]:SetWidth(150);
	TabServers.leftTxt[i]:SetJustifyH("LEFT");
	TabServers.rightTxt[i] = TabServers:CreateFontString (nil, "OVERLAY", "GameFontNormal");
	TabServers.rightTxt[i]:SetPoint("TOPRIGHT", TabServers.rightTxt[i-1], "TOPRIGHT", 0, -15)
	TabServers.rightTxt[i]:SetWidth(150);
	TabServers.rightTxt[i]:SetJustifyH("RIGHT");
end;
TabServers:SetScript( "OnShow", function() TabServers.tabShow(); end);
ReportFrame:Hide();
function TabSummery.tabShow()
	ns.srv = ns.srv or GetRealmName();
	ns.player = ns.player or UnitName("player");
	getglobal(TabSummery.toon:GetName() .. 'Text'):SetText(ns.player .. " - " .. ns:GoldSilverCopper(GetMoney()));
	getglobal(TabSummery.server:GetName() .. 'Text'):SetText(ns.srv .. " Total - " .. ns:GetServerGold(ns.srv, true));
	getglobal(TabSummery.account:GetName() .. 'Text'):SetText("Account Total - " .. ns:GetTotalGold(true));
	local l,r = "","";
	if TabSummery.toon:GetChecked() then
		hist = ns:GetToonHistory(ns.player);
		l = l .. ns.player .. " Profit/loss Summery\n\n" .. 
				"This session\n" .. hist.session .. "\n\n" .. 
				"Today\n" .. hist.today .. "\n\n" .. 
				"This Week\n" .. hist.week .. "\n\n" .. 
				"This Month\n" .. hist.month .. "\n\n" .. 
				"
		r = r .. ns.player .. " Closing Totals\n\n" .. 
				"Yesterday\n" .. hist.yesterday .. "\n\n" .. 
				"Last Week\n" .. hist.lweek .. "\n\n" .. 
				"Last Month\n" ..hist.lmonth .. "\n\n" .. 
				"Last Year\n" .. hist.lyear .. "\n\n" .. 
				"
	end;
	if TabSummery.server:GetChecked() then	
		hist = ns:GetServerHistory(ns.srv)
		l = l .. ns.srv .. " Profit/loss Summery \n\n" .. 
				"This session\n" .. hist.session .. "\n\n" .. 
				"Today\n" .. hist.today .. "\n\n" .. 
				"This Week\n" .. hist.week .. "\n\n" .. 
				"This Month\n" .. hist.month .. "\n\n" .. 
				"
		r = r .. ns.srv .. " Closing Totals\n\n" .. 
				"Yesterday\n" .. hist.yesterday .. "\n\n" .. 
				"Last Week\n" .. hist.lweek .. "\n\n" .. 
				"Last Month\n" ..hist.lmonth .. "\n\n" .. 
				"Last Year\n" .. hist.lyear .. "\n\n" .. 
				"
	end;
	if TabSummery.account:GetChecked() then	
		l = l .. "Account Profit/loss Summery\n\n" .. 
				"This session\n" .. ns:GetSessionChange() .. "\n\n" .. 
				"Today\n" .. ns:GetYesterdaysChange() .. "\n\n" .. 
				"This Week\n" .. ns:GetWeeksChange() .. "\n\n" .. 
				"This Month\n" .. ns:GetYearsChange() .. "\n\n" .. 
				"
		r = r .. "Account Closing Totals\n\n" .. 
				"Yesterday\n" .. ns:GetYesterdaysGold(true) .. "\n\n" .. 
				"Last Week\n" .. ns:GetLastWeeksGold(true) .. "\n\n" .. 
				"Last Month\n" .. ns:GetLastMonthsGold(true) .. "\n\n" .. 
				"Last Year\n" .. ns:GetLastYearsGold(true) .. "\n\n" .. 
				"
	end;	
	TabSummery.LeftText:SetText(l);
	TabSummery.RightText:SetText(r);
end;
	TabSummery.toon = CreateFrame("CheckButton",Addon .. "ToonCB" , TabSummery, "ChatConfigCheckButtonTemplate");
	TabSummery.toon:SetPoint("TOPLEFT", TabSummery, "TOPLEFT", 150, -10);
	TabSummery.toon:SetSize(32, 32);	
	getglobal(TabSummery.toon:GetName() .. 'Text'):SetFontObject(GameFontNormalLarge)
	TabSummery.toon:SetScript("OnClick", 
		function()
			TabSummery.tabShow()
		end); 
	TabSummery.server = CreateFrame("CheckButton",Addon .. "ServerCB" , TabSummery, "ChatConfigCheckButtonTemplate");
	TabSummery.server:SetPoint("TOPLEFT", TabSummery.toon, "TOPLEFT", 0, -30);
	TabSummery.server:SetSize(32, 32);	
	getglobal(TabSummery.server:GetName() .. 'Text'):SetFontObject(GameFontNormalLarge)
	TabSummery.server:SetScript("OnClick", 
		function()
			TabSummery.tabShow()
		end);
	TabSummery.account = CreateFrame("CheckButton",Addon .. "AccountCB" , TabSummery, "ChatConfigCheckButtonTemplate");
	TabSummery.account:SetPoint("TOPLEFT", TabSummery.server, "TOPLEFT", 0, -30);
	TabSummery.account:SetSize(32, 32);	
	getglobal(TabSummery.account:GetName() .. 'Text'):SetFontObject(GameFontNormalLarge)	
	TabSummery.account:SetScript("OnClick", 
		function()
			TabSummery.tabShow()
		end);
TabSummery.LeftText = TabSummery:CreateFontString (nil, "OVERLAY", "GameFontNormalLarge");
TabSummery.LeftText:SetPoint("TOPLEFT", TabSummery.account, "BOTTOMLEFT", -125, -20);
TabSummery.LeftText:SetWidth(300);
TabSummery.RightText = TabSummery:CreateFontString (nil, "OVERLAY", "GameFontNormalLarge");
TabSummery.RightText:SetPoint("TOPLEFT", TabSummery.LeftText, "TOPRIGHT");
TabSummery.RightText:SetWidth(300);
TabSummery.Footer = TabSummery:CreateFontString (nil, "OVERLAY", "GameFontNormal");
TabSummery.Footer:SetPoint("TOPLEFT", TabSummery.LeftText, "BOTTOMLEFT", 0, -5);
TabSummery.Footer:SetWidth(600);
TabSummery.Footer:SetText("* Last Week/Month/Year will show 0 until enough data is collected.");
TabSummery:SetScript( "OnShow", function() TabSummery.tabShow(); end);
function TabDaily.tabShow()
	local h = "Daily History"			
	local l, m, r = "Date", "Days Closing Gold", "Daily Gain/Loss"
	local i = "1";
	local gt = 0;
	local prev = -1;
	while (GoldCoffer.History.Day[i] ~= nil) do	
		for d,g in pairs(GoldCoffer.History.Day[i]) do
			l = l .. "\n\n" .. d;
			m = m .. "\n\n" .. ns:ProfitLossColoring(g);
			if prev > -1 then
				r = r .. "\n\n" .. ns:ProfitLossColoring(prev - g);
			end;
			prev = g;
		end; 
		i = tostring(tonumber(i) + 1);
	end;	
	TabDaily.Header:SetText(h);	
	TabDaily.LeftText:SetText(l);
	TabDaily.MiddleText:SetText(m);
	TabDaily.RightText:SetText(r);	
end;
TabDaily.Header = TabDaily:CreateFontString (nil, "OVERLAY", "GameFontNormalLarge");
TabDaily.Header:SetPoint("TOPLEFT", TabDaily, "TOPLEFT", 30, -25);
TabDaily.Header:SetWidth(600);
TabDaily.Header:SetText("");
TabDaily.LeftText = TabDaily:CreateFontString (nil, "OVERLAY", "GameFontNormalLarge");
TabDaily.LeftText:SetPoint("TOPLEFT", TabDaily.Header, "BOTTOMLEFT", 0, -30);
TabDaily.LeftText:SetWidth(130);
TabDaily.LeftText:SetJustifyH("LEFT");
TabDaily.MiddleText = TabDaily:CreateFontString (nil, "OVERLAY", "GameFontNormalLarge");
TabDaily.MiddleText:SetPoint("TOPLEFT", TabDaily.LeftText, "TOPRIGHT");
TabDaily.MiddleText:SetWidth(235);
TabDaily.MiddleText:SetJustifyH("RIGHT");
TabDaily.RightText = TabDaily:CreateFontString (nil, "OVERLAY", "GameFontNormalLarge");
TabDaily.RightText:SetPoint("TOPLEFT", TabDaily.MiddleText, "TOPRIGHT");
TabDaily.RightText:SetWidth(235);
TabDaily.RightText:SetJustifyH("RIGHT");
TabDaily.Footer = TabDaily:CreateFontString (nil, "OVERLAY", "GameFontNormal");
TabDaily.Footer:SetPoint("TOPLEFT", TabDaily.LeftText, "BOTTOMLEFT", 0, -30);
TabDaily.Footer:SetWidth(600);
TabDaily.Footer:SetJustifyH("LEFT");
TabDaily.Footer:SetText("");
TabDaily:SetScript( "OnShow", function() TabDaily.tabShow(); end);
function TabWeekly.tabShow()
	local h = "Weekly History";	
	local l, m, r = "Date", "Weeks Closing Gold", "Weekly Gain/Loss"
	local i = "1";
	local gt = 0;
	local prev = -1;
	while (GoldCoffer.History.Week[i] ~= nil) do	
		for d,g in pairs(GoldCoffer.History.Week[i]) do
			l = l .. "\n\n" .. d;
			m = m .. "\n\n" .. ns:ProfitLossColoring(g);
			if prev > -1 then
				r = r .. "\n\n" .. ns:ProfitLossColoring(prev - g);
			end;
			prev = g;
		end; 
		i = tostring(tonumber(i) + 1);
	end;	
	TabWeekly.Header:SetText(h);	
	TabWeekly.LeftText:SetText(l);
	TabWeekly.MiddleText:SetText(m);
	TabWeekly.RightText:SetText(r);		
end;
TabWeekly.Header = TabWeekly:CreateFontString (nil, "OVERLAY", "GameFontNormalLarge");
TabWeekly.Header:SetPoint("TOPLEFT", TabWeekly, "TOPLEFT", 30, -25);
TabWeekly.Header:SetWidth(600);
TabWeekly.Header:SetText("");
TabWeekly.LeftText = TabWeekly:CreateFontString (nil, "OVERLAY", "GameFontNormalLarge");
TabWeekly.LeftText:SetPoint("TOPLEFT", TabWeekly.Header, "BOTTOMLEFT", 0, -30);
TabWeekly.LeftText:SetWidth(130);
TabWeekly.LeftText:SetJustifyH("LEFT");
TabWeekly.MiddleText = TabWeekly:CreateFontString (nil, "OVERLAY", "GameFontNormalLarge");
TabWeekly.MiddleText:SetPoint("TOPLEFT", TabWeekly.LeftText, "TOPRIGHT");
TabWeekly.MiddleText:SetWidth(235);
TabWeekly.MiddleText:SetJustifyH("RIGHT");
TabWeekly.RightText = TabWeekly:CreateFontString (nil, "OVERLAY", "GameFontNormalLarge");
TabWeekly.RightText:SetPoint("TOPLEFT", TabWeekly.MiddleText, "TOPRIGHT");
TabWeekly.RightText:SetWidth(235);
TabWeekly.RightText:SetJustifyH("RIGHT");
TabWeekly.Footer = TabWeekly:CreateFontString (nil, "OVERLAY", "GameFontNormal");
TabWeekly.Footer:SetPoint("TOPLEFT", TabWeekly.LeftText, "BOTTOMLEFT", 0, -30);
TabWeekly.Footer:SetWidth(600);
TabWeekly.Footer:SetJustifyH("LEFT");
TabWeekly.Footer:SetText("* These dates may be off as you first start using this addon, also if you have gaps in your playtime.");
TabWeekly:SetScript( "OnShow", function() TabWeekly.tabShow(); end);
TabYearly.cbCount = 1;
function TabYearly.tabShow()
	local h = "Yearly History";	
	local l, m, r = "Date", "Years Closing Gold", "Yearly Gain/Loss"
	local i = "1";
	local gt = 0;
	local prev = -1;
	while (GoldCoffer.History.Year[i] ~= nil) do	
		for d,g in pairs(GoldCoffer.History.Year[i]) do
			l = l .. "\n\n" .. d;
			m = m .. "\n\n" .. ns:ProfitLossColoring(g);
			if prev > -1 then
				r = r .. "\n\n" .. ns:ProfitLossColoring(prev - g);
			end;
			prev = g;
		end; 
		i = tostring(tonumber(i) + 1);
	end;	
	TabYearly.Header:SetText(h);	
	TabYearly.LeftText:SetText(l);
	TabYearly.MiddleText:SetText(m);
	TabYearly.RightText:SetText(r);		
end;
TabYearly.Header = TabYearly:CreateFontString (nil, "OVERLAY", "GameFontNormalLarge");
TabYearly.Header:SetPoint("TOPLEFT", TabYearly, "TOPLEFT", 30, -25);
TabYearly.Header:SetWidth(600);
TabYearly.Header:SetText("");
TabYearly.LeftText = TabYearly:CreateFontString (nil, "OVERLAY", "GameFontNormalLarge");
TabYearly.LeftText:SetPoint("TOPLEFT", TabYearly.Header, "BOTTOMLEFT", -15, -30);
TabYearly.LeftText:SetWidth(175);
TabYearly.LeftText:SetJustifyH("LEFT");
TabYearly.MiddleText = TabYearly:CreateFontString (nil, "OVERLAY", "GameFontNormalLarge");
TabYearly.MiddleText:SetPoint("TOPLEFT", TabYearly.LeftText, "TOPRIGHT");
TabYearly.MiddleText:SetWidth(235);
TabYearly.MiddleText:SetJustifyH("RIGHT");
TabYearly.RightText = TabYearly:CreateFontString (nil, "OVERLAY", "GameFontNormalLarge");
TabYearly.RightText:SetPoint("TOPLEFT", TabYearly.MiddleText, "TOPRIGHT");
TabYearly.RightText:SetWidth(235);
TabYearly.RightText:SetJustifyH("RIGHT");
TabYearly.Footer = TabYearly:CreateFontString (nil, "OVERLAY", "GameFontNormal");
TabYearly.Footer:SetPoint("TOPLEFT", TabYearly.LeftText, "BOTTOMLEFT", 15, -30);
TabYearly.Footer:SetWidth(600);
TabYearly.Footer:SetJustifyH("LEFT");
TabYearly.Footer:SetText("* The first time you use this addon the previous year is recorded as 0.");
TabYearly:SetScript( "OnShow", function() TabYearly.tabShow(); end);
local maxCur = 200;
local maxSubHead = 30;
local cbLink = {};
if select(4, GetBuildInfo()) > 99999 then
	function TabCurrencies.tabShow()
		ns.UpdateCurrency();	
		TabCurrencies.Header:SetText( "Currency Detail");
		TabCurrencies.QuantityText:SetText("");	
		TabCurrencies.NameText:SetText("");
		for i=1, maxCur do
			TabCurrencies.cb[i]:Hide();
			TabCurrencies.cbText[i]:SetText("");
		end;
		cbLink = {};
		local cbIdx = 1;								
		local tbIdx = 1;
		local yPos = -10;		
		local loc = GetLocale();
		for k, v in ipairs (ns.GroupOrder) do
			if GoldCofferCurrencies[v] then
				TabCurrencies.SubHead[tbIdx]:ClearAllPoints();
				if tbIdx > 1 then yPos = yPos - 45; end;
				TabCurrencies.SubHead[tbIdx]:SetPoint("TOPLEFT", TabCurrencies.CurrencySW, 0, yPos);
				TabCurrencies.SubHead[tbIdx]:SetText(ns.GetGroupFromID ( v, loc ));
				TabCurrencies.SubHead[tbIdx]:Show();
				tbIdx = tbIdx + 1;			
				if GoldCofferCurrencies and GoldCofferCurrencies[v] then
					for id, t in pairs (GoldCofferCurrencies[v]) do					
						TabCurrencies.cb[cbIdx]:ClearAllPoints()
						yPos = yPos - 30;
						TabCurrencies.cb[cbIdx]:SetPoint("TOPLEFT", TabCurrencies.CurrencySW, 10, yPos);
						TabCurrencies.cb[cbIdx]:Show();			
						TabCurrencies.cbText[cbIdx]:SetTextColor(GameFontNormal:GetTextColor())
						local ci = C_CurrencyInfo.GetCurrencyInfo(id)
						local color = ci.quality and ITEM_QUALITY_COLORS[ci.quality].hex or ""
						local icon = (ci.iconFileID and "|T"..ci.iconFileID..":12|t " or "") .. color .. ci.name .. "|r";
						TabCurrencies.cbText[cbIdx]:SetText(icon);	
						cbLink[cbIdx] = { ["gID"] = v, ["cID"] = id };
						cbIdx = cbIdx + 1;					
					end;	
				end;	
			end;	
		end;		
		TabCurrencies.cbClick(0);			
	end;
	local function addCommas(num)
		num = tonumber(num);
		local ret = "";
		if num > 999 then ret = format("%03d",mod(num, 1000)); else ret = tostring(mod(num, 1000));	end;
		num = floor(num / 1000);
		while (num > 0) do 
			if num > 999 then ret = format("%03d",mod(num, 1000)) .. "," .. ret; else ret = tostring(num) .. "," .. ret; end;
			num = floor(num / 1000);	
		end;
		return ret;
	end;
	function TabCurrencies.cbClick(idx)
		for i=1, maxCur do if i ~= idx then TabCurrencies.cb[i]:SetChecked(false); end; end;		
		TabCurrencies.CurrencyText:SetText("");
		TabCurrencies.QuantityText:SetText("");
		TabCurrencies.NameText:SetText("");
		local qty = "";
		local names = "";
		if idx > 0 and TabCurrencies.cb[idx]:GetChecked() then	
			local grp = cbLink[idx].gID;
			local cur = TabCurrencies.cbText[idx]:GetText();
			TabCurrencies.CurrencyText:SetText(cur)
			local pos = strfind(cur, ":12|t")
			if pos and pos > 0 then 
				cur = strsub(cur, pos + 16, strlen(cur) - 2 ):gsub('%W ',''); 
			end;
			local toons = ns.GetToonsWithCurrency(cbLink[idx].gID, cbLink[idx].cID);
			local rlm = "";
			for k,v in ipairs(toons) do
				local r, n = strsplit("-", v);
				if rlm == "" then rlm = r; end;
				if r ~= rlm then								
					qty = qty .. "\n";
					names = names .. "\n";
					rlm = r;
				end;
				names = names .. v .. "\n"				
				qty = qty .. addCommas(GoldCofferCurrencies[cbLink[idx].gID][cbLink[idx].cID][v]) .. "\n";
			end;			
		end;	
		TabCurrencies.QuantityText:SetText(qty .. "\n");	
		TabCurrencies.NameText:SetText(names .. "\n");	
	end;
	TabCurrencies.Header = TabCurrencies:CreateFontString (nil, "OVERLAY", "GameFontNormalLarge");
	TabCurrencies.Header:SetPoint("TOPLEFT", TabCurrencies, "TOPLEFT", 0, -15);
	TabCurrencies.Header:SetWidth(700); 
	TabCurrencies.Header:SetJustifyH("CENTER");
	TabCurrencies.Left = CreateFrame("Frame", nil, TabCurrencies, "InsetFrameTemplate");
	TabCurrencies.Left:SetSize(310,300)
	TabCurrencies.Left:SetPoint("TOPLEFT", TabCurrencies, "TOPLEFT", 25, -50)
	TabCurrencies.CurrencySF = CreateFrame("ScrollFrame", nil, TabCurrencies.Left, "ScrollFrameTemplate");
	TabCurrencies.CurrencySF:SetSize(300,295)
	TabCurrencies.CurrencySF:ClearAllPoints();
	TabCurrencies.CurrencySF:SetPoint("TOPLEFT", TabCurrencies.Left, "TOPLEFT", 10, -5);
	TabCurrencies.CurrencySF:SetPoint("BOTTOMRIGHT", TabCurrencies.Left, "BOTTOMRIGHT", -20, 0)
	TabCurrencies.CurrencySW = CreateFrame("Frame");
	TabCurrencies.CurrencySF:SetScrollChild(TabCurrencies.CurrencySW);
	TabCurrencies.CurrencySW:SetSize(30, 60)	
	TabCurrencies.Right = CreateFrame("Frame", nil, TabCurrencies, "InsetFrameTemplate");
	TabCurrencies.Right:SetSize(310,300)
	TabCurrencies.Right:SetPoint("TOPLEFT", TabCurrencies.Left, "TOPRIGHT", 20, 0)		
	TabCurrencies.DetailSF = CreateFrame("ScrollFrame", nil, TabCurrencies.Right, "ScrollFrameTemplate");
	TabCurrencies.DetailSF:SetSize(300,295)
	TabCurrencies.DetailSF:ClearAllPoints();
	TabCurrencies.DetailSF:SetPoint("TOPLEFT", TabCurrencies.Right, "TOPLEFT", 0, -5);
	TabCurrencies.DetailSF:SetPoint("BOTTOMRIGHT", TabCurrencies.Right, "BOTTOMRIGHT", -20, 0)
	TabCurrencies.DetailSW = CreateFrame("Frame");
	TabCurrencies.DetailSF:SetScrollChild(TabCurrencies.DetailSW);
	TabCurrencies.DetailSW:SetSize(30, 60)	
	TabCurrencies.CurrencyText = TabCurrencies.DetailSW:CreateFontString (nil, "OVERLAY", "GameFontNormalLarge");
	TabCurrencies.CurrencyText:SetPoint("TOPLEFT", TabCurrencies.DetailSW, "TOPLEFT", 0, -20);
	TabCurrencies.CurrencyText:SetWidth(275);
	TabCurrencies.CurrencyText:SetJustifyH("CENTER");
	TabCurrencies.QuantityText = TabCurrencies.DetailSW:CreateFontString (nil, "OVERLAY", "GameFontNormal");
	TabCurrencies.QuantityText:SetSpacing(7);
	TabCurrencies.QuantityText:SetPoint("TOPLEFT", TabCurrencies.CurrencyText, "BOTTOMLEFT", 30, -20);
	TabCurrencies.QuantityText:SetWidth(70);
	TabCurrencies.QuantityText:SetJustifyH("RIGHT");
	TabCurrencies.NameText = TabCurrencies.DetailSW:CreateFontString (nil, "OVERLAY", "GameFontNormal");
	TabCurrencies.NameText:SetSpacing(7);
	TabCurrencies.NameText:SetPoint("TOPLEFT", TabCurrencies.QuantityText, "TOPRIGHT", 10, 0);
	TabCurrencies.NameText:SetWidth(270);
	TabCurrencies.NameText:SetJustifyH("LEFT");
	TabCurrencies.params = {
		name = nil,								
		parent = TabCurrencies.CurrencySW,		
		relFrame = TabCurrencies.CurrencySW,	
		anchor = "TOPLEFT", 					
		relPoint = "TOPLEFT",					
		xOff = 0,								
		yOff = -10,								
		caption = "",							
		ttip = "",								
	}
	TabCurrencies.cbText = {};			
	TabCurrencies.cb = {};
	TabCurrencies.cb[1], TabCurrencies.cbText[1] = ns:createCheckBox(TabCurrencies.params);
	TabCurrencies.cb[1]:Hide();
	TabCurrencies.cb[1]:SetScript( "OnClick", function() TabCurrencies.cbClick(1); end);
	for i=2, maxCur do
		params = {	
			name = nil,
			parent = TabCurrencies.CurrencySW,
			relFrame = TabCurrencies.cb[i-1],	
			anchor = "TOPLEFT", 
			relPoint = "TOPLEFT",
			xOff = 0,
			yOff = 0,
			caption = "",
			ttip = "",	
		}
		TabCurrencies.cb[i], TabCurrencies.cbText[i] = ns:createCheckBox(params);
		TabCurrencies.cb[i]:SetScript( "OnClick", function() TabCurrencies.cbClick(i); end);
		TabCurrencies.cb[i]:Hide();
	end;
	TabCurrencies.SubHead = {};
	for i = 1, maxSubHead do
		TabCurrencies.SubHead[i] = TabCurrencies.CurrencySW:CreateFontString (nil, "OVERLAY", "GameFontNormalLarge");
		TabCurrencies.SubHead[i]:Hide();
	end;
	TabCurrencies:SetScript( "OnShow", function() TabCurrencies.tabShow(); end);
end;
function ns:CenterGoldReport()
	ReportFrame:ClearAllPoints();
	ReportFrame:SetPoint("CENTER", UIParent, "CENTER");
end;
function ns:ShowGoldReport()
	if ReportFrame:IsVisible() then 
		ReportFrame:Hide(); 
	else 
		ReportFrame:Show(); 
	end;
end;
