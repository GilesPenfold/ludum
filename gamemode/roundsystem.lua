roundActive = false
roundTimer = 600

function StartRound()
	local alive = 0
	for k,v in pairs(player.GetAll()) do
		if(v:Alive()) then
			alive = alive + 1
		end
	end
	
	if(alive >= #player.GetAll() && #player.GetAll() >= 1) then
		for k,ply in pairs(player.GetAll()) do
			ply:ChatPrint("You find yourself stranded in the middle of the Pacific Ocean, upon the sinking submarine Ludum. The Admiral has been turned into a baby, and zombies are trying to consume your squishy brains! What a terrible day!")
			ply:ChatPrint("Round begins in 15 seconds.")
		end
		
		if( !timer.Exists( "RoundStartTimer" ) ) then
			timer.Create( "RoundStartTimer",15,1,function() 
				roundActive = true
				roundTimer = 600
				
				local soldierIndex = math.random(1,#player.GetAll())
				local currentIndex = 1
				
				for k,ply in pairs(player.GetAll()) do
					ply:KillSilent()
					local class = 2
					if(soldierIndex == currentIndex) then
						class = 3
					end
					ply:SetNewClass(class)
					ply:Spawn()
					ply:SetupForNewRound( )
				end
				StartGame()
				
				for k,ply in pairs(player.GetAll()) do
					ply:ChatPrint("You have 10 minutes to survive.")
				end
			end)
		end
	else
		if( !timer.Exists( "RoundWarmupTimer" ) ) then
			timer.Create( "RoundWarmupTimer",15,1,function() 
				for k,ply in pairs(player.GetAll()) do
					ply:ChatPrint("Not enough players to begin round. Need at least 2 players to begin. Currently, we have " .. #player.GetHumans() .. " active players online.")
				end
			end)
		end
		
	end
	print("Round Started: " .. tostring(roundActive))
	EndRoundCheck() -- Might not be necessary
end


function EndRoundCheck()
	
	if(!roundActive) then return end
	if(!IsValid(GetSubmarine())) then return end
	
	if( !timer.Exists( "delayTimer" ) ) then
		timer.Create("delayTimer", 1, 1, function()
			if(!IsValid(GetSubmarine())) then return end
			
			if(#player.GetHumans() == 0) then
				EndRound(false) -- failure
			end
			
			if(GetSubmarine():GetIsFlooded()) then
				EndRound(false) -- failure
			end
			
			if(GetAdmiral():GetAdmiralHealth() <= 0) then
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
			StopGame()
			game.CleanUpMap(false, {})
			for k, ply in pairs(player.GetAll()) do
				if(ply:Alive()) then
					ply:SetupHands()
					ply:StripWeapons()
					ply:KillSilent()
				end
				ply:SetupTeam(ply:Team())
			end
			if(IsValid(GetSubmarine())) then
				GetSubmarine():ResetSubmarine()
			end
			if(IsValid(GetAdmiral())) then
				GetSubmarine():ResetSubmarine()
			end
			ResetSubmarineManager()
			roundActive = false
		end)
	end
end

function IsRoundActive()
	return roundActive
end

