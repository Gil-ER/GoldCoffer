
local addon, ns = ...;


local color = 	{
				["red"] = "FF0000",
				["green"]  = "00FF00",
				["NotUsed"] = ""
			}

function ns:colorString(c, str)
	if c == nil then return; end;
	if str == nil then str = "nil"; end;
	return string.format("|cff%s%s|r", color[c], str);
end

local function padString(s, pad, lead, len)
-- pads string 's' with character 'pad' to 'len' characters in length
-- if lead is true characters are added before 's' otherwise they are added after
	local ret = s;
	if lead == nil then lead = false; end;
	while (strlen(ret) < len) do
		if lead then
			ret = pad .. ret;
		else
			ret = ret .. pad;
		end;
	end;
	return ret;
end;

function ns:GoldSilverCopper(copper)
	copper = tonumber(copper);
	if copper == nil then return 0; end;
	local neg = false;
	if copper < 0 then neg = true; copper = copper * -1; end;
	local gIcon = "|TInterface\\MoneyFrame\\UI-GoldIcon:0:0:2:0|t "
	local sIcon = "|TInterface\\MoneyFrame\\UI-SilverIcon:0:0:2:0|t "
	local cIcon = "|TInterface\\MoneyFrame\\UI-CopperIcon:0:0:2:0|t"

	local c = padString(copper % 100, "0", true, 2);
	local s = padString(floor(copper / 100) % 100, "0", true, 2);
	local g = floor(copper / 10000);
	local gt = "";
	while (g > 0) do
		local temp = g % 1000;		
		g = floor(g / 1000);
		if g > 0 then 
			temp = padString(temp, "0", true, 3);
			gt = "," .. temp .. gt;
		else
			gt = temp .. gt;
		end;
	end;
	if gt == "" then gt = "0"; end;
	if neg then gt = "-" .. gt; end;
	return strjoin("", gt, gIcon, s, sIcon, c, cIcon);
end

--		CREATE A FRAME
local frameFrameCount = 0;
function ns:createFrame(opts)
	frameFrameCount = frameFrameCount + 1;		--count each frame created
	if opts.name == nil or opts.name == "" then
		--Unique name generator, addonName + string + counterValue
		opts.name = addon .. "GeneratedFrameNumber" .. frameFrameCount;
	end;
	local f = CreateFrame("Frame", opts.name, opts.parent, "UIPanelDialogTemplate"); 
	f:SetSize(opts.width, opts.height);
	f:SetPoint(opts.anchor, opts.relFrame, opts.relPoint, opts.xOff, opts,yOff);
	if opts.title ~= nil then
		--Add the title if one was provided
		f.Title:SetJustifyH("CENTER");
		f.Title:SetText( opts.title );
	end;
	if opts.isMovable then
		--Make movable if flag set
		f:EnableMouse(true);
		f:SetMovable(true);
		f:SetUserPlaced(true); 
		f:RegisterForDrag("LeftButton");
		f:SetScript("OnDragStart", function(self) self:StartMoving() end);
		f:SetScript("OnDragStop", function(self) self:StopMovingOrSizing(); end);
	end;
	if opts.isResizable then
		--Make frame Resizable if flag was set
		f:SetResizable(true);
		f:SetScript("OnMouseDown", function()
			f:StartSizing("BOTTOMRIGHT")
		end);
		f:SetScript("OnMouseUp", function()
			f:StopMovingOrSizing()
		end);
		f:SetScript("OnSizeChanged", OnSizeChanged);
	end;
	f:Hide();
	return f;		--return the frame
end;--		CREATE A FRAME

--		CREATE A CHECKBOX
local cbFrameCount = 0;
function ns:createCheckBox(opts)	
	cbFrameCount = cbFrameCount + 1;		--count each frame created
	if opts.name == nil or opts.name == "" then
		--Unique name generator, addonName + string + counterValue
		opts.name = addon .. "GeneratedCheckboxNumber" .. cbFrameCount;
	end;
	local cb = CreateFrame("CheckButton", opts.name, opts.parent, "ChatConfigCheckButtonTemplate");
	cb:SetPoint(opts.anchor, opts.relFrame, opts.relPoint, opts.xOff, opts.yOff);
	cb:SetSize(32, 32);	
	local txt = opts.parent:CreateFontString(nil, "OVERLAY", "GameFontNormal");
	txt:SetPoint("BOTTOMLEFT", cb, "BOTTOMRIGHT", 5, 10);
	txt:SetText(opts.caption);	
	cb.tooltip = opts.ttip;	
	return cb, txt;
end;--		CREATE A CHECKBOX

--		CREATE A SCROLL FRAME
function ns:CreateScrollFrame (parent)
	local frameHolder;
	 
	-- create the frame that will hold all other frames/objects:
	local self = frameHolder or CreateFrame("Frame", nil, parent); -- re-size this to whatever size you wish your ScrollFrame to be, at this point
	self:ClearAllPoints();
	self:SetPoint("TOPLEFT", parent, "TOPLEFT", 10, -30);
	self:SetPoint("BOTTOMRIGHT", parent, "BOTTOMRIGHT", -10, 10);
	
	-- now create the template Scroll Frame (this frame must be given a name so that it can be looked up via the _G function (you'll see why later on in the code)
	self.scrollframe = self.scrollframe or CreateFrame("ScrollFrame", "ANewScrollFrame", self, "UIPanelScrollFrameTemplate");
	 
	-- create the standard frame which will eventually become the Scroll Frame's scrollchild
	-- importantly, each Scroll Frame can have only ONE scrollchild
	self.scrollchild = self.scrollchild or CreateFrame("Frame"); -- not sure what happens if you do, but to be safe, don't parent this yet (or do anything with it)
	 
	-- define the scrollframe's objects/elements:
	local scrollbarName = self.scrollframe:GetName()
	self.scrollbar = _G[scrollbarName.."ScrollBar"];
	self.scrollupbutton = _G[scrollbarName.."ScrollBarScrollUpButton"];
	self.scrolldownbutton = _G[scrollbarName.."ScrollBarScrollDownButton"];
	 
	-- all of these objects will need to be re-anchored (if not, they appear outside the frame and about 30 pixels too high)
	self.scrollupbutton:ClearAllPoints();
	self.scrollupbutton:SetPoint("TOPRIGHT", self.scrollframe, "TOPRIGHT", -2, -2);
	 
	self.scrolldownbutton:ClearAllPoints();
	self.scrolldownbutton:SetPoint("BOTTOMRIGHT", self.scrollframe, "BOTTOMRIGHT", -2, 2);
	 
	self.scrollbar:ClearAllPoints();
	self.scrollbar:SetPoint("TOP", self.scrollupbutton, "BOTTOM", 0, -2);
	self.scrollbar:SetPoint("BOTTOM", self.scrolldownbutton, "TOP", 0, 2);
	 
	-- now officially set the scrollchild as your Scroll Frame's scrollchild (this also parents self.scrollchild to self.scrollframe)
	-- IT IS IMPORTANT TO ENSURE THAT YOU SET THE SCROLLCHILD'S SIZE AFTER REGISTERING IT AS A SCROLLCHILD:
	self.scrollframe:SetScrollChild(self.scrollchild);
	 
	-- set self.scrollframe points to the first frame that you created (in this case, self)
	self.scrollframe:SetAllPoints(self);
	 
	-- now that SetScrollChild has been defined, you are safe to define your scrollchild's size.
	self.scrollchild:SetSize(self.scrollframe:GetWidth(), ( self.scrollframe:GetHeight() * 8 ));
	 
	return self.scrollchild;
end;--		CREATE A SCROLL FRAME



-- Add tabs to a frame
local TabedFrame;
--Tab Functions
local function Tab_OnClick (self)
	PanelTemplates_SetTab(self:GetParent(), self:GetID());
	local scrollChild = TabedFrame.ScrollFrame:GetScrollChild();
	if (scrollChild) then
		scrollChild:Hide();
	end;
	
	TabedFrame.ScrollFrame:SetScrollChild(self.content);
	self.content:Show();
end

function ns:SetTabs (frame, numTabs, ...)
	frame.numTabs = numTabs;
	
	TabedFrame = frame;
	local FrameName = frame:GetName();
	local contents = {};
	for i = 1, numTabs do
		local buttonTemplate = "CharacterFrameTabButtonTemplate";
		if select(4, GetBuildInfo()) >= 100000 then buttonTemplate = "PanelTabButtonTemplate"; end;
		local tab = CreateFrame("Button", FrameName.."Tab"..i, frame, buttonTemplate);
		tab:SetID(i);
		tab:SetText(select(i, ...));
		tab:SetScript("OnClick", Tab_OnClick);
		
		tab.content = CreateFrame("Frame", nil, frame.ScrollFrame);
		tab.content:SetSize(308, 5);
		tab.content:Hide();		
		
		table.insert(contents, tab.content);
		if i == 1 then
			tab:SetPoint("TOPLEFT", frame, "BOTTOMLEFT", 20, 7);
		else
			local no = i - 1;
			tab:SetPoint("TOPLEFT",_G[FrameName.."Tab"..(i - 1)], "TOPRIGHT")
		end;
	end;
	Tab_OnClick(_G[FrameName.."Tab1"]);
	
	return unpack(contents);
end;
-- /Add tabs to a frame

-- createButton
local buttonCount = 0;
function ns:createButton(opts)
	buttonCount = buttonCount + 1;		--Counts each button created
	if opts.name == nil or opts.name == "" then
		--Unique name generator, addonName + string + counterValue
		opts.name = addon .. "GeneratedFrameNumber" .. buttonCount;
	end;	
	local btn = CreateFrame("Button",  opts.name, opts.parent, "GameMenuButtonTemplate");
	--position, size and add title to the frame
	btn:SetSize(opts.width, opts.height);
	btn:SetText(opts.caption);
	btn:SetNormalFontObject("GameFontNormalLarge");
	btn:SetHighlightFontObject("GameFontHighlightLarge");
	btn:SetPoint(opts.anchor, opts.relFrame, opts.relPoint, opts.xOff, opts.yOff);
	--Add a tooltip if one was provided
	if (opts.ttip ~= nil) or (opts.ttip ~= "") then 
		btn:SetScript("OnEnter", function()
			GameTooltip:SetOwner(btn, "LEFT");
			GameTooltip:AddLine(opts.ttip);
			GameTooltip:Show();
		end);
		btn:SetScript("OnLeave", function() GameTooltip:Hide(); end);
	end;
	--Button function
	if opts.pressFunc ~= nil then 
		btn:SetScript("OnClick", function(self, button, down)
			opts.pressFunc(self, button)
		end)
	end;
	return btn;	
end;
-- \createButton
