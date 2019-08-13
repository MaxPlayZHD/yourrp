--Copyright (C) 2017-2019 Arno Zura (https://www.gnu.org/licenses/gpl.txt)
AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")

function ENT:Initialize()
	self:SetHullType(HULL_HUMAN)
	self:SetHullSizeNormal()
	self:SetNPCState(NPC_STATE_SCRIPT)
	self:SetSolid(	SOLID_BBOX)
	self:CapabilitiesAdd(CAP_ANIMATEDFACE)
	self:CapabilitiesAdd(CAP_TURN_HEAD)
	self:DropToFloor()

	self:SetHealth(100)

	self:SetUseType(SIMPLE_USE)
	if IsDealerImmortal() then
		self:SetDBool("immortal", true)
	else
		self:SetDBool("immortal", false)
	end
end

function ENT:OnTakeDamage(dmg)
	self:SetHealth(self:Health() - dmg:GetDamage())
	if IsDealerImmortal() then
		self:SetDBool("immortal", true)
	else
		self:SetDBool("immortal", false)
		if self:Health() <= 0 then
			self:SetSchedule(SCHED_FALL_TO_GROUND)
			local _rd = ents.Create("prop_ragdoll")
			_rd:SetModel(self:GetModel())
			_rd:SetPos(self:GetPos())
			_rd:SetAngles(self:GetAngles())
			_rd:Spawn()
			self:Remove()
			timer.Simple(9, function()
				if tostring(_rd) != "[NULL Entity]" then
					_rd:Remove()
				end
			end)
		end
	end
end

function ENT:SelectSchedule()
	//self:StartSchedule(schdChase)
end

function ENT:Open(activator, caller)
	if IsDealerImmortal() then
		self:SetDBool("immortal", true)
	else
		self:SetDBool("immortal", false)
	end
	if !activator:GetDBool("open_menu", false) then
		activator:SetDBool("open_menu", true)
		timer.Simple(1, function()
			activator:SetDBool("open_menu", false)
		end)
	end
end

function ENT:AcceptInput(input, entActivator, entCaller, data)
	if string.lower(input) == "use" then
		self:Open(entActivator, entCaller)
		return
	end
end
