AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )

include( "shared.lua" )

function ENT:Initialize()
	self:SetModel( "models/maxofs2d/cube_tool.mdl" )
	self:PhysicsInit( SOLID_VPHYSICS )
	self:SetMoveType( MOVETYPE_NONE )
	self:SetSolid( SOLID_VPHYSICS )
	self:SetHealth( 100 )
	
	self:AddEFlags( EFL_FORCE_CHECK_TRANSMIT )

	
	local phys = self:GetPhysicsObject()
	if( phys:IsValid() ) then
		phys:Wake()
	end
end

function ENT:UpdateTransmitState()	
	return TRANSMIT_ALWAYS 
end

function ENT:Use(activator, caller)
	if(activator:GetActiveWeapon():GetClass() == "weapon_weakcrowbar" && !self:GetCapped() && !self:GetBroken()) then
		if( !timer.Exists( "entityInteractTimer" .. self:GetIdentifier() ) ) then
			timer.Create( "entityInteractTimer" .. self:GetIdentifier() ,0.2,1,function()			
				local entDur = self:GetEntityDurability()
				self:SetEntityDurability(math.Clamp(entDur + 1, 0, 100))
				entDur = self:GetEntityDurability()
				print(activator:GetName() .. " repaired a repair point to " .. entDur)
				
				self:EmitSound("physics/metal/weapon_impact_hard1.wav")
				
				if(entDur >= self:GetRepairPointMaxHealth()) then
					self:SetCapped(true)
					print("Repair point has been capped.")
					if( !timer.Exists( "entityCappedTimer" .. self:GetIdentifier()  ) ) then
						timer.Create( "entityCappedTimer" .. self:GetIdentifier(), math.random(8,16),1,function()
							print("entityCappedTimer" .. self:GetIdentifier() .. "uncapping")
							self:SetCapped(false)
						end)
					end
				end
			end)
		end
	end
end


function ENT:Think()
	if( !timer.Exists( "entityTimer".. self:GetIdentifier() ) ) then
		timer.Create( "entityTimer".. self:GetIdentifier(),math.random(2,5),1,function()
			if(!IsValid(self)) then return end
			if(!self:GetCapped()) then
				local entDur = self:GetEntityDurability()
				
				local numPlayers = #player.GetHumans()
				local minReduction = numPlayers + 1
				local maxReduction = (numPlayers * 2) - 1
				
				self:SetEntityDurability(math.Clamp(entDur - math.random(minReduction,maxReduction), 0, 100))
				
				if(self:GetEntityDurability() <= 0) then
					self:SetBroken(true)
					self:Ignite(1000,200)
				end
			end
		end)
	end
	
end
