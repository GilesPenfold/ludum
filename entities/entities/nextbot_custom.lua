AddCSLuaFile()

ENT.Base 			= "base_nextbot"
ENT.Spawnable 		= true

function ENT:Initialize()
	self:SetModel( "models/seagull.mdl" )
	
	self.StartleDist = 500
	self.WanderDist = 200
	
	PrintTable( self:GetSequenceList() )
end

function ENT:PlayerNear()
	
	for k, v in pairs( ents.FindInSphere( self:GetPos(), self.StartleDist ) ) do
		if( v:IsPlayer() && v:IsLineOfSightClear( self:GetPos() ) ) then
			return true
		end
	end
	return false
end

function ENT:RunBehaviour()
	while( true ) do
		if(self:PlayerNear()) then
			self.loco:SetDesiredSpeed( 300 )
			self:EmitSound( "ambient/voices/crying_loop1.wav" )
			self:PlaySequenceAndWait( "Hop" )
			self:StartActivity( ACT_RUN )
			self:MoveToPos( self:GetPos() + Vector(math.Rand( -1,1 ) , math.Rand( -1,1 ), 0 ) * 1000)
			self:StartActivity( ACT_IDLE )
			self:PlaySequenceAndWait( "Land" )
			self:StartActivity( ACT_IDLE )
		else 
			self:StartActivity( ACT_WALK )
			self.loco:SetDesiredSpeed( 100 )
			self:MoveToPos( self:GetPos() + Vector(math.Rand( -1,1 ) , math.Rand( -1,1 ), 0 ) * self.WanderDist)
			self:StartActivity( ACT_IDLE )
		end
		coroutine.wait(1)
	end
end

list.Set( "NPC","nextbot_custom", {
	Name = "Custom Bot",
	Class = "nextbot_custom",
	Category = "NextBot"
})