AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )

include( "shared.lua" )

local IsDead = false
local startingFlooding = 1
local maxFlooding = 1000

function ENT:Initialize()
	self:SetModel( "models/props_c17/doll01.mdl" )
	self:PhysicsInit( SOLID_VPHYSICS )
	self:SetMoveType( MOVETYPE_NONE )
	self:SetSolid( SOLID_VPHYSICS )
	self:SetHealth( startingFlooding )
	self:SetMaxHealth(startingFlooding)
	IsDead = false;
	
	self:AddEFlags( EFL_FORCE_CHECK_TRANSMIT )
	
	local phys = self:GetPhysicsObject()
	if( phys:IsValid() ) then
		phys:Wake()
	end
end

function ENT:UpdateTransmitState()	
	return TRANSMIT_ALWAYS 
end

function ENT:IsDead()
	return IsDead
end

function ENT:Think()
	local submarineHealth = self:Health()
	if(submarineHealth >= 1000) then return end
	if(#player.GetHumans() == 0) then return end

	submarineHealth = submarineHealth + 1
	self:SetHealth(submarineHealth)
	if submarineHealth == self:GetMaxHealth()/2 then
		for k, ply in pairs(player.GetAll()) do
			ply:ChatPrint("Submarine is half flooded!")
		end
	end
	if submarineHealth <= 0 then
		for k, ply in pairs(player.GetAll()) do
			ply:ChatPrint("The submarine has flooded!")
			IsDead = true
		end
	end
	
end