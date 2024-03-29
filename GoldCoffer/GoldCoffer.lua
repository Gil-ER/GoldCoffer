-- Edited Feb 23, 2024

local addon, ns = ...
local icon = LibStub("LibDBIcon-1.0", true);
GoldCofferIcon = GoldCofferIcon or {};
local mmButtonShown = GoldCofferIcon.Visible or true;
ns.totalGold = 0;
local function fillInfoTooltip(tip)
	tip:AddLine(ns:colorString("white", "GoldCoffer"));
	tip:AddLine("\n" .. "Left Click - Show Gold ");	
	tip:AddLine("Right Click - Center Window     ");
	tip:AddLine("<shift> Left Click - Toggle Minimap button." .. "\n\n");	
	tip:AddLine(ns.player .. " - " .. ns:GoldSilverCopper(GetMoney()));
	tip:AddLine(ns.srv .. " - " .. ns:GetServerGold(ns.srv, true) .. "\n\n");
	tip:AddLine("Profit/loss this session = " .. ns:GetSessionChange());
	tip:AddLine("Gold/Hour = " .. ns:GetGPH() .. "\n\n");
	tip:AddLine("Today = " .. ns:GetYesterdaysChange());
	tip:AddLine("This Week = " .. ns:GetWeeksChange());
	tip:AddLine("This Month = " .. ns:GetMonthsChange());
	tip:AddLine("This Year = " .. ns:GetYearsChange() .. "\n\n");	
	tip:AddLine("Total Gold Yesterday = " .. ns:GetYesterdaysGold(true));
	tip:AddLine("Last Week = " .. ns:GetLastWeeksGold(true));
	tip:AddLine("Last Month = " .. ns:GetLastMonthsGold(true));
	tip:AddLine("Last Year = " .. ns:GetLastYearsGold(true));
	tip:AddLine("\n" .. "Total gold(all servers) = " .. ns:GetTotalGold(true));
end;
local function minimapButtonShowHide(toggle)
	if not icon then return; end;
	if toggle then mmButtonShown = not mmButtonShown; end;
	if toggle == false then
		if GoldCofferIcon.Visible == nil then GoldCofferIcon.Visible = true; end;
		mmButtonShown = GoldCofferIcon.Visible;
	end;
	if mmButtonShown then
		icon:Show(addon);
	else
		icon:Hide(addon);
		if toggle then print("Minimap button is now hidden.\nType '/gc mm' to show it again."); end;
	end;
	GoldCofferIcon.Visible = mmButtonShown;
end;
local function GoldCofferMiniMap(button)
	if not icon then return; end;
	if button == "LeftButton" then
		if IsShiftKeyDown() then
			minimapButtonShowHide(true)
		elseif IsControlKeyDown() then	
		else
			ns:ShowReport();
		end;
	elseif button == "RightButton" then
		ns:CenterReport()
	end;
end
local iconFile = "Interface\\Icons\\inv_misc_coin_17"
if select(4, GetBuildInfo()) < 40000 then iconFile = "Interface\\Icons\\inv_misc_coin_01"; end;
local gcLDB = LibStub("LibDataBroker-1.1"):NewDataObject("GoldCofferMMButton", {
	type = "data source",
	text = "Gold Coffer",
	icon = iconFile,
	OnClick = function(_, button) GoldCofferMiniMap(button) end,
})
function gcLDB:OnTooltipShow()
	fillInfoTooltip(self);	
end
function gcLDB:OnEnter()	
	ns:updateGold();
	GameTooltip:SetOwner(self, "ANCHOR_NONE");
	GameTooltip:SetPoint("TOPLEFT", self, "BOTTOMLEFT");
	GameTooltip:ClearLines();
	gcLDB:OnTooltipShow(GameTooltip);
	GameTooltip:Show();
end
function gcLDB:OnLeave()
	GameTooltip:Hide();
end
function GoldCoffer_OnAddonCompartmentClick(_, button)
	GoldCofferMiniMap(button);
end;
function GoldCoffer_OnAddonCompartmentEnter()
	GameTooltip:SetOwner(UIParent, "ANCHOR_NONE");
	GameTooltip:SetPoint("CENTER", UIParent, "CENTER");
	GameTooltip:ClearLines();	
	fillInfoTooltip(GameTooltip);
	GameTooltip:Show();
end;
function GoldCoffer_OnAddonCompartmentLeave()
	GameTooltip:Hide();
end;
if select(4, GetBuildInfo()) > 100000 then
	AddonCompartmentFrame:RegisterAddon({
		text = "Gold Coffer",
		icon = "Interface\\Icons\\inv_misc_coin_01",
		notCheckable = true,
		registerForAnyClick = true,
		func = function(btn, arg1, arg2, checked, mouseButton)
			if mouseButton == "LeftButton" then
				if IsShiftKeyDown() then minimapButtonShowHide(true); else ns:ShowReport(); end;
			elseif mouseButton == "RightButton" then			
				ns:CenterReport();
			end;
		end,
		funcOnEnter = function()
			GameTooltip:SetOwner(AddonCompartmentFrame, "ANCHOR_TOPRIGHT");
			fillInfoTooltip(GameTooltip);
			GameTooltip:Show();
		end,
		funcOnLeave = function()
			GameTooltip:Hide();
		end,
	})
end;
SLASH_GOLDCOFFER1 = "/goldcoffer";
SLASH_GOLDCOFFER2 = "/gc";
SlashCmdList.GOLDCOFFER = function(arg)
	local arg1, arg2, arg3, arg4 = strsplit(" ", arg);
	msg = strlower(arg1);
	if msg == "" then	
		ns:ShowReport();
	elseif msg == "mm" or msg == "button" then
		minimapButtonShowHide(true);
		if mmButtonShown then
			icon:Show(addon);
		else
			icon:Hide(addon);
		end;
	elseif msg == "t" then
		print("Total gold ", ns:GetTotalGold(true));
	elseif msg == "s" then
		print("Server gold ", ns:GetServerGold(ns.srv, true));
	elseif msg == "delete" then
		if ((arg2 or "") > "") and ((arg3 or "") > "") then
			arg2 = strlower(arg2);					
			arg2 = arg2:gsub("^%l", string.upper);	
			arg3 = strlower(arg3);					
			arg3 = arg3:gsub("^%l", string.upper);	
			if GoldCoffer.Servers[arg3] == nil then
				print("Invalid server '" .. arg3 .. "'");
			else
				GoldCoffer.Servers[arg3][arg2] = nil;
				print(arg2 .. "-" .. arg3 .. "'s gold has been removed.\nIf this was an error logging into that toon will add then back.")
			end;
		else
			print ("Invalid input. You must enter a valid server and toon like this example.\n /gc delete Toon Server");
		end;
	elseif msg == "c" or msg == "center" or msg == "centre"	then		
		ns:CenterReport();
	else
		local s = "/gc or /goldcoffer shows report.\n" 	
			.. "/gc delete Toon Server - Deletes a single toon.\n"
			.. "/gc mm or button - toggle minimap button (on/off)\n"
			.. "/gc c or center  - Center the report window.\n"
			.. "/gc t  - Print total gold.\n" 
			.. "/gc s  - Print server gold.\n" 
			.. "/gc ?  - Show help."		
		print (s);
	end;
end; 
local f = CreateFrame("FRAME");
f:RegisterEvent("SPELLS_CHANGED"); 
f:RegisterEvent("PLAYER_MONEY");
f:RegisterEvent("PLAYER_LOGOUT");
if select(4, GetBuildInfo()) < 30000 then 
	f:RegisterEvent("BANKFRAME_OPENED");
	f:RegisterEvent("BANKFRAME_CLOSED");
else
	f:RegisterEvent("PLAYER_INTERACTION_MANAGER_FRAME_SHOW");
	f:RegisterEvent("PLAYER_INTERACTION_MANAGER_FRAME_HIDE");
end;
function f:OnEvent(event, arg1)
	if event == "SPELLS_CHANGED" then
		GoldCofferIcon = GoldCofferIcon or {};
		if icon then icon:Register(addon, gcLDB, GoldCofferIcon); end;
		minimapButtonShowHide(false);
		ns:iniData();	
		GoldCoffer.History.Today = ns:GetTotalGold(false);
		tinsert(UISpecialFrames, "gcReportFrame");	
		tinsert(UISpecialFrames, "GoldCofferOutputFrame");	
		f:UnregisterEvent("SPELLS_CHANGED");
		ns.LoginTime = time();
	end;	
	if event == "PLAYER_MONEY" then
		ns:updateGold();	
	end;
	if event == "PLAYER_LOGOUT" then
		ns.UpdateCurrency();	
	end;	
	if (event == "PLAYER_INTERACTION_MANAGER_FRAME_SHOW" and arg1 == 10)
				or (event == "BANKFRAME_OPENED") then	
		local gold = GetGuildBankMoney("player");			
		local guild, _, _, server = GetGuildInfo("player");	
		if guild then
			server = server or ns.srv;
			server = server:gsub("%s+", "");
			GoldCoffer = GoldCoffer or {};
			GoldCoffer.Guilds = GoldCoffer.Guilds or {};
			GoldCoffer.Guilds[server] = GoldCoffer.Guilds[server] or {};
			GoldCoffer.Guilds[server][guild] = GoldCoffer.Guilds[server][guild] or {};
			if GoldCoffer.Guilds[server][guild].Current == nil then
				ns:newGuild(server, guild, gold);
			else
				GoldCoffer.Guilds[server][guild].Current = gold;		
				GoldCoffer.Guilds[server][guild].LastUpdate = date("%m/%d/%y");
				GoldCoffer.Guilds[server][guild].UpdateTime = time();
			end;	
		end;
	end;
	if (event == "PLAYER_INTERACTION_MANAGER_FRAME_HIDE" and arg1 == 10) 
				or (event == "BANKFRAME_CLOSED") then
		local gold = GetGuildBankMoney("player");			
		local guild, _, _, server = GetGuildInfo("player");			
		if guild then
			server = server or ns.srv;
			server = server:gsub("%s+", "");
			GoldCoffer.Guilds[server][guild].Current = GetGuildBankMoney("player");	
			GoldCoffer.Guilds[server][guild].UpdateTime = time();		
			GoldCoffer.Guilds[server][guild].LastUpdate = date("%m/%d/%y");
		end;
	end;
end;
f:SetScript("OnEvent", f.OnEvent); 
