AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )

include( "shared.lua" )

function ENT:Initialize()
	self:SetModel( "models/props_c17/doll01.mdl" )
	self:PhysicsInit( SOLID_VPHYSICS )
	self:SetMoveType( MOVETYPE_NONE )
	self:SetSolid( SOLID_VPHYSICS )
	self:SetHealth( 1000 )
	self:SetMaxHealth(1000)
	
	babyHealth = self:Health()
	
	local phys = self:GetPhysicsObject()
	if( phys:IsValid() ) then
		phys:Wake()
	end
end

function ENT:Use(activator, caller)
	print( activator:GetName() .. " has used the " .. caller:GetName() )
end

function ENT:Think()
	if(#player.GetHumans() == 0) then return end

	local babyHealth = self:Health()
	babyHealth = babyHealth - 1
	--print(babyHealth)
	if babyHealth == self:GetMaxHealth()/2 then
		for k, ply in pairs(player.GetAll()) do
			ply:ChatPrint("Baby Admiral is at half health!")
		end
	end
	if babyHealth <= 0 then
		--SafeRemoveEntity( self )
		for k, ply in pairs(player.GetAll()) do
			ply:ChatPrint("Baby Admiral has died!")
		end
	end
	self:SetHealth(babyHealth)
end