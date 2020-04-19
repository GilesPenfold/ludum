AddCSLuaFile("shared.lua")
AddCSLuaFile("cl_init.lua")
AddCSLuaFile("teamsetup.lua")
AddCSLuaFile("sounds.lua")
AddCSLuaFile("babymanager.lua")
AddCSLuaFile("submarinemanager.lua")
AddCSLuaFile("roundsystem.lua")
AddCSLuaFile("custom_classes.lua")

resource.AddFile("gamemodes/ludum/content/sound/weapons/baby/baby.wav")

include("shared.lua")
include("teamsetup.lua")
include("sounds.lua")
include("babymanager.lua")
include("submarinemanager.lua")
include("custom_classes.lua")
include("roundsystem.lua")
include("ZombieSpawner.lua")

util.AddNetworkString( "music" )
util.AddNetworkString( "alarm" )

util.AddNetworkString( "musicstop" )
util.AddNetworkString( "alarmstop" )


admiral = nil
submarine = nil
local g_station = nil

function StartGame()
	print("starting game")
	ResetSubmarineManager()
	RemoveAllZombies()
	SpawnZombies()
	BabySwitchTimer(ply)
	SpawnSubmarineEntity()
	SpawnAdmiralEntity()
	Interactions()
	SetupSubmarine()
	
	for k,v in pairs(player.GetHumans()) do
		net.Start("music")
		net.Send( v )
	end
	if( !timer.Exists( "musicTimer") ) then
		timer.Create( "musicTimer" ,44, 0, function()
				for k,v in pairs(player.GetHumans()) do
					net.Start("music")
					net.Send( v )
				end
		end)
	end
	
	for k,v in pairs(player.GetHumans()) do
		net.Start("alarm")
		net.Send( v )
	end
	if( !timer.Exists( "alarmTimer") ) then
		timer.Create( "alarmTimer" ,7.2, 0, function()
		for k,v in pairs(player.GetHumans()) do
			net.Start("alarm")
			net.Send( v )
		end
		end)
	end
	

end

function StopGame()
	timer.Remove("musicTimer")
	timer.Remove("alarmTimer")
	
	for k,ply in pairs(player.GetHumans()) do
		net.Start("musicstop")
		net.Send( ply )
		net.Start("alarmstop")
		net.Send( ply )
	end
	
	
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
			RepairPoint:SetIdentifier(k)
			RepairPoint:Spawn()
			print("Spawning repair point: " .. k )
		end
	end
end

function SpawnSubmarineEntity()
	if(!IsValid(submarine)) then
		submarine = ents.Create("submarine")
		submarine:SetPos(Vector( 0,0,-1000 ))
		submarine:Spawn()
		print("Submarine Spawned with health " .. submarine:Health())
	end
end

function SpawnAdmiralEntity()
	if(!IsValid(admiral)) then
		admiral = ents.Create("admiral")
		admiral:SetPos(Vector( 0,0,-1001 ))
		admiral:Spawn()
	end
end

function GetSubmarine()
	return submarine
end

function GetAdmiral()
	return admiral
end

function GM:Think()
	if(IsRoundActive()) then
		if(!IsValid(admiral)) then
			SpawnAdmiralEntity()
		end
		if(!IsValid(submarine)) then
			SpawnSubmarineEntity()
		end
	end


	EndRoundCheck()
	SubmarineFlood(submarine)
end

function GM:PlayerHurt( victim,  attacker,  healthRemaining,  damageTaken )
	if(victim:GetActiveWeapon():GetClass() == "weapon_vampiricbaby") then
		print("Admiral hit!")
		local admiralHealth = admiral:GetAdmiralHealth()
		admiral:SetAdmiralHealth(admiralHealth - 1)
	end
end
