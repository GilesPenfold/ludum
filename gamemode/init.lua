AddCSLuaFile("shared.lua")
AddCSLuaFile("cl_init.lua")
AddCSLuaFile("teamsetup.lua")
AddCSLuaFile("sounds.lua")
AddCSLuaFile("babymanager.lua")
AddCSLuaFile("roundsystem.lua")
AddCSLuaFile("custom_classes.lua")

resource.AddFile("gamemodes/ludum/content/sound/weapons/baby/baby.wav")

include("shared.lua")
include("teamsetup.lua")
include("sounds.lua")
include("babymanager.lua")
include("custom_classes.lua")
include("roundsystem.lua")
include("ZombieSpawner.lua")

util.AddNetworkString( "PlayerSpawn" )

submarine = nil

function StartGame()
	SpawnTimer()
	BabySwitchTimer(ply)
	SpawnSubmarineEntity()
	Interactions()
end

function GM:PlayerInitialSpawn( ply )
	ply:SetupTeam(0)
	ply:SetNewClass(1)
end

function GM:PlayerSpawn( ply )	
	if(IsRoundActive()) then
		if(ply:GetLoadoutName() == "Engineer") then
			ply:ChatPrint("You are an " .. ply:GetLoadoutName() .. "!" )
			ply:ChatPrint("Find repair points around the map and repair them with your crowbar.","(Press E to interact whilst holding the crowbar). "  )
		elseif(ply:GetLoadoutName() == "Soldier") then
			ply:ChatPrint("You are a ".. ply:GetLoadoutName() .. "!" )
			ply:ChatPrint("You are this submarines last bastion of hope against the zombies. Use your shotgun to kill zombies and protect the Engineers."  )
		end
		print ( "Player: " .. ply:Nick() .. " has spawned as an " .. ply:GetLoadoutName() )
	else
		StartRound()
	end
end

function GM:PlayerDeath(ply)
	if(IsRoundActive()) then
		timer.Create("spawntimer", 10, 1, function()
			ply:Spawn()
		end)
	else
		timer.Create("spawntimer", 2, 1, function()
			ply:Spawn()
		end)
	end
end


-- Choose the model for hands according to their player model.
function GM:PlayerSetHandsModel( ply, ent )

	local simplemodel = player_manager.TranslateToPlayerModelName( ply:GetModel() )
	local info = player_manager.TranslatePlayerHands( simplemodel )
	if ( info ) then
		ent:SetModel( info.model )
		ent:SetSkin( info.skin )
		ent:SetBodyGroups( info.body )
	end

end

function Interactions()

	entityTable = ents.FindByClass( "logic_timer" )
	
	for k,v in pairs(entityTable) do	
		if k == 1 then
			local AmmoCrate = ents.Create("ammo_crate")
			AmmoCrate:SetPos(v:GetPos())
			AmmoCrate:SetAngles(Angle(0,90,0))
			AmmoCrate:Spawn()
		elseif (k > 1) && (k < #entityTable) then
			local RepairPoint = ents.Create("repair_point")
			RepairPoint:SetPos(v:GetPos())
			RepairPoint:SetAngles(Angle(0,90,0))
			RepairPoint:Spawn()
		end
	end
end

function SpawnSubmarineEntity()
    submarine = ents.Create("submarine")
    submarine:SetPos(Vector( 0,0,-1000 ))
    submarine:Spawn()
	print("Submarine Spawned with health " .. submarine:Health())
end

function GetSubmarine()
	return submarine
end

