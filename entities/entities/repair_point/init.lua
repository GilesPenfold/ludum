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
	if(activator:GetActiveWeapon():GetClass() == "weapon_vampiricbaby" && !self:GetCapped()) then
	
		if( !timer.Exists( "entityInteractTimer" ) ) then
			timer.Create( "entityInteractTimer",1,1,function()			
				local entDur = self:GetEntityDurability()
				self:SetEntityDurability(math.Clamp(entDur + 1, 0, 100))
				entDur = self:GetEntityDurability()
				print(activator:GetName() .. " repaired a repair point to " .. entDur)
				
				if(entDur >= self:GetRepairPointMaxHealth()) then
					self:SetCapped(true)
					print("Repair point has been capped.")
					if( !timer.Exists( "entityCappedTimer" ) ) then
						timer.Create( "entityTimer",10,1,function() 
							self:SetCapped(false)
						end)
					end
				end
			end)
		end
	end
end


function ENT:Think()
	if( !timer.Exists( "entityTimer" ) ) then
		timer.Create( "entityTimer",math.random(2,4),1,function() 
			local entDur = self:GetEntityDurability()
			self:SetEntityDurability(math.Clamp(entDur - 1, 0, 100))
		end)
	end
	
end
