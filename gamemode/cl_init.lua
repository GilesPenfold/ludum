include("shared.lua")
include("sounds.lua")

local g_station = nil
local g_alarm = nil
local wave = Material( "pp/blury", "noclamp smooth" )

function GM:HUDPaint()

	local subFlooding = 1
	local waterLevel = Vector(0,0,-1000)

	for k,v in pairs(ents.FindByClass("submarine")) do
		subFlooding = v:GetSubmarineFlooding()
		waterLevel = v:GetWaterLevel()
	end
	
	print(waterLevel.z)
	print(LocalPlayer():GetPos().z)
	
	if((LocalPlayer():GetPos().z - 310) < waterLevel.z) then
		
		surface.SetMaterial( wave )
		surface.SetDrawColor( 30, 30, 51, 255 )
		surface.DrawTexturedRect( 0, 0, ScrW(), ScrH() )
		draw.RoundedBox(0, 0,0, ScrW(), ScrH(), Color(30,30,51, 240))
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


net.Receive( "music", function( ply )
		sound.PlayURL ( "http://www.gilespenfold.com/Ludum/sickbeat1.wav", "", function( station ) -- royalty free asset
		if(IsValid(g_station)) then
			g_station:Stop()
		end
		
		if ( IsValid( station ) ) then
			station:Play()

			-- Keep a reference to the audio object, so it doesn't get garbage collected which will stop the sound
			g_station = station
		
			end
		end )
end)

net.Receive( "musicstop", function( ply )
		
			if(IsValid(g_station)) then
				g_station:Stop()
			end
end )



net.Receive( "alarm", function( ply )
		sound.PlayURL ( "http://www.gilespenfold.com/Ludum/alarm2.mp3", "", function( alarm ) -- royalty free asset
		if(IsValid(g_alarm)) then
			g_alarm:Stop()
		end
		
		if ( IsValid( alarm ) ) then
			alarm:Play()

			-- Keep a reference to the audio object, so it doesn't get garbage collected which will stop the sound
			g_alarm = alarm
		
			end
		end )
end)

net.Receive( "alarmstop", function( ply )
		
			if(IsValid(g_alarm)) then
				g_alarm:Stop()
			end
end )
