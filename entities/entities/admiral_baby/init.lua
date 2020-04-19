AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )

include( "shared.lua" )

local IsDead = false
local startingHealth = 1000

function ENT:Initialize()
	self:SetModel( "models/props_c17/doll01.mdl" )
	self:PhysicsInit( SOLID_VPHYSICS )
	self:SetMoveType( MOVETYPE_NONE )
	self:SetSolid( SOLID_VPHYSICS )
	self:SetHealth( startingHealth )
	self:SetMaxHealth(startingHealth)
	IsDead = false;
	
	local phys = self:GetPhysicsObject()
	if( phys:IsValid() ) then
		phys:Wake()
	end
end

function ENT:IsDead()
	return IsDead
end

function ENT:Think()
	local babyHealth = self:Health()
	if(babyHealth <= 0) then return end
	if(#player.GetHumans() == 0) then return end

	babyHealth = babyHealth - 1
	self:SetHealth(babyHealth)
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
			IsDead = true
		end
	end
	
end