-- Edited Aug 09, 2023

local Addon, ns = ...;
local leftPanel = nil;		
local rightPanel = nil;		
local maxCB = 75;			
local maxSubHead = 50;		
local cb;					
local groups;				
local cbLink = {};			
local cbSelection = 0;
local DeleteDetail;
local pauseUpdate = false;	
local function cbSetText(cBox, txt)
	getglobal(cBox:GetName() .. 'Text'):SetText(txt);
end;
local function cbGetText(cBox)
	return getglobal(cBox:GetName() .. 'Text'):GetText(txt);
end;
local function resetPage()
	local servers = ns:GetServers();	
	local yPos = -10;					
	local cbIdx = 1;					
	local tbIdx = 2;					
	groups[1]:SetText(ns:colorString("white", "        
	groups[1]:ClearAllPoints()
	groups[1]:SetPoint("TOPLEFT", leftPanel, 10, -10)
	groups[1]:Show();
	for k, s in ipairs(servers) do					
		groups[tbIdx]:SetText(s);
		groups[tbIdx]:ClearAllPoints()
		yPos = yPos - 45;
		groups[tbIdx]:SetPoint("TOPLEFT", leftPanel, 20, yPos)
		groups[tbIdx]:Show();
		local toons = ns:GetToons(s);
		for _, t in ipairs(toons) do				
			cb[cbIdx]:ClearAllPoints()
			yPos = yPos - 30;
			cb[cbIdx]:SetPoint("TOPLEFT", leftPanel, 30, yPos);
			cbSetText(cb[cbIdx], t);
			cb[cbIdx]:Show();
			cbLink[cbIdx] = {["Type"] = "toon", ["server"] = s, ["id"] = t};
			cbIdx = cbIdx + 1;
		end;
		tbIdx = tbIdx + 1;
	end;
	groups[tbIdx]:SetText(ns:colorString("white", "          
	groups[tbIdx]:ClearAllPoints();
	yPos = yPos - 55;
	groups[tbIdx]:SetPoint("TOPLEFT", leftPanel, 10, yPos)
	groups[tbIdx]:Show();
	tbIdx = tbIdx + 1;
	servers = ns:GetGuildServers();
	for k, s in ipairs(servers) do					
		groups[tbIdx]:SetText(s);
		groups[tbIdx]:ClearAllPoints()
		yPos = yPos - 45;
		groups[tbIdx]:SetPoint("TOPLEFT", leftPanel, 20, yPos)
		groups[tbIdx]:Show();
		local guilds = ns:GetGuilds(s);
		for _, g in ipairs(guilds) do				
			cb[cbIdx]:ClearAllPoints()
			yPos = yPos - 30;
			cb[cbIdx]:SetPoint("TOPLEFT", leftPanel, 30, yPos);
			cbSetText(cb[cbIdx], g);
			cb[cbIdx]:Show();
			cbLink[cbIdx] = {["Type"] = "guild", ["server"] = s, ["id"] = g};
			cbIdx = cbIdx + 1;
		end;
		tbIdx = tbIdx + 1;
	end;	
	DeleteDetail.desc:Hide();
end;
local function cb_Click(idx)
	if cb[idx]:GetChecked() then					
		cbSelection = idx;							
		local s = "Deleting\n\n"					
		if cbLink[idx]["Type"] == "guild" then		
			s = s .. "Guild: " .. cbLink[idx]["id"] .. 
				"\nOn Server: " .. cbLink[idx]["server"] .. "\n\nClick below to proceed."
		end;
		if cbLink[idx]["Type"] == "toon" then
			s = s .. "Character: " .. cbLink[idx]["id"] .. 
				"\nOn Server: " .. cbLink[idx]["server"] .. "\n\nClick below to proceed."
		end;	
		DeleteDetail.desc:SetText(s);				
		DeleteDetail.desc:Show();
		DeleteDetail.button:Show();					
	else
		DeleteDetail.button:Hide();					
		DeleteDetail.desc:Hide();					
		cbSelection = 0;
		s = "";
	end;	
end;
local function SetCheckBoxes()
	cb = {};	
	for i = 1, maxCB do
		idx = i;
		cb[i] = CreateFrame("CheckButton", "GoldCofferDelete" .. i, leftPanel, "ChatConfigCheckButtonTemplate");
		cb[i]:SetSize(32, 32);
		cb[i]:Hide()	
		cb[i]:SetScript("OnClick", function (self) 
			if pauseUpdate then return; end;
			pauseUpdate = true;
			for c=1, maxCB do
				if c ~= i then cb[c]:SetChecked(false); end;
			end;
			pauseUpdate = false;
			cb_Click(i); 	
		end)
	end;
end;
local function SetStrings(f)
	local s = {};		
	for i = 1, maxSubHead do
		s[i] = f:CreateFontString (nil, "OVERLAY", "GameFontNormalLarge");
		s[i]:Hide();
	end;
	return s;	
end;
local function SetDeleteDetail(parent)
	local ret = {};
	local w = parent:GetWidth() - 50;
	ret.instruct = parent:CreateFontString (nil, "OVERLAY", "GameFontNormalLarge");
	ret.instruct:SetPoint("TOPLEFT", parent, "TOPLEFT", 20, -20);
	ret.instruct:SetWidth(w);
	ret.instruct:SetJustifyH("LEFT");
	ret.instruct:SetText("You are deleting a Character/Guild.\n\n" ..
			"Nothing is really being deleted except the data this addon has collected.\n\n" ..
			"If you accidently delete a character the next time you log into them they will be " ..
			"added again however all history will be lost.")
	ret.desc = parent:CreateFontString (nil, "OVERLAY", "GameFontNormalLarge");
	ret.desc:SetPoint("TOPLEFT", ret.instruct, "BOTTOMLEFT", 0, -40);
	ret.desc:SetWidth(w);
	ret.desc:SetJustifyH("CENTER");
	ret.button = CreateFrame("Button", nil, parent, "UIPanelButtonTemplate");
	ret.button:SetPoint("TOPRIGHT", ret.desc, "BOTTOMRIGHT", 0 , -30);
	ret.button:SetSize(100, 40);
	ret.button:SetText("Delete");
	ret.button:Hide();
	ret.button:SetScript("OnClick", function()				
		if cbSelection > 0 then
			local s = cbLink[cbSelection].server;			
			local id = cbLink[cbSelection].id;				
			if cbLink[cbSelection].Type == "toon" then
				GoldCoffer.Servers[s][id] = nil;			
			elseif cbLink[cbSelection].Type == "guild" then
				GoldCoffer.Guilds[s][id] = nil;				
			end;
			ns:DeleteClear();			
			DeleteDetail.instruct:Show();
			resetPage();
		end;
	end);
	return ret;
end;
function ns:DeleteClear()
	if cb ~= nil then					
		for i = 1, maxCB do
			cb[i]:SetChecked(false);
			cb[i]:ClearAllPoints();
			cb[i]:Hide();
		end;
	end;
	if groups ~= nil then
		for i = 1, maxSubHead do
			groups[i]:SetText("");
			groups[i]:ClearAllPoints();
		end;
		DeleteDetail.instruct:Hide();
		DeleteDetail.desc:Hide();
		DeleteDetail.button:Hide();
	end;
end;
function ns:Delete(l, r)
	if leftPanel == nil then		
		leftPanel = l;
		rightPanel = r;
		SetCheckBoxes();
		groups = SetStrings(leftPanel);
		DeleteDetail = SetDeleteDetail(rightPanel);
	else							
		ns:DeleteClear();
		DeleteDetail.instruct:Show();
	end;
	resetPage();	
end;
