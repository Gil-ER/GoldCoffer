-- Edited Aug 09, 2023

local addon, ns = ...;
local color = 	{
				["red"] = "FF0000",
				["green"]  = "00FF00",
				["white"] = "FFFFFF",
				["blue"] = "0000FF",
				["yellow"] = "FFFF00"
			}
function ns:colorString(c, str)
	if c == nil then return; end;
	if str == nil then str = "nil"; end;
	return string.format("|cff%s%s|r", color[c], str);
end
function ns:GoldSilverCopper(copper, textureFlag)
	if not textureFlag then textureFlag = true; end;
	local gIcon, sIcon, cIcon = "g", "s", "c";
	if textureFlag == true then 
		gIcon = "|TInterface\\MoneyFrame\\UI-GoldIcon:0:0:2:0|t "
		sIcon = "|TInterface\\MoneyFrame\\UI-SilverIcon:0:0:2:0|t "
		cIcon = "|TInterface\\MoneyFrame\\UI-CopperIcon:0:0:2:0|t"
	end	
	copper = tonumber(copper);
	local c = format("%02d", (copper % 100)) .. cIcon;
	local s = format("%02d", (floor(copper / 100) % 100)) .. sIcon;
	local g = floor(copper / 10000);
	local gt = "";
	local neg = false;
	if g == 0 then gt = "0"; end;
	if g < 0 then neg = true; g = g * -1; end;
	while (g > 1000) do	
		gt = "," .. format("%03d", (g % 1000));
		g = floor(g / 1000);
	end;
	gt = g .. gt;
	if neg then gt = "-" .. gt; end;
	return strjoin("", gt, gIcon , s, c);
end;
