-- Edited Aug 09, 2023

local addon, ns = ...
local optToon, optServer, optGuild, optCurrency;
local function CreateCB (section, caps, parent)
	local cb = {};			
	local x = 10;
	local y = -10;
	for i = 1, #caps do			
		local opt = ""
		idx = i;
		cb[i] = CreateFrame("CheckButton", "GoldCoffer" .. section .. i, parent, "ChatConfigCheckButtonTemplate");
		cb[i]:SetSize(32, 32);
		getglobal(cb[i]:GetName() .. 'Text'):SetText(caps[i]);
		cb[i]:SetPoint("TOPLEFT", x, y);
		cb[i]:SetScript("OnClick", function (self)	
			if section == "optToon" then
				if i < 3 then 
					cb[i]:SetChecked(true); 	
				else
					opt = "1,1";
					for j = 3, #caps do			
						if cb[j]:GetChecked() then opt = opt .. ",1" else opt = opt .. ",0"; end;
					end;
					GoldCoffer.Reports["Character Data"] = opt;	
				end;
			end;
			if section == "optServer" then
				if i == 1 then 
					cb[i]:SetChecked(true); 
				else
					opt = "1";
					for j = 2, #caps do
						if cb[j]:GetChecked() then opt = opt .. ",1" else opt = opt .. ",0"; end;
					end;
					GoldCoffer.Reports["Server Data"] = opt;					
				end;
			end;
			if section == "optGuild" then
				if i < 3 then 
					cb[i]:SetChecked(true); 
				else
					opt = "1,1";
					for j = 3, #caps do
						if cb[j]:GetChecked() then opt = opt .. ",1" else opt = opt .. ",0"; end;
					end;
					GoldCoffer.Reports["Guild Data"] = opt;					
				end;
			end;
			if section == "optCurrency" then
				if cb[1]:GetChecked() then opt = "1" else opt = "0"; end;
				for j = 2, #caps do
					if cb[j]:GetChecked() then opt = opt .. ",1" else opt = opt .. ",0"; end;
				end;
				GoldCoffer.Reports["Currency Data"] = opt;	
			end;
		end)
		if x > 400 then
			x = 10;
			y = y - 30;		
		else
			x = x + 200;	
		end;
	end;
	return cb;	
end;
local function SetOptions(group, cb)
	if GoldCoffer == nil then return; end;
	if GoldCoffer.Reports == nil then return; end;
	GoldCoffer.Reports["Character Data"] = GoldCoffer.Reports["Character Data"] or ns.dCharOpt;
	local keyString	= strsplittable (",", GoldCoffer.Reports["Character Data"]);
	if group == "Toon" then
		for i = 1, #ns.CharOpt do			
			cb[i]:SetChecked(keyString[i] == "1");	
		end;
	end;
	GoldCoffer.Reports["Server Data"] = GoldCoffer.Reports["Server Data"] or ns.dSrvOpt
	keyString	= strsplittable (",", GoldCoffer.Reports["Server Data"]);
	if group == "Server" then
		for i = 1, #ns.SrvOpt do
			cb[i]:SetChecked(keyString[i] == "1");	
		end;
	end;
	GoldCoffer.Reports["Guild Data"] = GoldCoffer.Reports["Guild Data"] or ns.dGuildOpt
	keyString	= strsplittable (",", GoldCoffer.Reports["Guild Data"]);
	if group == "Guild" then
		for i = 1, #ns.GuildOpt do
			cb[i]:SetChecked(keyString[i] == "1");	
		end;
	end;	
	GoldCoffer.Reports["Currency Data"] = GoldCoffer.Reports["Currency Data"] or ns.dGuildOpt
	keyString	= strsplittable (",", GoldCoffer.Reports["Currency Data"]);
	if group == "Currency" then
		for i = 1, #ns.GuildOpt do
			cb[i]:SetChecked(keyString[i] == "1");	
		end;
	end;
end;
function ns:OptionsFrame(parent)
	if optToon == nil then
		local w = parent:GetWidth()-20;
		optToon = CreateFrame("Frame", nil, parent, "InsetFrameTemplate");
		optToon:SetSize(w, 168);
		optToon:SetPoint("TOPLEFT", parent, "TOPLEFT", 10, -25);
		local h1 = parent:CreateFontString(nil, "OVERLAY", "GameFontWhite");
		h1:SetText("Character Export Options");
		h1:SetPoint("BOTTOMLEFT", optToon, "TOPLEFT", 0, 5);
		optToon.cb = CreateCB("optToon", ns.CharOptV, optToon);
		SetOptions("Toon", optToon.cb);
		optServer = CreateFrame("Frame", nil, parent, "InsetFrameTemplate");
		optServer:SetSize(parent:GetWidth()-20, 138);
		optServer:SetPoint("TOPLEFT", optToon, "BOTTOMLEFT", 0, -35);
		local h2 = parent:CreateFontString(nil, "OVERLAY", "GameFontWhite");
		h2:SetText("Server Export Options");
		h2:SetPoint("BOTTOMLEFT", optServer, "TOPLEFT", 0, 5);
		optServer.cb = CreateCB("optServer", ns.SrvOptV, optServer);
		SetOptions("Server", optServer.cb);
		optGuild = CreateFrame("Frame", nil, parent, "InsetFrameTemplate");
		optGuild:SetSize(w, 138);
		optGuild:SetPoint("TOPLEFT", optServer, "BOTTOMLEFT", 0, -35);
		local h3 = parent:CreateFontString(nil, "OVERLAY", "GameFontWhite");
		h3:SetText("Guild Export Options");
		h3:SetPoint("BOTTOMLEFT", optGuild, "TOPLEFT", 0, 5);
		optGuild.cb = CreateCB("optGuild", ns.GuildOptV, optGuild);
		SetOptions("Guild", optGuild.cb);
		optCurrency = CreateFrame("Frame", nil, parent, "InsetFrameTemplate");
		optCurrency:SetSize(w, 138);
		optCurrency:SetPoint("TOPLEFT", optGuild, "BOTTOMLEFT", 0, -35);		
		local h4 = parent:CreateFontString(nil, "OVERLAY", "GameFontWhite");
		h4:SetText("Other Currency Export Options");
		h4:SetPoint("BOTTOMLEFT", optCurrency, "TOPLEFT", 0, 5);
		optCurrency.cb = CreateCB("optCurrency", ns:GetOrderedGroupsList(), optCurrency);	
		SetOptions("Currency", optCurrency.cb);
	end;
end;
