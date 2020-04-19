include("shared.lua")
include("sounds.lua")

function GM:HUDPaint()

	local subFlooding = 1

	for k,v in pairs(ents.FindByClass("submarine")) do
		subFlooding = v:GetSubmarineFlooding()
	end

	local vPos = ScrW()-450
	local hPos = 50
	
	local width = 350 
	local totalWidth = width * (subFlooding / 1000 )
	local height = 50

	draw.RoundedBox(10, vPos,hPos, width, height, Color(0,50,255, 150))
	draw.RoundedBox(10, vPos,hPos, totalWidth, height, Color(0,50,255, 255))	
	
	draw.SimpleText("Submarine Flooding " .. subFlooding-1 .. "/" .. 1000, "HudHintTextLarge", vPos + 10, hPos + 3, Color(255,255,255,255), 0, 0)

end