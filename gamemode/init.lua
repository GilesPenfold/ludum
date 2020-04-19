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

admiralBaby = nil

function StartGame()
	SpawnTimer()
	BabySwitchTimer(ply)
	SpawnAdmiralBaby()
	Interactions()
end

function GM:PlayerInitialSpawn( ply )
	ply:SetupTeam(0)
	ply:SetNewClass(1)
end

function GM:PlayerSpawn( ply )	
	if(IsRoundActive()) then
		ply:ChatPrint("You have spawned as: " .. ply:GetLoadoutName())
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

function SpawnAdmiralBaby()
    admiralBaby = ents.Create("admiral_baby")
    admiralBaby:SetPos(Vector( 0,0,-1000 ))
    admiralBaby:Spawn()
	print("Admiral Baby Spawned with health " .. admiralBaby:Health())
end

function GetAdmiralBaby()
	return admiralBaby
end

