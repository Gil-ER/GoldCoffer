-- Edited Feb 23, 2024

local Addon, ns = ...;
local pauseReport = true;
local toonDefault = "All Characters";
local guildDefault = "Select a Guild";
local reportTypes = {"Gold Report", "Gold Summary", "Daily History", "Weekly History", "Yearly History", "Other Currencies", "Export Options", "Export CSV", "Delete a Character or Guild"};
if select(4, GetBuildInfo()) < 100000 then reportTypes = {"Gold Report", "Gold Summary", "Daily History", "Weekly History", "Yearly History", "Export Options", "Export CSV", "Delete a Character or Guild"}; end;
	ns.output = CreateFrame("Frame", "GoldCofferOutputFrame", UIParent, "ButtonFrameTemplate"); 
	ns.output:SetSize(700, 500);
	ns.output:SetPoint("CENTER", UIParent, "CENTER");
	_G[ns.output:GetName() .. "TitleText"]:SetText("Gold Coffer")
	ns.output:EnableMouse(true);
	ns.output:SetMovable(true);
	ns.output:SetUserPlaced(true); 
	ns.output:RegisterForDrag("LeftButton");
	ns.output:SetScript("OnDragStart", function(self) self:StartMoving() end);
	ns.output:SetScript("OnDragStop", function(self) self:StopMovingOrSizing(); end);
	_G[ns.output:GetName() .. "Portrait"]:SetTexture("Interface\\Icons\\inv_misc_coin_01")
	local ReportType, ReportList = ns.newDropList(ns.output, 220, -30)	
	ReportList:SetList(reportTypes)	
	local dlServers, ServersList = ns.newDropList(ns.output, 70, -70)	
	ServersList:SetList({""})
	dlServers:Hide();
	local dlToons, ToonsList = ns.newDropList(ns.output, 360, -70)	
	ToonsList:SetList({""})
	dlToons:Hide();
	local dlGuilds, GuildsList = ns.newDropList(ns.output, 360, -110)	
	GuildsList:SetList({guildDefault})
	dlGuilds:Hide();	
	local f = CreateFrame("Frame", nil, ns.output, "InsetFrameTemplate");
	f:SetSize(ns.output:GetWidth()-40, 300);
	f:SetPoint("TOPLEFT", ns.output, "TOPLEFT", 20, -70)
	ns.sChild = CreateFrame("Frame");
	local sTemplate = "UIPanelScrollFrameTemplate";	
	if select(4, GetBuildInfo()) >= 100100 then sTemplate = "ScrollFrameTemplate"; end
	local sFrame = CreateFrame("ScrollFrame", nil, f, sTemplate);
	sFrame:SetSize(f:GetWidth() - 35, f:GetHeight() - 15);
	sFrame:SetPoint("TOPLEFT", f, "TOPLEFT", 10, -10)
	ns.sChild:SetSize(sFrame:GetWidth(), 1);	
	sFrame:SetScrollChild(ns.sChild);
	ns.output.tTotal = ns.output:CreateFontString(nil, "OVERLAY", "GameFontNormal");
	ns.output.tTotal:SetPoint("BOTTOMLEFT", ns.output, "BOTTOMLEFT", 20, 7);
	ns.output.tTotal:SetJustifyH("LEFT");
	ns.output.tTotal:SetText("Toon: " .. ns:GoldSilverCopper(GetMoney()), true);
	ns.output.aTotal = ns.output:CreateFontString(nil, "OVERLAY", "GameFontNormal");
	ns.output.aTotal:SetPoint("BOTTOMRIGHT", ns.output, "BOTTOMRIGHT", -20, 7);
	ns.output.aTotal:SetJustifyH("RIGHT");
	ns.output.aTotal:SetText("Total: ");
	ns.output.sTotal = ns.output:CreateFontString(nil, "OVERLAY", "GameFontNormal");
	ns.output.sTotal:ClearAllPoints();
	ns.output.sTotal:SetPoint("TOPLEFT", ns.output.tTotal, "TOPRIGHT");
	ns.output.sTotal:SetPoint("BOTTOMRIGHT", ns.output.aTotal, "BOTTOMLEFT");
	ns.output.sTotal:SetText("Server: ");
	local options = CreateFrame("Frame", nil, ns.output, "InsetFrameTemplate");
	options:SetSize(ns.output:GetWidth()-40, 390);
	options:SetPoint("TOPLEFT", ns.output, "TOPLEFT", 20, -70)
	options.sFrame = CreateFrame("ScrollFrame", nil, options, sTemplate);
	options.sFrame:SetSize(options:GetWidth() - 35, options:GetHeight() - 15);
	options.sFrame:SetPoint("TOPLEFT", options, "TOPLEFT", 10, -10)
	options.sChild = CreateFrame("Frame");
	options.sChild:SetSize(options.sFrame:GetWidth(), 100);
	options.sFrame:SetScrollChild(options.sChild);	
	options:Hide();
	w = (ns.output:GetWidth()-35) /2
	local fCurrencies = CreateFrame("Frame", nil, ns.output, "InsetFrameTemplate");
	fCurrencies:SetSize(w, 390);
	fCurrencies:SetPoint("TOPLEFT", ns.output, "TOPLEFT", 10, -70)
	fCurrencies.sFrame = CreateFrame("ScrollFrame", nil, fCurrencies, sTemplate);
	fCurrencies.sFrame:SetSize(fCurrencies:GetWidth() - 35, fCurrencies:GetHeight() - 15);
	fCurrencies.sFrame:SetPoint("TOPLEFT", fCurrencies, "TOPLEFT", 10, -10)
	fCurrencies.sChild = CreateFrame("Frame");
	fCurrencies.sChild:SetSize(fCurrencies.sFrame:GetWidth(), 1);
	fCurrencies.sFrame:SetScrollChild(fCurrencies.sChild);
	fCurrencies:Hide();
	local fCurrencyDetail = CreateFrame("Frame", nil, ns.output, "InsetFrameTemplate");
	fCurrencyDetail:SetSize(w, 390);
	fCurrencyDetail:SetPoint("TOPLEFT", fCurrencies, "TOPRIGHT", 8, 0)
	fCurrencyDetail.sChild = CreateFrame("Frame");
	fCurrencyDetail.sFrame = CreateFrame("ScrollFrame", nil, fCurrencyDetail, sTemplate);
	fCurrencyDetail.sFrame:SetSize(fCurrencyDetail:GetWidth() - 35, fCurrencyDetail:GetHeight() - 15);
	fCurrencyDetail.sFrame:SetPoint("TOPLEFT", fCurrencyDetail, "TOPLEFT", 10, -10)
	fCurrencyDetail.sChild:SetSize(fCurrencyDetail.sFrame:GetWidth(), 1);
	fCurrencyDetail.sFrame:SetScrollChild(fCurrencyDetail.sChild);
	fCurrencyDetail:Hide();	
	ReportType:SetText("Gold Report");		
	ns.output:Hide();
	pauseReport = false;
ReportType:SetScript("OnTextChanged", function(self)
	dlServers:Hide();			
	dlToons:Hide();
	dlGuilds:Hide();
	fCurrencies:Hide(); 
	fCurrencyDetail:Hide();
	options:Hide();
	ns:Clear();					
	f:Show();					
	f:SetPoint("TOPLEFT", ns.output, "TOPLEFT", 20, -70);	
	f:SetHeight(390);
	local selection = self:GetText();
	if selection == "Gold Report" then ns.GoldReport(); end;			
	if (selection == "Gold Summary") then 
		f:SetPoint("TOPLEFT", ns.output, "TOPLEFT", 20, -150);
		f:SetHeight(310);
		local sl = ns:GetServers();
		tinsert(sl, 1, "All Servers");
		ServersList:SetList(sl);
		dlServers:Show();
		dlServers:SetText(""); 
		dlServers:SetText(sl[1]); 
	end;
	if selection == "Daily History" then ns.DailyHistory(); end;
	if selection == "Weekly History" then ns.WeeklyHistory(); end;
	if selection == "Yearly History" then ns.YearlyHistory(); end;	
	if selection == "Other Currencies" then 
		f:Hide(); 
		ns:DeleteClear()
		fCurrencies:Show(); 
		fCurrencyDetail:Show(); 
		ns:Currency(fCurrencies.sChild, fCurrencyDetail.sChild);
	end;	
	if selection == "Export Options" then 
		f:Hide();
		options:Show()
		ns:OptionsFrame(options.sChild); 
	end;
	if selection == "Export CSV" then ns.output:Hide(); ns:exportFrame(); end;
	if selection == "Delete a Character or Guild" then 
		f:Hide();
		ns:CurrencyClear()
		fCurrencies:Show(); 
		fCurrencyDetail:Show(); 
		ns:Delete(fCurrencies.sChild, fCurrencyDetail.sChild)
	end;
end)
ns.output:SetScript("OnShow", function (self)
	self.tTotal:SetText("Toon: " .. ns:GoldSilverCopper(GetMoney(), true));	
	self.aTotal:SetText("Account: " ..  ns:GoldSilverCopper(ns:GetTotalGold(), true));
	self.sTotal:SetText("Server: " ..  ns:GoldSilverCopper(ns:GetServerGold(GetRealmName(), false), true));
	ReportType:SetText("Gold Report");
end)
dlServers:SetScript("OnTextChanged", function(self)
	if pauseReport then return; end;	 
	local selection = self:GetText();
	if selection == "" then return end;
	if selection == "All Servers" then 
	else 
		pauseReport = true;						
		local gl = ns:GetGuilds(selection);		
		tinsert(gl, 1, guildDefault);			
		GuildsList:SetList(gl);					
		dlGuilds:SetText(gl[1]);				
		dlGuilds:Show();		
		local tl = ns:GetToons(selection);		
		tinsert(tl, 1, toonDefault);			
		ToonsList:SetList(tl);					
		dlToons:SetText("");					
		dlToons:SetText(tl[1]);
		dlToons:Show();
		pauseReport = false;					
	end;	
	ns:GoldSummary(selection, dlToons:GetText(), dlGuilds:GetText())
end)
dlServers:HookScript("OnHide", function (self) dlGuilds:Hide(); dlToons:Hide(); end)
dlToons:SetScript("OnTextChanged", function(self)
	if pauseReport then return; end;	
	pauseReport = true;	
	dlGuilds:SetText(guildDefault)
	ns:GoldSummary(dlServers:GetText(), self:GetText(), dlGuilds:GetText())
	pauseReport = false;	
end)
dlGuilds:SetScript("OnTextChanged", function(self)
	if pauseReport then return; end;
	pauseReport = true;	
	dlToons:SetText(toonDefault)
	ns:GoldSummary(dlServers:GetText(), dlToons:GetText(), self:GetText())
	pauseReport = false;	
end)
f:SetScript("OnSizeChanged", function()	
	sFrame:SetSize(f:GetWidth() - 35, f:GetHeight() - 15);
end)
function ns:CenterReport()
	ns.output:Show(); 
	ns.output:ClearAllPoints();
	ns.output:SetPoint("CENTER", UIParent, "CENTER");
end;
function ns:ShowReport()
	if ns.output:IsVisible() then 
		ns.output:Hide(); 
	else 
		ns.output:Show(); 
	end;
end;
