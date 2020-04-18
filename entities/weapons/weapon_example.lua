AddCSLuaFile()

SWEP.Author 					=	"Giles"
SWEP.Base						=	"weapon_base"
SWEP.PrintName					=	"PewPew"
SWEP.Instructions				=	[[LeftClick: Pew. RightClick: PewPew.]]

SWEP.ViewModel					=	"models/weapons/c_357.mdl"
SWEP.ViewModelFlip				=	false
SWEP.UseHands					=	true
SWEP.WorldModel					=	"models/weapons/c_357.mdl"
SWEP.SetHoldType				=	"pistol"

SWEP.Weight						=	5
SWEP.AutoSwitchTo				=	true
SWEP.AutoSwitchFrom				=	false

SWEP.Slot						= 	1
SWEP.SlotPos					=	0

SWEP.DrawAmmo					=	false
SWEP.DrawCrosshair				=	true

SWEP.Spawnable					=	true
SWEP.AdminSpawnable				=	true
SWEP.ShouldDropOnDie			=	true

SWEP.Primary.ClipSize			=	1
SWEP.Primary.DefaultClip		= 	1
SWEP.Primary.Ammo				=	"357"
SWEP.Primary.Automatic			=	false
SWEP.Primary.Recoil				= 	1
SWEP.Primary.Damage				= 	1000
SWEP.Primary.NumShots			=	1
SWEP.Primary.Spread				=	0
SWEP.Primary.Cone 				=	0
SWEP.Primary.Delay 				=	1


SWEP.Secondary.ClipSize			=	2
SWEP.Secondary.DefaultClip		= 	2
SWEP.Secondary.Ammo				=	"shotgun"
SWEP.Secondary.Automatic		=	false
SWEP.Secondary.Recoil			= 	5
SWEP.Secondary.Damage			= 	5000
SWEP.Secondary.NumShots			=	2
SWEP.Secondary.Spread			=	4
SWEP.Secondary.Cone 			=	5
SWEP.Secondary.Delay 			=	1

local ShootSound				=	Sound("Weapon_357.Single")

function SWEP:Initialize()
	self:SetHoldType("pistol")
end

function SWEP:PrimaryAttack()

	if( not self:CanPrimaryAttack() ) then
		return
	end

	local ply = self:GetOwner()

	ply:LagCompensation(true)

	local Bullet = {}
	Bullet.Num		=	self.Primary.NumShots
	Bullet.Src 		= 	ply:GetShootPos()
	Bullet.Dir 		=	ply:GetAimVector()
	Bullet.Spread	=	Vector(self.Primary.Spread, self.Primary.Spread, 0)
	Bullet.Tracer	=	0
	Bullet.Damage	=	self.Primary.Damage
	Bullet.AmmoType	=	self.Primary.Ammo

	self:FireBullets(Bullet)
	self:ShootEffects()

	self:EmitSound(ShootSound)
	self.BaseClass.ShootEffects(self)
	self:TakePrimaryAmmo(1)
	self:SetNextPrimaryFire(CurTime() + self.Primary.Delay)


	ply:LagCompensation(false)
end

function SWEP:SecondaryAttack()
end

