AddCSLuaFile()

SWEP.Base = "aerial_base"
SWEP.PrintName = "Repair Tool"
SWEP.Category = "Pinecrest"
SWEP.Spawnable = true
SWEP.AdminOnly = true

SWEP.DrawCrosshair = false

SWEP.ViewModel = Model( "models/weapons/c_arms.mdl" )
SWEP.WorldModel = Model("models/weapons/w_bugbait.mdl")
SWEP.UseHands = false

SWEP.Weight = 10
SWEP.HoldType = "normal"

SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = ""
SWEP.Primary.ClipSize = 0
SWEP.Primary.AttackType = aerial.enums.ATTACK_TYPE_NONE

SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo = ""
SWEP.Secondary.AttackType = aerial.enums.ATTACK_TYPE_NONE

SWEP.Aim = {}
SWEP.Aim.Enabled = false

function SWEP:PrimaryAttack() end
function SWEP:SecondaryAttack() end

function SWEP:CanPrimaryAttack() return false end
function SWEP:CanSecondaryAttack() return false end

function SWEP:OnReload()
    --self:SendWeaponAnimation()
end