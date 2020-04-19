AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )

include( "shared.lua" )

function ENT:Initialize()
	self:SetModel( "models/items/ammocrate_smg1.mdl" )
	self:PhysicsInit( SOLID_VPHYSICS )
	self:SetMoveType( MOVETYPE_NONE )
	self:SetSolid( SOLID_VPHYSICS )
	self:SetUseType( SIMPLE_USE )

	local phys = self:GetPhysicsObject()
	if( phys:IsValid() ) then
		phys:Wake()
	end
	
end

function ENT:Use(activator, caller)
	activator:GiveAmmo( 20, 7, false )
	print( "ammo receieved" )
end