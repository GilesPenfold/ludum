AddCSLuaFile("shared.lua")
AddCSLuaFile("cl_init.lua")
AddCSLuaFile("teamsetup.lua")

include("shared.lua")
include("teamsetup.lua")

function GM:PlayerSpawn( ply )
	ply:SetupTeam(math.random(0,1))
	ply:ChatPrint("You have spawned, bruh!")
	print ( "Player: " .. ply:Nick() .. " has spawned, dude." )
	
	local npc = ents.Create ( "nextbot_custom" )
    npc:SetPos( ply:GetPos()+ Vector( -1000,0,0 ) )
    npc:Spawn()
	
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