
local addon, ns = ...
local icon = LibStub("LibDBIcon-1.0", true);
GoldCofferIcon = GoldCofferIcon or {};
local mmButtonShown = GoldCofferIcon.Visible or true;

ns.totalGold = 0;

local function minimapButtonShowHide(toggle)
	--if toggle is true just flip visibility.
	if toggle then mmButtonShown = not mmButtonShown; end;
	--if toggle is false adjust vivibility to saved ststus
	if toggle == false then
		if GoldCofferIcon.Visible == nil then  GoldCofferIcon.Visible = true; end;
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

--Mini map button stuff
local function GoldCofferMiniMap(button)
	if button == "LeftButton" then
		if IsShiftKeyDown() then
			minimapButtonShowHide(true)
		elseif IsControlKeyDown() then	
			--Placeholder
		else
			ns:ShowReport();
		end;
	elseif button == "RightButton" then
		--resets window position
		ns:CenterGoldReport();
	end;
end

local gcLDB = LibStub("LibDataBroker-1.1"):NewDataObject("GoldCofferMMButton", {
	type = "data source",
	text = "Gold Coffer",
	icon = "Interface\\Icons\\inv_misc_coin_17",
	OnClick = function(_, button) GoldCofferMiniMap(button) end,
})

function gcLDB:OnTooltipShow()
	self:AddLine("GoldCoffer");
	self:AddLine("\nLeft Click - Show Gold ");	
	self:AddLine("Right Click - Center Window     ");
	self:AddLine("<shift> Left Click - Hide this button.\n\n");	
	self:AddLine(ns.player .. " - " .. ns:GoldSilverCopper(GetMoney()));
	self:AddLine(ns.srv .. " - " .. ns:GetServerGold(ns.srv, true) .. "\n\n");
	
	self:AddLine("Todays profit/loss = " .. ns:GetTodaysChange());
	self:AddLine("Since yesterday = " .. ns:GetYesterdaysChange());
	self:AddLine("This week = " .. ns:GetWeeksChange() .. "\n\n");
	self:AddLine("Total gold(all servers) = " .. ns:GetTotalGold(true));
	
end
function gcLDB:OnEnter()
	GameTooltip:SetOwner(self, "ANCHOR_NONE");
	GameTooltip:SetPoint("TOPLEFT", self, "BOTTOMLEFT");
	GameTooltip:ClearLines();
	gcLDB:OnTooltipShow(GameTooltip);
	GameTooltip:Show();
end
function gcLDB:OnLeave()
	GameTooltip:Hide();
end
--/ Mini map button stuff

--Slash Commands
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
			arg2 = strlower(arg2);					--lowercase the string
			arg2 = arg2:gsub("^%l", string.upper);	--First character to uppercase (now matches WoW name convention)
			arg3 = strlower(arg3);					--lowercase the string
			arg3 = arg3:gsub("^%l", string.upper);	--First character to uppercase (now matches WoW name convention)			
			if GoldCoffer.Servers[arg3] == nil then
				print("Invalid server '" .. arg3 .. "'");
			else
				GoldCoffer.Servers[arg3][arg2] = nil;
				print(arg2 .. "-" .. arg3 .. "'s gold has been removed.\nIf this was an error logging into that toon will add then back.")
			end;
		else
			print ("Invalid input. You must enter a valid server and toon like this example.\n /gc delete Toon Server");
		end;
	elseif msg == "c" or msg == "center" or msg == "centre"	then		--including British spelling
		ns:CenterGoldReport();
	else
		print (arg1, arg2, arg3)
		local s = "/gc or /goldcoffer shows report.\n" 	
			.. "/gc delete Toon Server - Deletes a single toon.\n"
			.. "/gc mm or button - toggle minimap button (on/off)\n"
			.. "/gc c or center  - Center the report window.\n"
			.. "/gc t  - Print total gold.\n" 
			.. "/gc s  - Print server gold.\n" 
			.. "/gc ?  - Show help."		
		print (s);
	end;
end

--event frame
local f = CreateFrame("FRAME");
f:RegisterEvent("PLAYER_ENTERING_WORLD"); --PLAYER_ENTERING_WORLD
f:RegisterEvent("PLAYER_MONEY");

function f:OnEvent(event, ...)
	if event == "PLAYER_ENTERING_WORLD" then
		--Minimap button
		icon:Register(addon, gcLDB, GoldCofferIcon);
		minimapButtonShowHide(false);
		ns:updateGold();	--initialize data
		
		f:UnregisterEvent("PLAYER_ENTERING_WORLD");
	end;	
	if event == "PLAYER_MONEY" then
		ns:updateGold();	--update player gold
	end;
end;
f:SetScript("OnEvent", f.OnEvent); 

		
		
		




