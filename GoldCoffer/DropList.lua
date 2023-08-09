-- Edited Aug 09, 2023

local _, ns = ...
local editBoxWidth = 200;
local editBoxHeight = 30;
local editBoxDefaultText = "";
local buttonWidth = 60;
local dropFrameHeight = 300;
local dropFrameWidth = editBoxWidth + buttonWidth
local maxEntries = 20;
function ns.newDropList(parent, xOff, yOff)
	local list = {};
	local f = CreateFrame("EditBox", nil, parent, "InputBoxTemplate");
	f:SetPoint("TOPLEFT", parent, "TOPLEFT", xOff, yOff);
	f:SetWidth(editBoxWidth);
	f:SetHeight(30);
	f:SetEnabled(false);
	f:SetText(editBoxDefaultText)
	f:SetScript("OnShow", function(self) self.ebButton:Show(); end);
	f:SetScript("OnHide", function(self) self.ebButton:Hide(); end);
	f.ebButton = CreateFrame("Button", nil, parent, "UIPanelButtonTemplate");
	f.ebButton:SetPoint("TOPLEFT", f, "TOPRIGHT", 0 , 0);
	f.ebButton:SetSize(buttonWidth, editBoxHeight);
	f.ebButton:SetText("Select");
	f.ebButton:SetScript("OnClick", function() 
		if f.dropFrame:IsVisible() then f.dropFrame:Hide();
			else f.dropFrame:Show();
		end;
	end);
	f.dropFrame = CreateFrame("Frame", nil, parent, "InsetFrameTemplate");
	f.dropFrame:SetSize(dropFrameWidth, dropFrameHeight);
	f.dropFrame:SetPoint("TOPLEFT", f, "BOTTOMLEFT", 0, 0)
	f.dropFrame:SetFrameStrata("TOOLTIP");	
	local sTemplate = "UIPanelScrollFrameTemplate";	
	if select(4, GetBuildInfo()) >= 100100 then sTemplate = "ScrollFrameTemplate"; end
	f.sFrame = CreateFrame("ScrollFrame", nil, f.dropFrame, sTemplate)	
	f.sFrame:SetSize(dropFrameWidth - 45, dropFrameHeight - 20)
	f.sFrame:SetPoint("TOPLEFT", f.dropFrame, "TOPLEFT", 20, -15)
	f.sChild = CreateFrame("Frame");
	f.sChild:SetFrameStrata("TOOLTIP");	
	f.sChild:SetSize(dropFrameWidth, dropFrameHeight * 2)
	f.sFrame:SetScrollChild(f.sChild);
	local t = {};
	for i = 1, maxEntries do
		t[i] = CreateFrame("Frame",nil,f.sChild);
		t[i]:SetSize(f.sChild:GetWidth(), 20);
		t[i]:SetPoint("TOPLEFT", 0, -(i-1) * 20);
		t[i].texture = t[i]:CreateTexture()
		t[i].texture:SetTexture("Interface/BUTTONS/WHITE8X8")
		t[i].texture:SetVertexColor(0, 0, 0, 0)		
		t[i].font = t[i]:CreateFontString(nil, "OVERLAY", "GameFontNormal")
		t[i].font:SetPoint("CENTER", t[i], "CENTER")
		t[i].font:SetTextColor(1, 1, 1, 1)			
		t[i].font:SetWidth(t[i]:GetWidth());
		t[i].font:SetJustifyH("LEFT");
		t[i].texture:SetAllPoints(t[i])
		t[i]:SetScript("OnEnter", function (self)
			self.texture:SetVertexColor(.4, .4, .4, .25)
		end)	
		t[i]:SetScript("OnLeave", function (self)
			self.texture:SetVertexColor(0, 0, 0, 0)
		end)
		t[i]:SetScript("OnMouseDown", function (self)
			f:SetText(self.font:GetText());
			f.dropFrame:Hide();		
		end)
	end;
	f.dropFrame:Hide();
	f:Show();
	function list:SetList(list, sortFlag)
		if sortFlag then table.sort(list); end;
		local i = 1;
		while i <= #list do		
			t[i].font:SetText(list[i]);		
			t[i]:Show();					
			i = i + 1;
			if i > maxEntries then break end;
		end;		
		while i <= maxEntries do			
			t[i]:Hide();
			i = i + 1;
		end;
		if #list >= 1 then f:SetText(list[1]); end;
	end;	
	return f, list;
end;
