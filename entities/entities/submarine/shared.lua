ENT.Base = "base_anim"
ENT.Type = "anim"

ENT.PrintName		= "admiral_baby"
ENT.Author			= "Bittripbrit"
ENT.Instructions	= "Admiral Baby!"
ENT.RenderGroup		= RENDERGROUP_OTHER

ENT.Spawnable = true
ENT.AdminSpawnable = true

ENT.SubmergedWalkSpeed = 100
ENT.SubmeredRunSpeed = 150

function ENT:SetupDataTables()
 
 	self:NetworkVar( "Int", 0, "SubmarineFlooding" )
	
	if(SERVER) then
		self:SetSubmarineFlooding(1)
	end
 
 end