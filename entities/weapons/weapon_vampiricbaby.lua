AddCSLuaFile()

SWEP.Author 					=	"Giles"
SWEP.Base						=	"weapon_base"
SWEP.PrintName					=	"Vamp Crowbar"
SWEP.Instructions				=	[[LeftClick: Hit thing.]]

SWEP.ViewModel 					= 	"models/props_c17/doll01.mdl"
SWEP.ViewModelFlip				=	false
SWEP.UseHands					=	true
SWEP.WorldModel 				= 	"models/props_c17/doll01.mdl"
SWEP.SetHoldType				=	"melee"

SWEP.Weight						=	5
SWEP.AutoSwitchTo				=	true
SWEP.AutoSwitchFrom				=	false

SWEP.Slot						= 	0
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
SWEP.Secondary.Automatic			=	false

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


local SwingSound				=	Sound("Weapon_Crowbar.Single")
local HitSound					=	Sound("Weapon_Crowbar.Melee_Hit")

function SWEP:Initialize()
	self:SetHoldType("melee")
end

function SWEP:PrimaryAttack()

	if(CLIENT) then return end

	local ply = self:GetOwner()

	ply:LagCompensation(true)

	local shootPos = ply:GetShootPos()
	local endShootPos = shootPos + ply:GetAimVector() * 70
	local tmin = Vector(1,1,1) * -10
	local tmax = Vector(1,1,1) * 10
	
	local tr = util.TraceHull ({
		start = shootPos,
		endpos = endShootPos,
		filter = ply,
		mask = MASK_SHOT_HULL,
		mins = tmin,
		maxs = tmax })
	
	if(not IsValid(tr.Entity)) then
		tr = util.TraceLine ({
			start = shootPos,
			endpos = endShootPos,
			filter = ply,
			mask = MASK_SHOT_HULL })
	end
	
	local ent = tr.Entity
	
	if(IsValid(ent) && ( ent:IsPlayer() || ent:IsNPC() ) ) then
		self.Weapon:SendWeaponAnim(ACT_VM_HITCENTER)
		ply:SetAnimation(PLAYER_ATTACK1)
		
		ply:EmitSound(HitSound)
		ent:SetHealth(ent:Health() - 1)
		if(ent:Health() < 1) then
			ent:Kill()
		end
		
		ply:SetHealth(math.Clamp(ply:Health() + 10, 1, ply:GetMaxHealth() ) )
		
	elseif(not IsValid(ent) ) then
	
		self.Weapon:SendWeaponAnim(ACT_VM_MISSCENTER)
		ply:SetAnimation(PLAYER_ATTACK1)
		
		ply:EmitSound(SwingSound)
	end
	
	self:SetNextPrimaryFire(CurTime() + self:SequenceDuration() + 0.1)

	ply:LagCompensation(false)
end

function SWEP:CanSecondaryAttack()
	return false
end

