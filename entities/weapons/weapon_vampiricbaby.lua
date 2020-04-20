AddCSLuaFile()

SWEP.Author 					=	"Giles"
SWEP.Base						=	"weapon_base"
SWEP.PrintName					=	"Admiral Baby"
SWEP.Instructions				=	[[LeftClick: Hit thing.]]

SWEP.ViewModel 					= 	"models/props_c17/doll01.mdl"
SWEP.ViewModelFlip				=	false
SWEP.UseHands					=	true
SWEP.WorldModel 				= 	"models/props_c17/doll01.mdl"
SWEP.SetHoldType				=	"melee"

SWEP.Weight						=	5
SWEP.AutoSwitchTo				=	true
SWEP.AutoSwitchFrom				=	false

SWEP.Slot						= 	4
SWEP.SlotPos					=	0

SWEP.DrawAmmo					=	false
SWEP.DrawCrosshair				=	false

SWEP.Spawnable					=	true
SWEP.AdminSpawnable				=	true
SWEP.ShouldDropOnDie			=	true

SWEP.Primary.ClipSize			=	-1
SWEP.Primary.DefaultClip		= 	-1
SWEP.Primary.Ammo				=	"none"
SWEP.Primary.Automatic			=	false

SWEP.Secondary.ClipSize			=	-1
SWEP.Secondary.DefaultClip		= 	-1
SWEP.Secondary.Ammo				=	"none"
SWEP.Secondary.Automatic		=	false

local BabyHealth				=	1000

-- Adjust these variables to move the viewmodel's position
SWEP.IronSightsPos  = Vector(10, 20, -5)
SWEP.IronSightsAng  = Vector(0,140,-20)

function SWEP:GetViewModelPosition(EyePos, EyeAng)
	local Mul = 1.0

	local Offset = self.IronSightsPos
	
	local Right 	= EyeAng:Right()
	local Up 		= EyeAng:Up()
	local Forward 	= EyeAng:Forward()

	EyePos = EyePos + Offset.x * Right * Mul
	EyePos = EyePos + Offset.y * Forward * Mul
	EyePos = EyePos + Offset.z * Up * Mul

	if (self.IronSightsAng) then
        EyeAng = EyeAng * 1
        
		EyeAng:RotateAroundAxis(EyeAng:Right(), 	self.IronSightsAng.x * Mul)
		EyeAng:RotateAroundAxis(EyeAng:Up(), 		self.IronSightsAng.y * Mul)
		EyeAng:RotateAroundAxis(EyeAng:Forward(),   self.IronSightsAng.z * Mul)
	end


	
	return EyePos, EyeAng
end


local SwingSound				=	Sound("baby_sound")--Sound("Weapon_Crowbar.Single")
local HitSound					=	Sound("baby_sound")--Sound("Weapon_Crowbar.Melee_Hit")

function SWEP:Initialize()
	self:SetHoldType("melee")
end

function SWEP:PrimaryAttack()
	return false
end

function SWEP:CanSecondaryAttack()
	return false
end

function SWEP:Think()
	for k,v in pairs(ents.FindByClass("submarine")) do
		self:CallOnClient("SetBabyHealth",v:Health())
	end
	--print("Admiral's health: " .. BabyHealth)
end

function SWEP:SetBabyHealth(h)
	BabyHealth = h
end


if CLIENT then
	function SWEP:DrawHUD()
		
		local vPos = ScrW()-300
		local hPos = 50
		
		local width = 250 
		local totalWidth = 250 * (BabyHealth / 1000 )
		local height = 30

		--draw.RoundedBox(10, vPos,hPos, width, height, Color(225,20,20, 150))
		--draw.RoundedBox(10, vPos,hPos, totalWidth, height, Color(225,20,20, 255))	
		
		--draw.SimpleText("Admiral's Health", "Default", vPos + 10, hPos + 3, Color(255,255,255,255), 0, 0)
	end
end

