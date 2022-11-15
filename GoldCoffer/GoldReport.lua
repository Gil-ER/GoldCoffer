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
local TabServers, TabSummery, TabDaily, TabWeekly, TabYearly = ns:SetTabs (ReportFrame, 5, 
		"Gold Report", "Gold Summery", "Daily History", "Weekly History", "Yearly History")


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

TabSummery.Footer = TabSummery:CreateFontString (nil, "OVERLAY", "GameFontNormalLarge");
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
	local l, m, r = "Date", "Days Closing Gold", "Profit/Loss from Previous Day"
	local days = GoldCoffer.History.Day
	print(#GoldCoffer.History.Day)
	for i=1, #days do
		for k,v in pairs(days[i]) do
			print(k)
			l = l .. "\n" .. k;
		end; --/k,v in pairs
	end;	--/for i
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
TabDaily.LeftText:SetWidth(200);
TabDaily.LeftText:SetJustifyH("LEFT");

TabDaily.MiddleText = TabDaily:CreateFontString (nil, "OVERLAY", "GameFontNormalLarge");
TabDaily.MiddleText:SetPoint("TOPLEFT", TabDaily.LeftText, "TOPRIGHT");
TabDaily.MiddleText:SetWidth(200);
TabDaily.MiddleText:SetJustifyH("RIGHT");

TabDaily.RightText = TabDaily:CreateFontString (nil, "OVERLAY", "GameFontNormalLarge");
TabDaily.RightText:SetPoint("TOPLEFT", TabDaily.MiddleText, "TOPRIGHT");
TabDaily.RightText:SetWidth(200);
TabDaily.RightText:SetJustifyH("RIGHT");

TabDaily.Footer = TabDaily:CreateFontString (nil, "OVERLAY", "GameFontNormalLarge");
TabDaily.Footer:SetPoint("TOPLEFT", TabDaily.LeftText, "BOTTOMLEFT", 0, -30);
TabDaily.Footer:SetWidth(600);
TabDaily.Footer:SetText("* Last Week/Month/Year will show 0 until enough data is collected.");


TabDaily:SetScript( "OnShow", function() TabDaily.tabShow(); end);
--------------------------------------------------------------------------------------------------
--			/TabDaily
--------------------------------------------------------------------------------------------------



--------------------------------------------------------------------------------------------------
--			TabWeekly
--------------------------------------------------------------------------------------------------
function TabWeekly.tabShow()
	local h = "Weekly History";			
	local l = "Profit/loss this session\n" .. ns:GetSessionChange() .. "\n\n" .. 
			"Today\n" .. ns:GetYesterdaysChange() .. "\n\n" .. 
			"This Week\n" .. ns:GetWeeksChange() .. "\n\n" .. 
			"This Year\n" .. ns:GetYearsChange() .. "\n\n\n";		
	local r = "Total Gold Yesterday\n" .. ns:GetYesterdaysGold(true) .. "\n\n" .. 
			"Last Week\n" .. ns:GetLastWeeksGold(true) .. "\n\n" .. 
			"Last Month\n" .. ns:GetLastMonthsGold(true) .. "\n\n" .. 
			"Last Year\n" .. ns:GetLastYearsGold(true);	
	TabWeekly.Header:SetText(h);	
end;

TabWeekly.Header = TabWeekly:CreateFontString (nil, "OVERLAY", "GameFontNormalLarge");
TabWeekly.Header:SetPoint("TOPLEFT", TabWeekly, "TOPLEFT", 30, -25);
TabWeekly.Header:SetWidth(600);
TabWeekly.Header:SetText("");

TabWeekly:SetScript( "OnShow", function() TabWeekly.tabShow(); end);
--------------------------------------------------------------------------------------------------
--			/TabWeekly
--------------------------------------------------------------------------------------------------



--------------------------------------------------------------------------------------------------
--			TabYearly
--------------------------------------------------------------------------------------------------
function TabYearly.tabShow()
	local h = "Yearly History";
	local l = "Profit/loss this session\n" .. ns:GetSessionChange() .. "\n\n" .. 
			"Today\n" .. ns:GetYesterdaysChange() .. "\n\n" .. 
			"This Week\n" .. ns:GetWeeksChange() .. "\n\n" .. 
			"This Year\n" .. ns:GetYearsChange() .. "\n\n\n";		
	local r = "Total Gold Yesterday\n" .. ns:GetYesterdaysGold(true) .. "\n\n" .. 
			"Last Week\n" .. ns:GetLastWeeksGold(true) .. "\n\n" .. 
			"Last Month\n" .. ns:GetLastMonthsGold(true) .. "\n\n" .. 
			"Last Year\n" .. ns:GetLastYearsGold(true);	
	TabYearly.Header:SetText(h);	
end;

TabYearly.Header = TabYearly:CreateFontString (nil, "OVERLAY", "GameFontNormalLarge");
TabYearly.Header:SetPoint("TOPLEFT", TabYearly, "TOPLEFT", 30, -25);
TabYearly.Header:SetWidth(600);
TabYearly.Header:SetText("");

TabYearly:SetScript( "OnShow", function() TabYearly.tabShow(); end);
--------------------------------------------------------------------------------------------------
--			/TabYearly
--------------------------------------------------------------------------------------------------


function ns:ShowGoldReport()
	--toggles the visibility of the report frame 	
	if ReportFrame:IsVisible() then ReportFrame:Hide(); else ReportFrame:Show(); end;
end;