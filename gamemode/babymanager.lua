
local playerWithBaby = nil
local storedWeapons = {}
local storedAmmo = {}

TimeToBabySwap = 30

function BabySwitchTimer(ply)
	SwitchBaby(ply)
	timer.Create( "BabySwitchTimer",TimeToBabySwap,0,function() 
		SwitchBaby(ply)
	end)

end

function SwitchBaby( ply )
	
	if(!IsRoundActive()) then return end
	if(!IsValid(GetSubmarine())) then return end
	
	local allPlayers = player.GetHumans()

	if(#allPlayers == 0) then return end
	
	if(IsValid(playerWithBaby) && #storedWeapons != 0) then
		--print("Stripping baby owner of baby")
		playerWithBaby:StripWeapons()
		local idx = 1
		for k,v in pairs(storedWeapons) do
			--print("Giving: " .. v)
			playerWithBaby:Give(v, true)
			local wep = playerWithBaby:GetWeapon(v)
			wep:SetClip1(storedAmmo[idx]) -- probably can use k here?
			--print("Ammo: " .. storedAmmo[idx])
			idx = idx + 1 -- kill me
		end
	end
	
	table.Empty(storedAmmo)
	table.Empty(storedWeapons)
	
	if(GetSubmarine():GetIsFlooded()) then return end
	
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
				local idx = 1
				for k,v in pairs(weps) do
					table.insert(storedWeapons, idx, v:GetClass())
					table.insert(storedAmmo, idx, v:Clip1())
					--print("Inserting: " .. v:GetClass() .. " with " .. v:Clip1() .. " ammo.")
					idx = idx + 1
				end
				randomply:StripWeapons()
				randomply:Give("weapon_vampiricbaby", false)
				randomply:SelectWeapon("weapon_vampiricbaby")
				hasGivenToNewPlayer = true
			end		
		end
	else
		local weps = playerWithBaby:GetWeapons()
		local idx = 1
		for k,v in pairs(weps) do
			table.insert(storedWeapons, idx, v:GetClass())
			table.insert(storedAmmo, idx, v:Clip1())
			--print("Inserting: " .. v:GetClass() .. " with " .. v:Clip1() .. " ammo.")
			idx = idx + 1
		end		
		playerWithBaby:StripWeapons()
		playerWithBaby:Give("weapon_vampiricbaby", false)
		playerWithBaby:SelectWeapon("weapon_vampiricbaby")
	end
	
	for k,ply in pairs(allPlayers) do
		if(playerWithBaby != nil) then
			ply:ChatPrint(playerWithBaby:GetName() .. " has Admiral Baby!")
		end
	end
end