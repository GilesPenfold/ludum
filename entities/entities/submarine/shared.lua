ENT.Base = "base_anim"
ENT.Type = "anim"

ENT.PrintName		= "submarine"
ENT.Author			= "Giles"
ENT.Instructions	= "SUBMARINE!"
ENT.RenderGroup		= RENDERGROUP_OTHER

ENT.Spawnable = true
ENT.AdminSpawnable = true

ENT.SubmergedWalkSpeed = 100
ENT.SubmeredRunSpeed = 150

function ENT:SetupDataTables()
 
 	self:NetworkVar( "Int", 0, "SubmarineFlooding" )
	self:NetworkVar( "Bool", 0, "IsFlooded" )
	self:NetworkVar( "Vector", 0, "WaterLevel" )
	
	if(SERVER) then
		self:SetSubmarineFlooding(1)
		self:SetIsFlooded(false)
		self:SetWaterLevel(Vector(0,0,-1000))
	end
 
 end