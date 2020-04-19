local ply = FindMetaTable("Player")

local teams = {}

teams[0] = 
{
	name = "Red",
	color = Vector(255,0,0),
}

teams[1] = 
{
	name = "Blue",
	color = Vector(0,0,255),
}


function ply:SetupTeam( n )
	if(not teams[n]) then return end
	
	self:SetTeam(n)
	self:SetPlayerColor(teams[n].color)
end

function ply:PlayerLoadout()
	local plyClass = PLAYER_CLASSES[self:GetNWInt("PlayerClass")]
	
	for k,v in pairs(plyClass.weapons) do
		self:Give(v)
	end

	return true
end

function ply:PlayerSetModel()
	local plyClass = PLAYER_CLASSES[self:GetNWInt("PlayerClass")]
	
	self:SetModel(plyClass.model)

	return true
end

function ply:GetLoadoutName()
	local plyClass = PLAYER_CLASSES[self:GetNWInt("PlayerClass")]
	return plyClass.name
end

function ply:SetupForNewRound()
	self:PlayerLoadout()
	self:PlayerSetModel()
	self:SetupHands()
end

function ply:SetNewClass(class)
	self:SetNWInt("PlayerClass", class)
end