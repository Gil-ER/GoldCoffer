-- Edited Aug 09, 2023

local Addon, ns = ...;
local frame = nil;
ns.CharOpt = {"", "", "Current", "UpdateTime", "LastUpdate", 
					"DayStart", "WeekStart", "MonthStart", "YearStart", 
					"Yesterday", "LastWeek", "LastMonth", "LastYear"};
ns.CharOptV = {"Server", "Name", "Current Gold", "Last Update Time", "Last Update Date", "Start of the Day", 
					"Start of the Week", "Start of the Month", "Start of the Year", 
					"Profit Yesterday", "Profit Last Week", "Profit Last Month", "Profit Last Year"};
ns.dCharOpt = "1,1,1,0,1,1,1,1,1,0,0,0,0";							
ns.SrvOpt = {"", "Current", "DayStart", "WeekStart", "MonthStart", "YearStart", 
					"Yesterday", "LastWeek", "LastMonth", "LastYear"};
ns.SrvOptV = {"Server", "Current Gold", "Start of the Day", "Start of the Week", 
					"Start of the Month", "Start of the Year", "Profit Yesterday", 
					"Profit Last Week", "Profit Last Month", "Profit Last Year"};								
ns.dSrvOpt = "1,1,1,1,1,1,0,0,0,0";
ns.GuildOpt = {"", "", "Current",  
					"DayStart", "WeekStart", "MonthStart", "YearStart", 
					"Yesterday", "LastWeek", "LastMonth", "LastYear"};
ns.GuildOptV = {"Server", "Guild", "Current Gold", "Start of the Day", 
					"Start of the Week", "Start of the Month", "Start of the Year", 
					"Profit Yesterday", "Profit Last Week", "Profit Last Month", "Profit Last Year"};								
ns.dGuildOpt = "1,1,1,1,1,1,1,0,0,0,0";								
local function LookupOption(t, s)
	for k, v in ipairs (t) do
		if v == s then return k; end;
	end;
	return 0;
end;
local function SetCheckBoxes(parent)
	local captions = 	{	
							"Character Data",
							"Server Data",							
							"Guild Data",
							"Currencies",
						}	
	local cb = {};
	cb[1] = CreateFrame("CheckButton", "GoldCofferCB1", parent, "ChatConfigCheckButtonTemplate");
	cb[1]:SetPoint("TOPLEFT", parent, "TOPLEFT", 10, -10);
	cb[1]:SetSize(32, 32);
	getglobal(cb[1]:GetName() .. 'Text'):SetText(captions[1]);	
	local i = 2;
	while i <= #captions do
		cb[i] = CreateFrame("CheckButton", "GoldCofferCB" .. i, parent, "ChatConfigCheckButtonTemplate");
		cb[i]:SetPoint("TOPLEFT", cb[i - 1], "TOPLEFT", 0, -30);
		cb[i]:SetSize(32, 32);
		getglobal(cb[i]:GetName() .. 'Text'):SetText(captions[i]);	
		i = i + 1;
	end;
	return cb;
end
local function iniReportTypes()
	GoldCoffer = GoldCoffer or {}
	GoldCoffer.Reports = GoldCoffer.Reports or {
		["Character Data"] = ns.dCharOpt; 
		["Guild Data"] = ns.dGuildOpt; 
		["Server History"] = ns.dSrvOpt;	
		["Currencies"] = {};
	}
end;
local function CharacterData()
	GoldCoffer.Reports["Character Data"] = GoldCoffer.Reports["Character Data"] or ns.dCharOpt;
	local keyString	= strsplittable (",", GoldCoffer.Reports["Character Data"]);
	local pos = 1;					
	local ReportItems = {};			
	local ret = "Server,Name"		
	for i = 3, #ns.CharOpt do		
		if keyString[i] == "1" then
			tinsert(ReportItems, pos, ns.CharOpt[i]);
			ret = ret .. "," .. ns.CharOptV[i]					
			pos = pos + 1;
		end;
	end;	
	local s = ns:GetServers();							
	for _, srv in ipairs (s) do							
		local toons = ns:GetToons(srv);					
		for _, toon in ipairs(toons) do					
			ret = ret .. "\n" .. srv .. "," .. toon;
			for _, item in ipairs (ReportItems) do		
				ret = ret .. "," .. (GoldCoffer.Servers[srv][toon][item] or "
			end;	
		end;		
	end; 			
	return ret;		
end;
local function ServerHistory()
	GoldCoffer.Reports["Server Data"] = GoldCoffer.Reports["Server Data"] or ns.dSrvOpt;
	local keyString	= strsplittable (",", GoldCoffer.Reports["Server Data"]);
	local pos = 1;
	local ReportItems = {};
	local ret = "Server"
	for i = 2, #ns.SrvOpt do
		if keyString[i] == "1" then
			tinsert(ReportItems, pos, ns.SrvOpt[i]);
			ret = ret .. "," .. ns.SrvOptV[i]			
			pos = pos + 1;
		end;
	end;
	local s = ns:GetServers();							
	for _, srv in pairs(s) do							
		local toons = ns:GetToons(srv);					
		local totals = {};								
		for i=1, #ReportItems do						
			totals[i] = 0;
		end;
		for _, toon in ipairs (toons) do					
			for index, item in ipairs(ReportItems) do	
				totals[index] = totals[index] + (GoldCoffer.Servers[srv][toon][item] or 0);
			end;
		end;		
		ret = ret .. "\n" .. srv;				
		for k, v in ipairs(totals) do
			ret = ret .. "," .. v
		end;
	end;			
	return ret;
end;
local function GuildData()
	GoldCoffer.Reports["Guild Data"] = GoldCoffer.Reports["Guild Data"] or ns.dGuildOpt;
	local keyString	= strsplittable (",", GoldCoffer.Reports["Guild Data"]);
	local pos = 1;
	local ReportItems = {};
	local ret = "Server,Guild"
	for i = 3, #ns.GuildOpt do
		if keyString[i] == "1" then
			tinsert(ReportItems, pos, ns.GuildOpt[i]);
			ret = ret .. "," .. ns.GuildOptV[i]			
			pos = pos + 1;
		end;
	end;
	local s = ns:GetGuildServers();							
	for _, srv in ipairs (s) do								
		local guilds = ns:GetGuilds(srv);					
		for _, guild in ipairs(guilds) do					
			ret = ret .. "\n" .. srv .. "," .. guild;
			for _, item in ipairs (ReportItems) do			
				ret = ret .. "," .. (GoldCoffer.Guilds[srv][guild][item] or 0);				
			end;	
		end;		
	end; 			
	return ret;		
end;
local function CurrenciesData()
	GoldCoffer.Reports["Currency Data"] = GoldCoffer.Reports["Currency Data"] or ns.dGuildOpt;
	local keyString	= strsplittable (",", GoldCoffer.Reports["Currency Data"]);
	local pos = 1;
	local ReportItems = {};
	local loc = GetLocale();
	for i = 1, #ns.GroupOrder do
		if keyString[i] == "1" then
			local s =  ns.GetGroupFromID( ns.GroupOrder[i], loc ) or i .. loc;
			tinsert( ReportItems, ns.GroupOrder[i] );
			pos = pos + 1;
		end;
	end;	
	local ret = "Section,Currency,Server,Name,Quantity\n";
	local toons = {};
	for i=1, #ReportItems  do
		for id, _ in pairs(GoldCofferCurrencies[ReportItems[i]]) do
			toons = ns.GetToonsWithCurrency(ReportItems[i], id)
			for _, t in ipairs(toons) do
				local srv, toon = strsplit("-", t);
				local q = GoldCofferCurrencies[ReportItems[i]][id][t]
				local sec = ns.GetGroupFromID ( ReportItems[i] );
				ret = ret .. sec .. "," .. C_CurrencyInfo.GetCurrencyInfo(id).name 
						.. "," .. srv .. "," .. toon .. "," .. q .. "\n";
			end;
		 end;	
	 end; 	
	return ret;
end
local function BuildCSVstring(cb)	
	local ret = "";					
	for i=1, #cb do						
		if cb[i]:GetChecked() then 		
			if i == 1 then
				ret = ret .. CharacterData() .. "\n\n";
			elseif i == 2 then
				ret = ret .. ServerHistory() .. "\n\n";
			elseif i == 3 then
				ret = ret .. GuildData() .. "\n\n";
			elseif i == 4 then
				ret = ret .. CurrenciesData() .. "\n\n";
			end;
		end;
	end;
	return ret;
end;
function ns:exportFrame ()
	if frame == nil then		
		iniReportTypes();
		frame = CreateFrame("Frame", nil, UIParent, "UIPanelDialogTemplate"); 
		frame:SetSize(380,265)
		frame:SetPoint("CENTER", UIParent,"CENTER");		
		frame.inp = CreateFrame("Frame", nil, frame, "InsetFrameTemplate");
		frame.inp:ClearAllPoints();
		frame.inp:SetPoint("TOPLEFT", frame, "TOPLEFT");
		frame.inp:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT");				
		local f = CreateFrame("Frame", nil, frame.inp, "InsetFrameTemplate");
		f:SetSize(200, 200);
		f:SetPoint("TOPLEFT", frame.inp, "TOPLEFT", 20, -40);
		local cb = SetCheckBoxes(f);	
		local bExport = CreateFrame("Button", nil, frame.inp, "GameMenuButtonTemplate");
		bExport:SetPoint("BOTTOMLEFT", f, "BOTTOMRIGHT", 20, 0)
		bExport:SetSize(120, 40);
		bExport:SetText("Export CSV");
		bExport:SetNormalFontObject("GameFontNormalLarge");
		bExport:SetHighlightFontObject("GameFontHighlightLarge");
		local sTemplate = "UIPanelScrollFrameTemplate";	
		if select(4, GetBuildInfo()) >= 100100 then sTemplate = "ScrollFrameTemplate"; end;
		frame.out = CreateFrame("ScrollFrame", nil, frame, sTemplate) 
		frame.out:Hide();
		frame.out:SetSize(320,100)
		frame.out:SetPoint("TOPLEFT",20, -80)
		local eb = CreateFrame("EditBox", nil, frame.out)
		eb:SetMultiLine(true)
		eb:SetFontObject(ChatFontNormal)
		eb:SetWidth(300)
		frame.out:SetScrollChild(eb)
		local s = frame.out:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
		s:ClearAllPoints();
		s:SetPoint("TOPLEFT", frame.out, "TOPLEFT", 10, 40)
		s:SetText("Press Ctrl + C")
		local bSelectAll = CreateFrame("Button", nil, frame.out, "GameMenuButtonTemplate");
		bSelectAll:SetPoint("BOTTOMLEFT", f, "BOTTOMRIGHT", 20, 0)
		bSelectAll:SetSize(120, 40);
		bSelectAll:SetText("Select All");
		bSelectAll:SetNormalFontObject("GameFontNormalLarge");
		bSelectAll:SetHighlightFontObject("GameFontHighlightLarge");
		bExport:SetScript("OnClick", function()
				frame.inp:Hide();				
				frame.out:Show();					
				local t = BuildCSVstring(cb);	
				eb:SetText(t)					
				eb:HighlightText();				
		end)
		bSelectAll:SetScript("OnClick", function() eb:HighlightText(); end)
		frame:SetScript("OnHide", function() ns.output:Show() end)
	else		
		frame:Show();				
		frame.inp:Show();
		frame.out:Hide();
	end;	
end;
