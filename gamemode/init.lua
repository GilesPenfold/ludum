AddCSLuaFile("shared.lua")
AddCSLuaFile("cl_init.lua")
AddCSLuaFile("teamsetup.lua")
AddCSLuaFile("sounds.lua")
AddCSLuaFile("babymanager.lua")
AddCSLuaFile("custom_classes.lua")

resource.AddFile("gamemodes/ludum/content/sound/weapons/baby/baby.wav")

include("shared.lua")
include("teamsetup.lua")
include("sounds.lua")
include("babymanager.lua")
include("custom_classes.lua")

admiralBaby = nil

hook.Add("PlayerSay", "CommandIndent", function(ply, text, bteam)

	text = string.lower(text)
	
	if(text=="!start") then
		SpawnTimer()
		BabySwitchTimer(ply)
		SpawnAdmiralBaby()
	end
	
	print(text)
end)

function GM:PlayerInitialSpawn( ply )
	ply:SetupTeam(0)
	ply:SetNWInt("PlayerClass",3)
end

function GM:PlayerSpawn( ply )
	ply:ChatPrint("You have spawned!")
	print ( "Player: " .. ply:Nick() .. " has spawned." )
	
	SpawnRepairPoint(ply)
	
	ply:PlayerLoadout()
	ply:PlayerSetModel()
	ply:SetupHands()
	
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

ZombiesInScene = {}

function SpawnTimer()
    if( !timer.Exists( "SpawnTimer" ) ) then
        timer.Create( "SpawnTimer",2,0,function() 
            if( #ZombiesInScene > 10 ) then
                return
            else
                SpawnZombie()
            end
        end)
    end
end

function SpawnZombie()
    -- TODO replace below Vectors with GetPos() on "spawn point" entities
    local SpawnPoints = {
        Vector(0,0,50),
        Vector(0,0,20),
        Vector(50,0,0),
        Vector(50,0,0)}

    local npc = ents.Create( "npc_zombie" )
    table.insert(ZombiesInScene,npc)
    npc:SetPos(SpawnPoints[math.random(1,#SpawnPoints)])
    npc:Spawn()
end

function SpawnRepairPoint(p)
    local repairPoint = ents.Create("repair_point")
    repairPoint:SetPos(p:GetPos() + Vector( 0,80,0 ))
    repairPoint:Spawn()
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

