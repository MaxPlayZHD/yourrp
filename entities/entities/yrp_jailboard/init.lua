--Copyright (C) 2017-2019 Arno Zura (https://www.gnu.org/licenses/gpl.txt)

AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")

util.AddNetworkString("openLawBoard")

function ENT:Initialize()
	self:SetModel("models/props_combine/combine_intmonitor001.mdl")
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)

	local phys = self:GetPhysicsObject()
	if (phys:IsValid()) then
		phys:Wake()
	end
end

function ENT:Use(activator, caller)
	local tmpTable = SQL_SELECT("yrp_jail", "*", nil)

	if !wk(tmpTable) then
		tmpTable = {}
	end

	for i, v in pairs(tmpTable) do
		local cells = SQL_SELECT("yrp_" .. GetMapNameDB(), "*", "type = 'jailpoint' and uniqueID = '" .. v.cell .. "'")
		if wk(cells) then
			cells = cells[1]
			v.cellname = cells.name
		else
			v.cellname = "DELETED CELL"
		end
	end

	net.Start("openLawBoard")
		net.WriteTable(tmpTable)
	net.Send(caller)
end

function ENT:Think()

end

util.AddNetworkString("jail")
net.Receive("jail", function(len, ply)
	local target = net.ReadEntity()

	local jail = SQL_SELECT("yrp_jail", "*", "SteamID = '" .. target:SteamID() .. "'")
	if wk(jail) then
		jail = jail[1]
		local time = jail.time
		teleportToJailpoint(target, time)
	end
end)

util.AddNetworkString("unjail")
net.Receive("unjail", function(len, ply)
	local target = net.ReadEntity()

	SQL_DELETE_FROM("yrp_jail", "SteamID = '" .. target:SteamID() .. "'")

	teleportToReleasepoint(target)
end)