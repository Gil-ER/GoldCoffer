-- Edited Aug 09, 2023

local Addon, ns = ...;
local leftPanel = nil;		
local rightPanel = nil;		
local maxCur = 200;			
local maxSubHead = 30;		
local cb;					
local cGroups;				
local cbLink;				
local pauseUpdate = false;	
local currDetail = {};		
local function cbSetText(cBox, txt)
	getglobal(cBox:GetName() .. 'Text'):SetText(txt);
end;
local function cbGetText(cBox)
	return getglobal(cBox:GetName() .. 'Text'):GetText(txt);
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
local function cb_Click(idx)
	currDetail.curr:SetText("");
	currDetail.qty:SetText("");
	currDetail.name:SetText("");
	local qty = "";
	local names = "";
	if idx > 0 and cb[idx]:GetChecked() then	
		local grp = cbLink[idx].gID;
		local cur = getglobal(cb[idx]:GetName() .. 'Text'):GetText();
		currDetail.curr:SetText(cur)
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
	currDetail.qty:SetText(qty .. "\n");	
	currDetail.name:SetText(names .. "\n");	
end;
local function SetCheckBoxes()
	cb = {};	
	for i = 1, maxCur do
		idx = i;
		cb[i] = CreateFrame("CheckButton", "GoldCofferCurrency" .. i, leftPanel, "ChatConfigCheckButtonTemplate");
		cb[i]:SetSize(32, 32);
		cb[i]:Hide()	
		cb[i]:SetScript("OnClick", function (self) 
			if pauseUpdate then return; end;
			pauseUpdate = true;
			for c=1, maxCur do
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
local function SetCurrencyDetail(parent)
	local ret = {};
	ret.curr = parent:CreateFontString (nil, "OVERLAY", "GameFontNormalLarge");
	ret.curr:SetPoint("TOPLEFT", parent, "TOPLEFT", 0, -20);
	ret.curr:SetWidth(275);
	ret.curr:SetJustifyH("CENTER");
	ret.qty = parent:CreateFontString (nil, "OVERLAY", "GameFontNormal");
	ret.qty:SetSpacing(7);
	ret.qty:SetPoint("TOPLEFT", ret.curr, "BOTTOMLEFT", 30, -20);
	ret.qty:SetWidth(70);
	ret.qty:SetJustifyH("RIGHT");
	ret.name = parent:CreateFontString (nil, "OVERLAY", "GameFontNormal");
	ret.name:SetSpacing(7);
	ret.name:SetPoint("TOPLEFT", ret.qty, "TOPRIGHT", 10, 0);
	ret.name:SetWidth(270);
	ret.name:SetJustifyH("LEFT");
	return ret;
end;
function ns:CurrencyClear()
	if cb ~= nil then					
		for i = 1, maxCur do
			cb[i]:SetChecked(false);
			cb[i]:ClearAllPoints();
			cb[i]:Hide();
		end;
	end;
	if cGroups ~= nil then				
		for i = 1, maxSubHead do
			cGroups[i]:SetText("");
			cGroups[i]:ClearAllPoints();
		end;
		currDetail.curr:SetText("");	
		currDetail.qty:SetText("");
		currDetail.name:SetText("");
	end;
end;
function ns:Currency(l, r)
	if leftPanel == nil then		
		leftPanel = l;
		rightPanel = r;
		SetCheckBoxes();
		cGroups = SetStrings(leftPanel);
		currDetail = SetCurrencyDetail(rightPanel)
	else							
		ns:CurrencyClear();
	end;
	cbLink = {};
	local cbIdx = 1;								
	local sIdx = 1;
	local yPos = -10;		
	local loc = GetLocale();						
	for k, v in ipairs (ns.GroupOrder) do
		if GoldCofferCurrencies[v] then				
			cGroups[sIdx]:ClearAllPoints();			
			if sIdx > 1 then yPos = yPos - 45; end;
			cGroups[sIdx]:SetPoint("TOPLEFT", leftPanel, 0, yPos);
			cGroups[sIdx]:SetText(ns.GetGroupFromID ( v, loc ));
			cGroups[sIdx]:Show();
			sIdx = sIdx + 1;						
			if GoldCofferCurrencies and GoldCofferCurrencies[v] then
				for id, t in pairs (GoldCofferCurrencies[v]) do	
					cb[cbIdx]:ClearAllPoints()
					yPos = yPos - 30;
					cb[cbIdx]:SetPoint("TOPLEFT", leftPanel, 10, yPos);
					cb[cbIdx]:Show();			
					local ci = C_CurrencyInfo.GetCurrencyInfo(id)
					local color = ci.quality and ITEM_QUALITY_COLORS[ci.quality].hex or ""
					local icon = (ci.iconFileID and "|T"..ci.iconFileID..":12|t " or "") .. color .. ci.name .. "|r";
					cbSetText(cb[cbIdx], icon);	
					cbLink[cbIdx] = { ["gID"] = v, ["cID"] = id };
					cbIdx = cbIdx + 1;			
				end;	
			end;	
		end;	
	end;	
end;
