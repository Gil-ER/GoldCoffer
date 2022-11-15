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

local Tab1, Tab2 = ns:SetTabs (ReportFrame, 2, "Gold Report", "Gold History")

--------------------------------------------------------------------------------------------------
--			Tab1	-		Gold Report
--------------------------------------------------------------------------------------------------
function Tab1.tabShow()
	--moved from the else in ns:ShowGoldReport()
	Tab1.goldTitle:SetText("Total gold = " .. ns:GetTotalGold(true));
	local s = ns:GetServers();
	for i=1, #s do
		--check the current server and uncheck all others
		if ns.srv == s[i] then Tab1.cb[i]:SetChecked(true); else Tab1.cb[i]:SetChecked(false); end;
		Tab1.cbText[i]:SetText(s[i] .. " - " ..  ns:GoldSilverCopper(ns:GetServerGold(s[i])));
		Tab1.cb[i]:Show();
	end;	
end;

function Tab1.cbClick(index)
	--called by the OnClick event all 50 checkboxes
	--index is the index of the box clicked (not currently used)
	local idx = 1;	-- current text row	
	--Remove old data
	for i=1, 100 do					
		Tab1.leftTxt[i]:SetText("");
		Tab1.rightTxt[i]:SetText("");
	end;
	--Update the report with data requested by selecting checkboxes
	for i=1, 50 do
		if Tab1.cb[i]:GetChecked() then
			local s = Tab1.cbText[i]:GetText();		--  Server - 12345g 67s 89c
			local g = "";
			s,g = strsplit("-", s, 2);			--  Split at the '-'
			s = strtrim(s, " ");				--  'Server'
			g = g or " ";
			g = strtrim(g, " -");				--  '12345g67s89c'
			Tab1.leftTxt[idx]:SetText(s);			--  Show values
			Tab1.rightTxt[idx]:SetText(g);
			--position the text
			if idx > 1 then
				Tab1.leftTxt[idx]:ClearAllPoints();
				Tab1.leftTxt[idx]:SetPoint("TOPLEFT", Tab1.leftTxt[idx-1], "TOPLEFT", -10, -30);				
				Tab1.rightTxt[idx]:ClearAllPoints();				
				Tab1.rightTxt[idx]:SetPoint("TOPRIGHT", Tab1.rightTxt[idx-1], "TOPRIGHT", 0, -30);
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
				Tab1.leftTxt[idx]:SetText(v.name);	
				Tab1.rightTxt[idx]:SetText(ns:GoldSilverCopper(v.gold));
				Tab1.leftTxt[idx]:ClearAllPoints();
				Tab1.leftTxt[idx]:SetPoint("TOPLEFT", Tab1.leftTxt[idx-1], "TOPLEFT", stepIn, stepDown);
				Tab1.rightTxt[idx]:ClearAllPoints();				
				Tab1.rightTxt[idx]:SetPoint("TOPRIGHT", Tab1.rightTxt[idx-1], "TOPRIGHT", 0, stepDown);
				idx = idx + 1;
				stepIn = 0;
				stepDown = -20;
			end; --for
		end; --is checked
	end; --for
end;

-- Create 'title' texts for gold
Tab1.goldTitle = Tab1:CreateFontString (nil, "OVERLAY", "GameFontNormalLarge");
Tab1.goldTitle:SetPoint("TOPLEFT", Tab1, "TOPLEFT", 0, -25);
Tab1.goldTitle:SetWidth(700);
Tab1.goldTitle:SetJustifyH("CENTER");

--	Create 50 checkboxes for server names
local params = {
	name = nil,					--globally unique, only change if you need it
	parent = Tab1,		--parent frame
	relFrame = Tab1,		--relative control for positioning
	anchor = "TOPLEFT", 		--anchor point of this form
	relPoint = "TOPLEFT",		--relative point for positioning	
	xOff = 25,					--x offset from relative point
	yOff = -55,				--y offset from relative point
	caption = "",				--Text displayed beside checkbox
	ttip = "",					--Tooltip
}

Tab1.cbText = {};			--Add tables for checkboxes and text to Tab1
Tab1.cb = {};
Tab1.leftTxt = {};
Tab1.rightTxt = {};
Tab1.cb[1], Tab1.cbText[1] = ns:createCheckBox(params);
Tab1.cb[1]:Hide();
Tab1.cb[1]:SetScript( "OnClick", function() Tab1.cbClick(1); end);

for i=2, 50 do
	params = {	
		name = nil,
		parent = Tab1,
		relFrame = Tab1.cb[i-1],	
		anchor = "TOPLEFT", 
		relPoint = "TOPLEFT",
		xOff = 0,
		yOff = -30,
		caption = "",
		ttip = "",	
	}
	Tab1.cb[i], Tab1.cbText[i] = ns:createCheckBox(params);
	Tab1.cb[i]:SetScript( "OnClick", function() Tab1.cbClick(i); end);
	Tab1.cb[i]:Hide();
end;

--create output textboxes
Tab1.leftTxt[1] = Tab1:CreateFontString (nil, "OVERLAY", "GameFontNormal");
Tab1.leftTxt[1]:SetPoint("TOPLEFT", Tab1, "TOPLEFT", 360, -65);
Tab1.leftTxt[1]:SetWidth(150);
Tab1.leftTxt[1]:SetJustifyH("LEFT");

Tab1.rightTxt[1] = Tab1:CreateFontString (nil, "OVERLAY", "GameFontNormal");
Tab1.rightTxt[1]:SetPoint("TOPLEFT", Tab1.leftTxt[1], "TOPRIGHT", 0, 0)
Tab1.rightTxt[1]:SetWidth(150);
Tab1.rightTxt[1]:SetJustifyH("RIGHT");

for i=2, 100 do			-- 100 is space for 50 servers with 1 toon on each (max for 50 character limit)
	Tab1.leftTxt[i] = Tab1:CreateFontString (nil, "OVERLAY", "GameFontNormal");
	Tab1.leftTxt[i]:SetPoint("TOPLEFT", Tab1.leftTxt[i-1], "TOPLEFT", 0, -15);
	Tab1.leftTxt[i]:SetWidth(150);
	Tab1.leftTxt[i]:SetJustifyH("LEFT");
	
	Tab1.rightTxt[i] = Tab1:CreateFontString (nil, "OVERLAY", "GameFontNormal");
	Tab1.rightTxt[i]:SetPoint("TOPRIGHT", Tab1.rightTxt[i-1], "TOPRIGHT", 0, -15)
	Tab1.rightTxt[i]:SetWidth(150);
	Tab1.rightTxt[i]:SetJustifyH("RIGHT");
end;

Tab1:SetScript( "OnShow", function() Tab1.tabShow(); end);
ReportFrame:Hide();

--------------------------------------------------------------------------------------------------
--			/Tab1	-		Gold Report
--------------------------------------------------------------------------------------------------


--------------------------------------------------------------------------------------------------
--			Tab2	-		Gold History
--------------------------------------------------------------------------------------------------
function Tab2.tabShow()
	--moved from the else in ns:ShowGoldReport()
	Tab2.goldTitle[1]:SetText(ns.player .. " - " .. ns:GoldSilverCopper(GetMoney()));
	Tab2.goldTitle[2]:SetText(ns.srv .. " - " .. ns:GetServerGold(ns.srv, true));
	Tab2.goldTitle[3]:SetText("Profit/loss this session = " .. ns:GetSessionChange());
	Tab2.goldTitle[4]:SetText("Today = " .. ns:GetYesterdaysChange());
	Tab2.goldTitle[5]:SetText("This Week = " .. ns:GetWeeksChange());
	Tab2.goldTitle[6]:SetText("This Year = " .. ns:GetYearsChange());
	Tab2.goldTitle[7]:SetText("Total Gold Yesterday = " .. ns:GetYesterdaysGold(true));
	Tab2.goldTitle[8]:SetText("Last Week = " .. ns:GetLastWeeksGold(true));
	Tab2.goldTitle[9]:SetText("Last Month = " .. ns:GetLastMonthsGold(true));
	Tab2.goldTitle[10]:SetText("Last Year = " .. ns:GetLastYearsGold(true));	
	Tab2.goldTitle[11]:SetText("* Last Week/Month/Year will show 0 until enough data is collected.");	
	Tab2.goldTitle[12]:SetText("More here in a later build.");	
	Tab2.goldTitle[13]:SetText("Data is being collected\n until then.");
end;

-- Create 'title' texts for gold comparisons
-- this all needs a redo
-- Tab2 elements
Tab2.goldTitle = {};
Tab2.goldTitle[1] = Tab2:CreateFontString (nil, "OVERLAY", "GameFontNormal");
Tab2.goldTitle[1]:SetPoint("TOPLEFT", Tab2, "TOPLEFT", 30, -25);
Tab2.goldTitle[2] = Tab2:CreateFontString (nil, "OVERLAY", "GameFontNormal");
Tab2.goldTitle[2]:SetPoint("TOPLEFT", Tab2, "TOPLEFT", 30, -50);
Tab2.goldTitle[3] = Tab2:CreateFontString (nil, "OVERLAY", "GameFontNormal");
Tab2.goldTitle[3]:SetPoint("TOPLEFT", Tab2, "TOPLEFT", 30, -100);
Tab2.goldTitle[4] = Tab2:CreateFontString (nil, "OVERLAY", "GameFontNormal");
Tab2.goldTitle[4]:SetPoint("TOPLEFT", Tab2, "TOPLEFT", 30, -125);
Tab2.goldTitle[5] = Tab2:CreateFontString (nil, "OVERLAY", "GameFontNormal");
Tab2.goldTitle[5]:SetPoint("TOPLEFT", Tab2, "TOPLEFT", 30, -150);
Tab2.goldTitle[6] = Tab2:CreateFontString (nil, "OVERLAY", "GameFontNormal");
Tab2.goldTitle[6]:SetPoint("TOPLEFT", Tab2, "TOPLEFT", 30, -175);
Tab2.goldTitle[7] = Tab2:CreateFontString (nil, "OVERLAY", "GameFontNormal");
Tab2.goldTitle[7]:SetPoint("TOPLEFT", Tab2, "TOPLEFT", 30, -225);
Tab2.goldTitle[8] = Tab2:CreateFontString (nil, "OVERLAY", "GameFontNormal");
Tab2.goldTitle[8]:SetPoint("TOPLEFT", Tab2, "TOPLEFT", 30, -250);
Tab2.goldTitle[9] = Tab2:CreateFontString (nil, "OVERLAY", "GameFontNormal");
Tab2.goldTitle[9]:SetPoint("TOPLEFT", Tab2, "TOPLEFT", 30, -275);
Tab2.goldTitle[10] = Tab2:CreateFontString (nil, "OVERLAY", "GameFontNormal");
Tab2.goldTitle[10]:SetPoint("TOPLEFT", Tab2, "TOPLEFT", 30, -300);
Tab2.goldTitle[11] = Tab2:CreateFontString (nil, "OVERLAY", "GameFontNormal");
Tab2.goldTitle[11]:SetPoint("TOPLEFT", Tab2, "TOPLEFT", 60, -325);

Tab2.goldTitle[12] = Tab2:CreateFontString (nil, "OVERLAY", "GameFontNormalLarge");
Tab2.goldTitle[12]:SetPoint("TOPLEFT", Tab2, "TOPLEFT", 400, -100);
Tab2.goldTitle[13] = Tab2:CreateFontString (nil, "OVERLAY", "GameFontNormalLarge");
Tab2.goldTitle[13]:SetPoint("TOPLEFT", Tab2, "TOPLEFT", 400, -150);
Tab2.goldTitle[13]:SetJustifyH("LEFT");

Tab2:SetScript( "OnShow", function() Tab2.tabShow(); end);

--------------------------------------------------------------------------------------------------
--			/Tab2	-		Gold History
--------------------------------------------------------------------------------------------------


function ns:ShowGoldReport()
	--toggles the visibility of the report frame 
	if ReportFrame:IsVisible() then
		ReportFrame:Hide()
	else
		--Tab1--
		--When showing the frame initialize the frame
		--ReportFrame.Title:SetText( "Gold Coffer" );

		--Hide unused checkboxes
		--Below happens on Tab1.cbClick
		--for i=#s+1, 50 do Tab1.cb[i]:SetChecked(false); Tab1.cb[i]:Hide(); end;

	
		--delete all this if things work
		
		
		--Show selected servers
		Tab1.cbClick();
		ReportFrame:Show();		
	end;
end;