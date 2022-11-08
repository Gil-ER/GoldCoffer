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
ReportFrame.ScrollFrame:SetPoint("BOTTOMRIGHT", gcReportFrame, "BOTTOMRIGHT", -3, 4);
ReportFrame.ScrollFrame:SetClipsChildren(true);
ReportFrame:EnableMouseWheel(1)
ReportFrame.ScrollFrame.ScrollBar:ClearAllPoints();
ReportFrame.ScrollFrame.ScrollBar:SetPoint("TOPLEFT", ReportFrame.ScrollFrame, "TOPRIGHT", -12, -18);
ReportFrame.ScrollFrame.ScrollBar:SetPoint("BOTTOMRIGHT", ReportFrame.ScrollFrame, "BOTTOMRIGHT", -7, 18);

local Tab1, Tab2 = ns:SetTabs (ReportFrame, 2, "Gold Report", "Gold History")

--------------------------------------------------------------------------------------------------
--			Tab1	-		Gold Report
--------------------------------------------------------------------------------------------------
local cb = {};				--Server Checkboxes
local cbText = {};			--Checkbox text
local leftTxt = {};			--Textboxes for left side
local rightTxt = {};		--Textboxes for left side
local goldTitle;

local function cbClick(index)
	--called by the OnClick event all 50 checkboxes
	--index is the index of the box clicked (not currently using the info)
	local idx = 1;	-- current text row	
	--Remove old data
	for i=1, 100 do					
		leftTxt[i]:SetText("");
		rightTxt[i]:SetText("");
	end;
	--Update the report with data requested by selecting checkboxes
	for i=1, 50 do
		if cb[i]:GetChecked() then
			local s = cbText[i]:GetText();		--  Server - 12345g 67s 89c
			local g = "";
			s,g = strsplit("-", s, 2);			--  Split at the '-'
			s = strtrim(s, " ");				--  'Server'
			g = g or " ";
			g = strtrim(g, " -");				--  '12345g67s89c'
			leftTxt[idx]:SetText(s);			--  Show values
			rightTxt[idx]:SetText(g);
			--position the text
			if idx > 1 then
				leftTxt[idx]:ClearAllPoints();
				leftTxt[idx]:SetPoint("TOPLEFT", leftTxt[idx-1], "TOPLEFT", -10, -30);				
				rightTxt[idx]:ClearAllPoints();				
				rightTxt[idx]:SetPoint("TOPRIGHT", rightTxt[idx-1], "TOPRIGHT", 0, -30);
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
				leftTxt[idx]:SetText(v.name);	
				rightTxt[idx]:SetText(ns:GoldSilverCopper(v.gold));
				leftTxt[idx]:ClearAllPoints();
				leftTxt[idx]:SetPoint("TOPLEFT", leftTxt[idx-1], "TOPLEFT", stepIn, stepDown);
				rightTxt[idx]:ClearAllPoints();				
				rightTxt[idx]:SetPoint("TOPRIGHT", rightTxt[idx-1], "TOPRIGHT", 0, stepDown);
				idx = idx + 1;
				stepIn = 0;
				stepDown = -20;
			end; --for
		end; --is checked
	end; --for
end;

-- Create 'title' texts for gold
goldTitle = Tab1:CreateFontString (nil, "OVERLAY", "GameFontNormal");
goldTitle:SetPoint("TOPLEFT", Tab1, "TOPLEFT", 0, -25);
goldTitle:SetWidth(300);
goldTitle:SetJustifyH("CENTER");

--	Create 50 checkboxes for server names
local params = {
	name = nil,					--globally unique, only change if you need it
	parent = Tab1,		--parent frame
	relFrame = Tab1,		--relative control for positioning
	anchor = "TOPLEFT", 		--anchor point of this form
	relPoint = "TOPLEFT",		--relative point for positioning	
	xOff = 25,					--x offset from relative point
	yOff = -45,				--y offset from relative point
	caption = "",				--Text displayed beside checkbox
	ttip = "",					--Tooltip
}

cb[1], cbText[1] = ns:createCheckBox(params);
cb[1]:Hide();
cb[1]:SetScript( "OnClick", function() cbClick(1); end);

for i=2, 50 do
	params = {	
		name = nil,
		parent = Tab1,
		relFrame = cb[i-1],	
		anchor = "TOPLEFT", 
		relPoint = "TOPLEFT",
		xOff = 0,
		yOff = -30,
		caption = "",
		ttip = "",	
	}
	cb[i], cbText[i] = ns:createCheckBox(params);
	cb[i]:SetScript( "OnClick", function() cbClick(i); end);
	cb[i]:Hide();
end;

--create output textboxes
leftTxt[1] = Tab1:CreateFontString (nil, "OVERLAY", "GameFontNormal");
leftTxt[1]:SetPoint("TOPLEFT", Tab1, "TOPLEFT", 340, -25);
leftTxt[1]:SetWidth(150);
leftTxt[1]:SetJustifyH("LEFT");

rightTxt[1] = Tab1:CreateFontString (nil, "OVERLAY", "GameFontNormal");
rightTxt[1]:SetPoint("TOPLEFT", leftTxt[1], "TOPRIGHT", 0, 0)
rightTxt[1]:SetWidth(150);
rightTxt[1]:SetJustifyH("RIGHT");

for i=2, 100 do			-- 100 is space for 50 servers with 1 toon on each (max for 50 character limit)
	leftTxt[i] = Tab1:CreateFontString (nil, "OVERLAY", "GameFontNormal");
	leftTxt[i]:SetPoint("TOPLEFT", leftTxt[i-1], "TOPLEFT", 0, -15);
	leftTxt[i]:SetWidth(150);
	leftTxt[i]:SetJustifyH("LEFT");
	
	rightTxt[i] = Tab1:CreateFontString (nil, "OVERLAY", "GameFontNormal");
	rightTxt[i]:SetPoint("TOPRIGHT", rightTxt[i-1], "TOPRIGHT", 0, -15)
	rightTxt[i]:SetWidth(150);
	rightTxt[i]:SetJustifyH("RIGHT");
end;

function ns:ShowGoldReport()
	--toggles the visibility of the report frame 
	if ReportFrame:IsVisible() then
		ReportFrame:Hide()
	else
		--When showing the frame initialize the frame
		--ReportFrame.Title:SetText( "Gold Coffer" );
		goldTitle:SetText("Total gold = " .. ns:GetTotalGold(true));
		local s = ns:GetServers();
		for i=1, #s do
			--check the current server and uncheck all others
			if ns.srv == s[i] then cb[i]:SetChecked(true); else cb[i]:SetChecked(false); end;
			cbText[i]:SetText(s[i] .. " - " ..  ns:GoldSilverCopper(ns:GetServerGold(s[i])));
			cb[i]:Show();
		end;
		--Hide unused checkboxes
		for i=#s+1, 50 do cb[i]:SetChecked(false); cb[i]:Hide(); end;
		--Show selected servers
		cbClick();
		ReportFrame:Show();
	end;
end;

ReportFrame:Hide();

--------------------------------------------------------------------------------------------------
--			/Tab1	-		Gold Report
--------------------------------------------------------------------------------------------------






