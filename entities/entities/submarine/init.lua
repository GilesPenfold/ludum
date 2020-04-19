AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )

include( "shared.lua" )

local startingFlooding = 1
local maxFlooding = 1000

function ENT:Initialize()
	self:SetModel( "models/props_c17/doll01.mdl" )
	self:PhysicsInit( SOLID_VPHYSICS )
	self:SetMoveType( MOVETYPE_NONE )
	self:SetSolid( SOLID_VPHYSICS )
	self:SetHealth( startingFlooding )
	self:SetMaxHealth(startingFlooding)

	self:AddEFlags( EFL_FORCE_CHECK_TRANSMIT )
	
	local phys = self:GetPhysicsObject()
	if( phys:IsValid() ) then
		phys:Wake()
	end
end

function ENT:UpdateTransmitState()	
	return TRANSMIT_ALWAYS 
end

function ENT:Think()

	if(self:GetIsFlooded()) then return end
	if(#player.GetHumans() == 0) then return end

	local submarineHealth = self:GetSubmarineFlooding()
	if submarineHealth >= maxFlooding then
		for k, ply in pairs(player.GetAll()) do
			ply:ChatPrint("The submarine has flooded!")
			self:SetIsFlooded(true)
		end
	end
	
end

function ENT:ResetSubmarine()

	self:SetSubmarineFlooding(1)
	self:SetIsFlooded(false)
	self:SetWaterLevel(Vector(0,0,-1000))
	
end