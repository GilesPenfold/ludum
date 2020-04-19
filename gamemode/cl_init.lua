include("shared.lua")
include("sounds.lua")

local g_station = nil
local g_alarm = nil

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
