AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )

include( "shared.lua" )

function ENT:Initialize()
	self:SetModel( "models/maxofs2d/cube_tool.mdl" )
	self:PhysicsInit( SOLID_VPHYSICS )
	self:SetMoveType( MOVETYPE_NONE )
	self:SetSolid( SOLID_VPHYSICS )
	self:SetHealth( 1000 )
	
	entityDurability = self:Health()
	
	local phys = self:GetPhysicsObject()
	if( phys:IsValid() ) then
		phys:Wake()
	end
end

function ENT:Use(activator, caller)
	print( activator:GetName() .. " has used the " .. self:GetClass() )
end

function ENT:Think()
	entityDurability = entityDurability - 1
	--print(entityDurability)
	if entityDurability <= 0 then
		SafeRemoveEntity( self )
	end
end