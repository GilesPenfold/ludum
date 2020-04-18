include("shared.lua")
include("sounds.lua")

hook.Add("HUDPaint","HUDIndent", function()

	local vPos = ScrW()-300
	local hPos = 100
	
	local width = 250
	local height = 30
	
	draw.RoundedBox(10, vPos,hPos, width, height, Color(0,20,255, 150))
	draw.RoundedBox(10, vPos,hPos, width, height, Color(0,20,255, 255))
	
	draw.SimpleText("Submarine Flooding", "Default", vPos + 10, hPos + 3, Color(255,255,255,255), 0, 0)

end)