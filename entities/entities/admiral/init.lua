AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )

include( "shared.lua" )


function ENT:Initialize()
	self:SetModel( "models/props_c17/doll01.mdl" )
	self:PhysicsInit( SOLID_VPHYSICS )
	self:SetMoveType( MOVETYPE_NONE )
	self:SetSolid( SOLID_VPHYSICS )
	self:SetHealth( 10 )
	self:SetMaxHealth(10)

	self:AddEFlags( EFL_FORCE_CHECK_TRANSMIT )
	
	local phys = self:GetPhysicsObject()
	if( phys:IsValid() ) then
		phys:Wake()
	end
end

function ENT:UpdateTransmitState()	
	return TRANSMIT_ALWAYS 
end

function ENT:ResetAdmiral()

	self:SetAdmiralHealth(self:GetAdmiralMaxHealth())
	
end