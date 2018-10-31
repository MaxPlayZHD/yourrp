
SWEP.Author = "D4KiR"
SWEP.Contact = "youtube.com/c/D4KiR"
SWEP.Purpose = ""
SWEP.Instructions = ""

SWEP.Category = "[YourRP] Medical"

SWEP.PrintName = "Bandage"
SWEP.Language = "en"
SWEP.LanguageString = "bandages"

SWEP.Slot = 5
SWEP.SlotPos = 1

SWEP.DrawAmmo = false

SWEP.DrawCrosshair = false

SWEP.Spawnable = true
SWEP.AdminSpawnable = true

SWEP.ViewModel = "models/props_junk/PopCan01a.mdl"
SWEP.WorldModel = "models/props_junk/PopCan01a.mdl"

SWEP.Primary.ClipSize = 1
SWEP.Primary.DefaultClip = 1
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = "bandage"
SWEP.Secondary.Ammo = "bandagesecondary"

SWEP.DrawCrosshair = true

SWEP.HoldType = "fist"
function SWEP:Initialize()
	self:SetWeaponHoldType(self.HoldType)
end

function SWEP:Reload()
	self:DefaultReload(ACT_VM_RELOAD)
end

function SWEP:Think()

end

local _target = nil
function SWEP:PrimaryAttack()
	if SERVER then
		if self:Clip1() > 0 then
			local ply = self:GetOwner()
			local tr = util.QuickTrace(ply:EyePos(), ply:GetAimVector() * 100, ply)
			if tr.Hit then
				self.target = tr.Entity
				if tr.Entity:IsPlayer() then
					ply:StartCasting("bandage", "bandaging", 0, self.target, 3, 100, 1, false)
				end
			end
		end
	end
end

if SERVER then
	hook.Add("yrp_castdone_bandage", "bandage", function(args)
		args.target:Heal(10)
		args.target:StopBleeding()
		args.attacker:GetActiveWeapon():TakePrimaryAmmo(1)
	end)
end


function SWEP:SecondaryAttack()
	if SERVER then
		if self:Clip1() > 0 then
			local ply = self:GetOwner()
			_target = ply
			ply:StartCasting("bandage", "bandaging", 0, _target, 3, 100, 1, false)
		end
	end
end
