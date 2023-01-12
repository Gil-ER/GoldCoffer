local Addon, ns = ...;

--	Creates a frame (Example)
	local opts = {
		title = "Gold Report",
		name = "gcReportFrame",
		anchor = "CENTER", 
		parent = UIParent,
		relFrame = UIParent,
		relPoint = "CENTER",
		xOff = 0,
		yOff = 0,
		width = 700,
		height = 400,
		isMovable = true,
		isSizable = false
	}
local ReportFrame = ns:createFrame(opts)

ReportFrame.ScrollFrame = CreateFrame("ScrollFrame", nil, ReportFrame, "UIPanelScrollFrameTemplate");
ReportFrame.ScrollFrame:SetPoint("TOPLEFT", gcReportFrame, "TOPLEFT", 4, -30);
ReportFrame.ScrollFrame:SetPoint("BOTTOMRIGHT", gcReportFrame, "BOTTOMRIGHT", -8, 10);
ReportFrame.ScrollFrame:SetClipsChildren(true);
ReportFrame:EnableMouseWheel(1)
ReportFrame.ScrollFrame.ScrollBar:ClearAllPoints();
ReportFrame.ScrollFrame.ScrollBar:SetPoint("TOPLEFT", ReportFrame.ScrollFrame, "TOPRIGHT", -12, -18);
ReportFrame.ScrollFrame.ScrollBar:SetPoint("BOTTOMRIGHT", ReportFrame.ScrollFrame, "BOTTOMRIGHT", -7, 18);
local TabServers, TabSummery, TabDaily, TabWeekly, TabYearly, TabCurrencies = ns:SetTabs (ReportFrame, 6, 
		"Gold Report", "Gold Summery", "Daily History", "Weekly History", "Yearly History", "Currencies")


--------------------------------------------------------------------------------------------------
--			TabServers
--------------------------------------------------------------------------------------------------
function TabServers.tabShow()
	--moved from the else in ns:ShowGoldReport()
	TabServers.goldTitle:SetText("Total gold = " .. ns:GetTotalGold(true));
	local s = ns:GetServers();
	for i=1, #s do
		--check the current server and uncheck all others
		if ns.srv == s[i] then TabServers.cb[i]:SetChecked(true); else TabServers.cb[i]:SetChecked(false); end;
		TabServers.cbText[i]:SetText(s[i] .. " - " ..  ns:GoldSilverCopper(ns:GetServerGold(s[i])));
		TabServers.cb[i]:Show();
	end;	
	TabServers.cbClick();
end;

function TabServers.cbClick(index)
	--called by the OnClick event all 50 checkboxes
	--index is the index of the box clicked (not currently used)
	local idx = 1;	-- current text row	
	--Remove old data
	for i=1, 100 do					
		TabServers.leftTxt[i]:SetText("");
		TabServers.rightTxt[i]:SetText("");
	end;
	--Update the report with data requested by selecting checkboxes
	for i=1, 50 do
		if TabServers.cb[i]:GetChecked() then
			local s = TabServers.cbText[i]:GetText();		--  Server - 12345g 67s 89c
			local g = "";
			s,g = strsplit("-", s, 2);			--  Split at the '-'
			s = strtrim(s, " ");				--  'Server'
			g = g or " ";
			g = strtrim(g, " -");				--  '12345g67s89c'
			TabServers.leftTxt[idx]:SetText(s);			--  Show values
			TabServers.rightTxt[idx]:SetText(g);
			--position the text
			if idx > 1 then
				TabServers.leftTxt[idx]:ClearAllPoints();
				TabServers.leftTxt[idx]:SetPoint("TOPLEFT", TabServers.leftTxt[idx-1], "TOPLEFT", -10, -30);				
				TabServers.rightTxt[idx]:ClearAllPoints();				
				TabServers.rightTxt[idx]:SetPoint("TOPRIGHT", TabServers.rightTxt[idx-1], "TOPRIGHT", 0, -30);
			end;	--if
			idx = idx + 1;			-- Move to next text row
			local stepIn = 10;		-- Indent first toon of the server
			local stepDown = -20;
			local list = {};
			if GoldCoffer.Servers[s] ~= nil then
				for k, v in pairs (GoldCoffer.Servers[s]) do		-- copy server data
					list [#list+1] = {["name"] = k; ["gold"] = v};
				end;
			end;
			table.sort (list, function(a,b) return a.gold > b.gold; end);
			for k, v in pairs(list) do							-- display server data
				TabServers.leftTxt[idx]:SetText(v.name);	
				TabServers.rightTxt[idx]:SetText(ns:GoldSilverCopper(v.gold));
				TabServers.leftTxt[idx]:ClearAllPoints();
				TabServers.leftTxt[idx]:SetPoint("TOPLEFT", TabServers.leftTxt[idx-1], "TOPLEFT", stepIn, stepDown);
				TabServers.rightTxt[idx]:ClearAllPoints();				
				TabServers.rightTxt[idx]:SetPoint("TOPRIGHT", TabServers.rightTxt[idx-1], "TOPRIGHT", 0, stepDown);
				idx = idx + 1;
				stepIn = 0;
				stepDown = -20;
			end; --for
		end; --is checked
	end; --for
end;

-- Create 'title' texts for gold
TabServers.goldTitle = TabServers:CreateFontString (nil, "OVERLAY", "GameFontNormalLarge");
TabServers.goldTitle:SetPoint("TOPLEFT", TabServers, "TOPLEFT", 0, -25);
TabServers.goldTitle:SetWidth(700);
TabServers.goldTitle:SetJustifyH("CENTER");

--	Create 50 checkboxes for server names
local params = {
	name = nil,					--globally unique, only change if you need it
	parent = TabServers,		--parent frame
	relFrame = TabServers,		--relative control for positioning
	anchor = "TOPLEFT", 		--anchor point of this form
	relPoint = "TOPLEFT",		--relative point for positioning	
	xOff = 25,					--x offset from relative point
	yOff = -55,				--y offset from relative point
	caption = "",				--Text displayed beside checkbox
	ttip = "",					--Tooltip
}

TabServers.cbText = {};			--Add tables for checkboxes and text to TabServers
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

--create output textboxes
TabServers.leftTxt[1] = TabServers:CreateFontString (nil, "OVERLAY", "GameFontNormal");
TabServers.leftTxt[1]:SetPoint("TOPLEFT", TabServers, "TOPLEFT", 360, -65);
TabServers.leftTxt[1]:SetWidth(150);
TabServers.leftTxt[1]:SetJustifyH("LEFT");

TabServers.rightTxt[1] = TabServers:CreateFontString (nil, "OVERLAY", "GameFontNormal");
TabServers.rightTxt[1]:SetPoint("TOPLEFT", TabServers.leftTxt[1], "TOPRIGHT", 0, 0)
TabServers.rightTxt[1]:SetWidth(150);
TabServers.rightTxt[1]:SetJustifyH("RIGHT");

for i=2, 100 do			-- 100 is space for 50 servers with 1 toon on each (max for 50 character limit)
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

--------------------------------------------------------------------------------------------------
--			/TabServers
--------------------------------------------------------------------------------------------------


--------------------------------------------------------------------------------------------------
--			TabSummery
--------------------------------------------------------------------------------------------------
function TabSummery.tabShow()
	local h = ns.player .. "  -  " .. ns:GoldSilverCopper(GetMoney())	.. "\n\n" .. 
			ns.srv .. "  -  " .. ns:GetServerGold(ns.srv, true);			
	local l = "Profit/loss this session\n" .. ns:GetSessionChange() .. "\n\n" .. 
			"Today\n" .. ns:GetYesterdaysChange() .. "\n\n" .. 
			"This Week\n" .. ns:GetWeeksChange() .. "\n\n" .. 
			"This Year\n" .. ns:GetYearsChange() .. "\n\n\n";		
	local r = "Total Gold Yesterday\n" .. ns:GetYesterdaysGold(true) .. "\n\n" .. 
			"Last Week\n" .. ns:GetLastWeeksGold(true) .. "\n\n" .. 
			"Last Month\n" .. ns:GetLastMonthsGold(true) .. "\n\n" .. 
			"Last Year\n" .. ns:GetLastYearsGold(true);	
	TabSummery.Header:SetText(h);		
	TabSummery.LeftText:SetText(l);
	TabSummery.RightText:SetText(r);
end;

-- TabSummery elements
TabSummery.Header = TabSummery:CreateFontString (nil, "OVERLAY", "GameFontNormalLarge");
TabSummery.Header:SetPoint("TOPLEFT", TabSummery, "TOPLEFT", 30, -25);
TabSummery.Header:SetWidth(600);

TabSummery.LeftText = TabSummery:CreateFontString (nil, "OVERLAY", "GameFontNormalLarge");
TabSummery.LeftText:SetPoint("TOPLEFT", TabSummery.Header, "BOTTOMLEFT", 0, -30);
TabSummery.LeftText:SetWidth(300);

TabSummery.RightText = TabSummery:CreateFontString (nil, "OVERLAY", "GameFontNormalLarge");
TabSummery.RightText:SetPoint("TOPLEFT", TabSummery.LeftText, "TOPRIGHT");
TabSummery.RightText:SetWidth(300);

TabSummery.Footer = TabSummery:CreateFontString (nil, "OVERLAY", "GameFontNormal");
TabSummery.Footer:SetPoint("TOPLEFT", TabSummery.LeftText, "BOTTOMLEFT");
TabSummery.Footer:SetWidth(600);
TabSummery.Footer:SetText("* Last Week/Month/Year will show 0 until enough data is collected.");


TabSummery:SetScript( "OnShow", function() TabSummery.tabShow(); end);

--------------------------------------------------------------------------------------------------
--			/TabSummery
--------------------------------------------------------------------------------------------------


--------------------------------------------------------------------------------------------------
--			TabDaily
--------------------------------------------------------------------------------------------------
function TabDaily.tabShow()
	local h = "Daily History"			
	local l, m, r = "Date\n", "Days Closing Gold\n", "Daily Gain/Loss\n"
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
		end; --/in pairs
		i = tostring(tonumber(i) + 1);
	end;	--/while
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
--------------------------------------------------------------------------------------------------
--			/TabDaily
--------------------------------------------------------------------------------------------------



--------------------------------------------------------------------------------------------------
--			TabWeekly
--------------------------------------------------------------------------------------------------
function TabWeekly.tabShow()
	local h = "Weekly History";	
	local l, m, r = "Date\n", "Weeks Closing Gold\n", "Weekly Gain/Loss\n"
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
		end; --/in pairs
		i = tostring(tonumber(i) + 1);
	end;	--/while
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
--------------------------------------------------------------------------------------------------
--			/TabWeekly
--------------------------------------------------------------------------------------------------



--------------------------------------------------------------------------------------------------
--			TabYearly
--------------------------------------------------------------------------------------------------
TabYearly.cbCount = 1;

function TabYearly.tabShow()
	local h = "Yearly History";	
	local l, m, r = "Date\n", "Years Closing Gold\n", "Yearly Gain/Loss\n"
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
		end; --/in pairs
		i = tostring(tonumber(i) + 1);
	end;	--/while
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
--------------------------------------------------------------------------------------------------
--			/TabYearly
--------------------------------------------------------------------------------------------------



--------------------------------------------------------------------------------------------------
--			/TabCurrencies
--------------------------------------------------------------------------------------------------
local maxCur = 200;

function TabCurrencies.tabShow()
	ns.UpdateCurrency();
		


	TabCurrencies.Header:SetText( "Currency Detail");
	TabCurrencies.QuantityText:SetText("");	
	TabCurrencies.NameText:SetText("");
	
	local curList = ns.GetCurrencies();
	
	for i=1, maxCur do
		TabCurrencies.cb[i]:Hide();
	end;
	
	local temp = ""
	for i=1, #curList do
		temp = temp .. curList[i] .. "\n";
		TabCurrencies.cbText[i]:SetText(curList[i]);
		TabCurrencies.cb[i]:Show();
	end;	
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
	--Clear any old detail
	TabCurrencies.QuantityText:SetText("");
	TabCurrencies.NameText:SetText("");
	local qty = "";
	local names = "";
	
	for i=1, maxCur do
		local list = {};
		local toons = {};
		if TabCurrencies.cb[i]:GetChecked() then
			--Get a list of toons with this currency
			local cur = TabCurrencies.cbText[i]:GetText();
			list = ns.GetToonsWith(cur);
			--sort the keys
			for k,v in pairs(list) do tinsert(toons, k); end;
			sort(toons);
			--Add the listed toond to the detail	
			if #toons > 0 then
				qty = qty .. "\n";
				names = names .. cur .. "\n";				
				for i=1, #toons do
					qty = qty .. addCommas(list[toons[i]]) .. "\n";
					names = names .. toons[i] .. "\n";
				end; 	--/for i				
				--Add a break before the next currency
				qty = qty .. "\n";
				names = names .. "\n";
			end;	--/if #list
		end;	--/if
	end; 	--/for i
	--Add text to the boxes
	TabCurrencies.QuantityText:SetText(qty);	
	TabCurrencies.NameText:SetText(names);	
	ReportFrame.ScrollFrame:SetVerticalScroll(0)
end;

-- TabCurrencies elements
TabCurrencies.Header = TabCurrencies:CreateFontString (nil, "OVERLAY", "GameFontNormalLarge");
TabCurrencies.Header:SetPoint("TOPLEFT", TabCurrencies, "TOPLEFT", 30, -25);
TabCurrencies.Header:SetWidth(600);

TabCurrencies.QuantityText = TabCurrencies:CreateFontString (nil, "OVERLAY", "GameFontNormal");
TabCurrencies.QuantityText:SetPoint("TOPLEFT", TabCurrencies.Header, "BOTTOMLEFT", 250, -25);
TabCurrencies.QuantityText:SetWidth(100);
TabCurrencies.QuantityText:SetJustifyH("RIGHT");

TabCurrencies.NameText = TabCurrencies:CreateFontString (nil, "OVERLAY", "GameFontNormal");
TabCurrencies.NameText:SetPoint("TOPLEFT", TabCurrencies.QuantityText, "TOPRIGHT", 10, 0);
TabCurrencies.NameText:SetWidth(280);
TabCurrencies.NameText:SetJustifyH("LEFT");


TabCurrencies.CurrencySF = CreateFrame("ScrollFrame", nil, TabCurrencies, "UIPanelScrollFrameTemplate")
TabCurrencies.CurrencySF:SetSize(250,275)
TabCurrencies.CurrencySF:SetPoint("TOPLEFT", TabCurrencies, "TOPLEFT", 25, -50)

TabCurrencies.CurrencySW = CreateFrame("Frame", nil, TabCurrencies.CurrencySF)
TabCurrencies.CurrencySW:SetWidth(250)
TabCurrencies.CurrencySF:SetScrollChild(TabCurrencies.CurrencySW)
	
	
TabCurrencies.params = {
	name = nil,					--globally unique, only change if you need it
	parent = TabCurrencies.CurrencySW,		--parent frame
	relFrame = TabCurrencies.CurrencySF,	--relative control for positioning
	anchor = "TOPLEFT", 		--anchor point of this form
	relPoint = "TOPLEFT",		--relative point for positioning	
	xOff = 25,					--x offset from relative point
	yOff = -55,				--y offset from relative point
	caption = "",				--Text displayed beside checkbox
	ttip = "",					--Tooltip
}

TabCurrencies.cbText = {};			--Add tables for checkboxes and text to TabCurrencies
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
		yOff = -30,
		caption = "",
		ttip = "",	
	}
	TabCurrencies.cb[i], TabCurrencies.cbText[i] = ns:createCheckBox(params);
	TabCurrencies.cb[i]:SetScript( "OnClick", function() TabCurrencies.cbClick(i); end);
	TabCurrencies.cb[i]:Hide();
end;




TabCurrencies:SetScript( "OnShow", function() TabCurrencies.tabShow(); end);


--------------------------------------------------------------------------------------------------
--			/TabCurrencies
--------------------------------------------------------------------------------------------------






function ns:ShowGoldReport()
	--toggles the visibility of the report frame 	
	if ReportFrame:IsVisible() then ReportFrame:Hide(); else ReportFrame:Show(); end;
end;
