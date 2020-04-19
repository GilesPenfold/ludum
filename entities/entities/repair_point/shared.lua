ENT.Base = "base_anim"
ENT.Type = "anim"

ENT.PrintName		= "repair_point"
ENT.Author			= "Quietus"
ENT.Instructions	= "Spawn Me!"
ENT.RenderGroup		= RENDERGROUP_OPAQUE

ENT.Spawnable = true
ENT.AdminSpawnable = false

ENT.RepairPointMaxHealth = 100
ENT.RepairPointDangerZone = 70

function ENT:SetupDataTables()
 
 	self:NetworkVar( "Int", 0, "EntityDurability" )
	self:NetworkVar( "Int", 1, "RepairPointDangerZone" )
	self:NetworkVar( "Int", 2, "RepairPointMaxHealth" )
	self:NetworkVar( "Int", 3, "Identifier" )
	self:NetworkVar( "Bool", 0, "Capped" )
	self:NetworkVar( "Bool", 1, "Broken" )
	
	if(SERVER) then
		self:SetEntityDurability(math.random(80,self.RepairPointMaxHealth))
		self:SetRepairPointDangerZone(self.RepairPointDangerZone)
		self:SetRepairPointMaxHealth(self.RepairPointMaxHealth)
		self:SetCapped(false)
		self:SetBroken(false)
	end
 
 end