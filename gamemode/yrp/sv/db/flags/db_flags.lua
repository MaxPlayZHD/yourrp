--Copyright (C) 2017-2020 Arno Zura (https://www.gnu.org/licenses/gpl.txt)

-- DO NOT TOUCH THE DATABASE FILES! If you have errors, report them here:
-- https://discord.gg/sEgNZxg

local DATABASE_NAME = "yrp_flags"

--SQL_DROP_TABLE(DATABASE_NAME)

SQL_ADD_COLUMN(DATABASE_NAME, "string_name", "TEXT DEFAULT 'iscp'")
SQL_ADD_COLUMN(DATABASE_NAME, "string_type", "TEXT DEFAULT 'role'")

if SQL_SELECT(DATABASE_NAME, "*", "uniqueID = 1") == nil then
	SQL_INSERT_INTO(DATABASE_NAME, "string_name, string_type", "'iscp', 'role'")
end

function AddCustomFlag(name, typ)
	if name != nil and typ != nil then
		local _found = SQL_SELECT(DATABASE_NAME, "*", "string_name = '" .. name .. "' AND string_type = '" .. typ .. "'")
		if !_found then
			SQL_INSERT_INTO(DATABASE_NAME, "string_name, string_type", "'" .. name .. "', '" .. typ .. "'")
			printGM("note", "Custom Flag " .. name .. " (" .. typ .. ") added.")
		else
			--printGM("note", "Custom Flag " .. name .. " (" .. typ .. ") already exists.")
		end
	end
end

AddCustomFlag("iscp", "role")
AddCustomFlag("ismayor", "role")
AddCustomFlag("ismedic", "role")
