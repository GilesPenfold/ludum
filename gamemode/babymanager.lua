
local playerWithBaby = nil
local storedWeapons = {}


function BabySwitchTimer(ply)
    if( !timer.Exists( "BabySwitchTimer" ) ) then
        timer.Create( "BabySwitchTimer",5,0,function() 
            SwitchBaby(ply)
        end)
    end
end

function SwitchBaby( ply )
	
	local allPlayers = player.GetHumans()
	
	print("Number of Players:" .. #allPlayers)
	
	if(#allPlayers == 0) then return end
	
	print("Number of stored weapons:" .. #storedWeapons)
	
	if(#storedWeapons > 0) then
		for k,v in pairs( storedWeapons ) do 
					--PrintTable(storedWeapons)
			print("Stored Weapon: " .. v)
		end
	end
	
	if(playerWithBaby != nil && #storedWeapons != 0) then
		print("Stripping baby owner of baby")
		playerWithBaby:StripWeapons()
		for k,v in pairs(storedWeapons) do
			print("Giving: " .. v)
			playerWithBaby:Give(v, false)
		end
	end
	
	table.Empty(storedWeapons)
	
	if(#allPlayers == 1) then 
		playerWithBaby = allPlayers[1]
	end

	
	if(#allPlayers > 1) then
		local hasGivenToNewPlayer = false
		while !hasGivenToNewPlayer do
			local randomply = table.Random(allPlayers)
			
			if(randomply != playerWithBaby) then
				playerWithBaby = randomply
				local weps = randomply:GetWeapons()
				for k,v in pairs(weps) do
					table.insert(storedWeapons, v:GetClass())
					print("Inserting: " .. v:GetClass())
				end
				randomply:StripWeapons()
				randomply:Give("weapon_vampiricbaby", false)
				randomply:SelectWeapon("weapon_vampiricbaby")
				hasGivenToNewPlayer = true
			end		
		end
	else
		local weps = playerWithBaby:GetWeapons()
		for k,v in pairs(weps) do
			table.insert(storedWeapons, v:GetClass())
			print("Inserting: " .. v:GetClass())
		end		
		playerWithBaby:StripWeapons()
		playerWithBaby:Give("weapon_vampiricbaby", false)
		playerWithBaby:SelectWeapon("weapon_vampiricbaby")
	end
	
	print( "BabySpawnTimer: Switching baby to " .. playerWithBaby:GetName() )
	ply:ChatPrint(playerWithBaby:GetName() .. " has Admiral Baby!")
end