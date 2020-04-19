ENT.Base = "base_anim"
ENT.Type = "anim"

ENT.PrintName		= "admiral"
ENT.Author			= "Giles"
ENT.Instructions	= "ADMIRAL_BABY!"
ENT.RenderGroup		= RENDERGROUP_OTHER

ENT.Spawnable = true
ENT.AdminSpawnable = true

function ENT:SetupDataTables()
 
 	self:NetworkVar( "Int", 0, "AdmiralHealth" )
	self:NetworkVar( "Int", 1, "AdmiralMaxHealth" )
	
	if(SERVER) then
		self:SetAdmiralHealth(10)
		self:SetAdmiralMaxHealth(10)
	end
 
 end