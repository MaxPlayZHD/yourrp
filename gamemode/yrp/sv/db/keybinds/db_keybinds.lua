--Copyright (C) 2017-2019 Arno Zura (https://www.gnu.org/licenses/gpl.txt)

-- DO NOT TOUCH THE DATABASE FILES! If you have errors, report them here:
-- https://discord.gg/sEgNZxg

local DATABASE_NAME = "yrp_keybinds"

SQL_ADD_COLUMN(DATABASE_NAME, "name", "TEXT DEFAULT ''")
SQL_ADD_COLUMN(DATABASE_NAME, "value", "INT DEFAULT 0")

if SQL_SELECT(DATABASE_NAME, "*", "uniqueID = 1") == nil then
	SQL_INSERT_INTO(DATABASE_NAME, "name, value", "'Version', '1'")
end

--SQL_DROP_TABLE(DATABASE_NAME)

util.AddNetworkString("SetServerKeybinds")
local PLAYER = FindMetaTable("Player")
function PLAYER:SetServerKeybinds()
	local sel = {}
	sel.table = DATABASE_NAME
	sel.cols = {}
	sel.cols[1] = "*"
	sel.where = nil
	local selresult = SQL.SELECT(sel)
	net.Start("SetServerKeybinds")
		net.WriteTable(selresult)
	net.Send(self)
end

util.AddNetworkString("setserverdefaultkeybind")
net.Receive("setserverdefaultkeybind", function(len, ply)
	local keybinds = net.ReadTable()
	for name, value in pairs(keybinds) do
		local sel = {}
		sel.table = DATABASE_NAME
		sel.cols = {}
		sel.cols[1] = "*"
		sel.where = "name = '" .. name .. "'"
		local selresult = SQL.SELECT(sel)
		if selresult != nil then
			local tab = {}
			tab.table = DATABASE_NAME
			tab.sets = {}
			tab.sets["value"] = value
			tab.where = "name = '" .. name .. "'"
			SQL.UPDATE(tab)
		else
			local tab = {}
			tab.table = DATABASE_NAME
			tab.cols = {}
			tab.cols["name"] = name
			tab.cols["value"] = value
			SQL.INSERT_INTO(tab)
		end
	end
end)

util.AddNetworkString("forcesetkeybinds")
net.Receive("forcesetkeybinds", function(len, ply)
	for i, p in pairs(player.GetAll()) do
		p:SetServerKeybinds()
	end
end)
