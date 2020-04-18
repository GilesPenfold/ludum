AddCSLuaFile()

DEFINE_BASECLASS "weapon_base"

SWEP.Author 					=	"Giles"
SWEP.Base						=	"weapon_base"
SWEP.PrintName					=	"Rootin' Tootin' Shotgun"
SWEP.Instructions				=	[[LeftClick: Blast.]]

if CLIENT then

   SWEP.ViewModelFOV       = 54

end

SWEP.ViewModel					=	"models/weapons/c_shotgun.mdl"
SWEP.ViewModelFlip      = false
SWEP.UseHands					=	true
SWEP.WorldModel					=	"models/weapons/w_shotgun.mdl"
SWEP.SetHoldType				=	"shotgun"

SWEP.Weight						=	5
SWEP.AutoSwitchTo				=	true
SWEP.AutoSwitchFrom				=	false

SWEP.ReloadingTime				=	1

SWEP.Slot  			            = 	2
SWEP.SlotPos					=	0

SWEP.DrawAmmo					=	true
SWEP.DrawCrosshair				=	true

SWEP.Spawnable					=	true
SWEP.AdminSpawnable				=	true
SWEP.ShouldDropOnDie			=	true

SWEP.Primary.ClipSize			=	6
SWEP.Primary.ClipMax			=	24
SWEP.Primary.DefaultClip		= 	6
SWEP.Primary.Ammo				=	"Buckshot"
SWEP.Primary.Automatic			=	false
SWEP.Primary.Recoil				= 	8
SWEP.Primary.Damage				= 	12
SWEP.Primary.NumShots			=	8
SWEP.Primary.Spread				=	0
SWEP.Primary.Cone 				=	0.085
SWEP.Primary.Delay 				=	1


SWEP.Secondary.ClipSize			=	-1
SWEP.Secondary.DefaultClip		= 	-1
SWEP.Secondary.Ammo				=	"none"
SWEP.Secondary.Automatic		=	false

local isReloading				=	false
local ShootSound				=	Sound("Weapon_XM1014.Single")

function SWEP:Initialize()
	self:SetHoldType("shotgun")
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
	return false
end

function SWEP:Reload()

   --if self:GetNWBool( "reloading", false ) then return end
   if self:GetReloading() then return end

   if self:Clip1() < self.Primary.ClipSize and self:GetOwner():GetAmmoCount( self.Primary.Ammo ) > 0 then

      if self:StartReload() then
         return
      end
   end

end

function SWEP:SetReloading(r)
	self.isReloading = r
end

function SWEP:GetReloading()
	return self.isReloading
end

function SWEP:SetReloadTimer(r)
	self.isReloading = r
end


function SWEP:StartReload()
   --if self:GetNWBool( "reloading", false ) then
   if self:GetReloading() then
      return false
   end

   self:SetNextPrimaryFire( CurTime() + self.Primary.Delay )

   local ply = self:GetOwner()

   if not ply or ply:GetAmmoCount(self.Primary.Ammo) <= 0 then
      return false
   end

   local wep = self

   if wep:Clip1() >= self.Primary.ClipSize then
      return false
   end

   wep:SendWeaponAnim(ACT_SHOTGUN_RELOAD_START)

   self:SetReloadTimer(CurTime() + wep:SequenceDuration())

   --wep:SetNWBool("reloading", true)
   self:SetReloading(true)

   return true
end

function SWEP:PerformReload()
   local ply = self:GetOwner()

   -- prevent normal shooting in between reloads
   self:SetNextPrimaryFire( CurTime() + self.Primary.Delay )

   if not ply or ply:GetAmmoCount(self.Primary.Ammo) <= 0 then return end

   if self:Clip1() >= self.Primary.ClipSize then return end

   self:GetOwner():RemoveAmmo( 1, self.Primary.Ammo, false )
   self:SetClip1( self:Clip1() + 1 )

   self:SendWeaponAnim(ACT_VM_RELOAD)

   self.ReloadingTime = (CurTime() + self:SequenceDuration())
end

function SWEP:FinishReload()
   self:SetReloading(false)
   self:SendWeaponAnim(ACT_SHOTGUN_RELOAD_FINISH)

   self.ReloadingTime = (CurTime() + self:SequenceDuration())
end

function SWEP:CanPrimaryAttack()
   if self:Clip1() <= 0 then
      self:EmitSound( "Weapon_Shotgun.Empty" )
      self:SetNextPrimaryFire( CurTime() + self.Primary.Delay )
      return false
   end
   return true
end

function SWEP:Think()
   BaseClass.Think(self)
   if self:GetReloading() then
      if self:GetOwner():KeyDown(IN_ATTACK) then
         self:FinishReload()
         return
      end

      if self.ReloadingTime <= CurTime() then

         if self:GetOwner():GetAmmoCount(self.Primary.Ammo) <= 0 then
            self:FinishReload()
         elseif self:Clip1() < self.Primary.ClipSize then
            self:PerformReload()
         else
            self:FinishReload()
         end
         return
      end
   end
end


