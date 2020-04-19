roundActive = false

function StartRound()
	local alive = 0
	for k,v in pairs(player.GetAll()) do
		if(v:Alive()) then
		alive = alive + 1
		end
	end
	
	if(alive >= #player.GetAll() && #player.GetAll() >= 1) then
		roundActive = true
		roundTimer = 300
		StartGame()
		for k,ply in pairs(player.GetAll()) do
			ply:ChatPrint("The submarine is sinking, the Admiral has been turned into a baby, and zombies are climbing in! What a terrible day!")
			ply:ChatPrint("Keep Admiral Baby alive whilst repairing the submarine and defending yourselves from the zombies.")
		end
	end
	print("Round Started: " .. tostring(roundActive))
	EndRoundCheck() -- Might not be necessary
end


function EndRoundCheck()
	
	if(!roundActive) then return end
	if(!IsValid(GetAdmiralBaby())) then return end
	
	if( !timer.Exists( "delayTimer" ) ) then
		timer.Create("delayTimer", 1, 1, function()
			print("Timer tick")
			if(!IsValid(GetAdmiralBaby())) then return end
			if(GetAdmiralBaby():IsDead()) then
				EndRound(false) -- failure
			end
			roundTimer = roundTimer - 1
			
			if(roundTimer == 0) then
				EndRound(true) -- victory
			end
		end)
	end

end


function EndRound(victory)
	if( !timer.Exists( "cleanupTimer" ) ) then
		for k, ply in pairs(player.GetAll()) do
			if(victory) then
				ply:ChatPrint("You have kept Admiral Baby alive and saved the submarine from peril!")
			else
				ply:ChatPrint("You have failed to keep Admiral Baby alive. The submarine floods and all hope is lost.")
			end
		end
		
		timer.Create("cleanupTimer", 3, 1, function()
			print("Cleanup")
			game.CleanUpMap(false, {})
			for k, ply in pairs(player.GetAll()) do
				if(ply:Alive()) then
					ply:SetupHands()
					ply:StripWeapons()
					ply:KillSilent()
				end
				ply:SetupTeam(ply:Team())
			end
			if(IsValid(GetAdmiralBaby())) then
				GetAdmiralBaby():Remove()
			end
			roundActive = false
		end)
	end
end

function IsRoundActive()
	return roundActive
end

function GM:Think()
	EndRoundCheck()
end
