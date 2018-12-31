--Copyright (C) 2017-2018 Arno Zura (https://www.gnu.org/licenses/gpl.txt)

-- DO NOT TOUCH THE DATABASE FILES! If you have errors, report them here:
-- https://discord.gg/sEgNZxg

local DATABASE_NAME = "yrp_ply_roles"

SQL_ADD_COLUMN(DATABASE_NAME, "string_name", "TEXT DEFAULT 'NewRole'")
SQL_ADD_COLUMN(DATABASE_NAME, "string_icon", "TEXT DEFAULT ''")
SQL_ADD_COLUMN(DATABASE_NAME, "string_usergroups", "TEXT DEFAULT 'ALL'")
SQL_ADD_COLUMN(DATABASE_NAME, "string_description", "TEXT DEFAULT '-'")
SQL_ADD_COLUMN(DATABASE_NAME, "string_playermodels", "TEXT DEFAULT ''")
SQL_ADD_COLUMN(DATABASE_NAME, "int_salary", "INTEGER DEFAULT 50")
SQL_ADD_COLUMN(DATABASE_NAME, "int_groupID", "INTEGER DEFAULT 1")
SQL_ADD_COLUMN(DATABASE_NAME, "string_color", "TEXT DEFAULT '0,0,0'")
SQL_ADD_COLUMN(DATABASE_NAME, "string_sweps", "TEXT DEFAULT ''")
SQL_ADD_COLUMN(DATABASE_NAME, "string_ndsweps", "TEXT DEFAULT ''")
SQL_ADD_COLUMN(DATABASE_NAME, "string_ammunation", "TEXT DEFAULT ''")
SQL_ADD_COLUMN(DATABASE_NAME, "bool_voteable", "INTEGER DEFAULT 0")
SQL_ADD_COLUMN(DATABASE_NAME, "bool_adminonly", "INTEGER DEFAULT 0")
SQL_ADD_COLUMN(DATABASE_NAME, "bool_whitelist", "INTEGER DEFAULT 0")
SQL_ADD_COLUMN(DATABASE_NAME, "int_maxamount", "INTEGER DEFAULT 0")
SQL_ADD_COLUMN(DATABASE_NAME, "int_amountpercentage", "INTEGER DEFAULT 100")
SQL_ADD_COLUMN(DATABASE_NAME, "int_hp", "INTEGER DEFAULT 100")
SQL_ADD_COLUMN(DATABASE_NAME, "int_hpmax", "INTEGER DEFAULT 100")
SQL_ADD_COLUMN(DATABASE_NAME, "int_hpup", "INTEGER DEFAULT 0")
SQL_ADD_COLUMN(DATABASE_NAME, "int_ar", "INTEGER DEFAULT 0")
SQL_ADD_COLUMN(DATABASE_NAME, "int_armax", "INTEGER DEFAULT 100")
SQL_ADD_COLUMN(DATABASE_NAME, "int_arup", "INTEGER DEFAULT 0")
SQL_ADD_COLUMN(DATABASE_NAME, "int_st", "INTEGER DEFAULT 50")
SQL_ADD_COLUMN(DATABASE_NAME, "int_stmax", "INTEGER DEFAULT 100")
SQL_ADD_COLUMN(DATABASE_NAME, "float_stup", "INTEGER DEFAULT 1")
SQL_ADD_COLUMN(DATABASE_NAME, "float_stdn", "INTEGER DEFAULT 0.5")

SQL_ADD_COLUMN(DATABASE_NAME, "string_abart", "TEXT DEFAULT 'mana'")
SQL_ADD_COLUMN(DATABASE_NAME, "int_ab", "INTEGER DEFAULT 50")
SQL_ADD_COLUMN(DATABASE_NAME, "int_abmax", "INTEGER DEFAULT 1000")
SQL_ADD_COLUMN(DATABASE_NAME, "float_abup", "INTEGER DEFAULT 5")

SQL_ADD_COLUMN(DATABASE_NAME, "int_speedwalk", "INTEGER DEFAULT 150")
SQL_ADD_COLUMN(DATABASE_NAME, "int_speedrun", "INTEGER DEFAULT 240")
SQL_ADD_COLUMN(DATABASE_NAME, "int_powerjump", "INTEGER DEFAULT 200")
SQL_ADD_COLUMN(DATABASE_NAME, "int_prerole", "INTEGER DEFAULT 0")
SQL_ADD_COLUMN(DATABASE_NAME, "bool_instructor", "INTEGER DEFAULT 0")
SQL_ADD_COLUMN(DATABASE_NAME, "bool_removeable", "INTEGER DEFAULT 1")
SQL_ADD_COLUMN(DATABASE_NAME, "int_uses", "INTEGER DEFAULT 0")
SQL_ADD_COLUMN(DATABASE_NAME, "int_salarytime", "INTEGER DEFAULT 120")
SQL_ADD_COLUMN(DATABASE_NAME, "bool_voiceglobal", "INTEGER DEFAULT 0")
SQL_ADD_COLUMN(DATABASE_NAME, "int_requireslevel", "INTEGER DEFAULT 1")

SQL_ADD_COLUMN(DATABASE_NAME, "bool_canbeagent", "INTEGER DEFAULT 0")
SQL_ADD_COLUMN(DATABASE_NAME, "bool_visible", "INTEGER DEFAULT 1")
SQL_ADD_COLUMN(DATABASE_NAME, "bool_locked", "INTEGER DEFAULT 0")

SQL_ADD_COLUMN(DATABASE_NAME, "string_licenses", "TEXT DEFAULT ''")

SQL_ADD_COLUMN(DATABASE_NAME, "string_customflags", "TEXT DEFAULT ''")

SQL_ADD_COLUMN(DATABASE_NAME, "int_position", "INTEGER DEFAULT 1")

if SQL_SELECT(DATABASE_NAME, "*", "uniqueID = 1") == nil then
	printGM("note", DATABASE_NAME .. " has not the default role")
	local _result = SQL_INSERT_INTO(DATABASE_NAME, "uniqueID, string_name, string_color, int_groupID, bool_removeable", "1, 'Civilian', '0,0,255', 1, 0")
end

SQL_UPDATE(DATABASE_NAME, "uses = 0", nil)

if wk(SQL_SELECT("yrp_roles", "*", nil)) then
	local wrongprerole = SQL_SELECT(DATABASE_NAME, "*", "int_prerole = '-1'")
	for i, role in pairs(wrongprerole) do
		SQL_UPDATE(DATABASE_NAME, "int_prerole = '0'", "uniqueID = '" .. role.uniqueID .. "'")
	end
end

function MoveUnusedRolesToDefault()
	printGM("note", "Move unused roles to default group")
	local allroles = SQL_SELECT("yrp_ply_roles", "*", nil)
	for i, role in pairs(allroles) do
		local group = SQL_SELECT("yrp_ply_groups", "*", "uniqueID = '" .. role.int_groupID .. "'")
		if !wk(group) then
			SQL_UPDATE(DATABASE_NAME, "int_groupID = '1', int_prerole = '0'", "uniqueID = '" .. role.uniqueID .. "'")
		end
	end
end

-- CONVERTING
if wk(SQL_SELECT("yrp_roles", "*", nil)) then
	printGM("note", "Converting OLD Roles into NEW Roles")
	local oldroles = SQL_SELECT("yrp_roles", "*", nil)
	for i, role in pairs(oldroles) do
		if tonumber(role.uniqueID) > 1 then
			local cols = "string_name,"
			cols = cols .. "string_description,"
			cols = cols .. "int_salary,"
			cols = cols .. "int_groupID,"
			cols = cols .. "string_sweps,"
			cols = cols .. "bool_voteable,"
			cols = cols .. "bool_adminonly,"
			cols = cols .. "bool_whitelist,"
			cols = cols .. "int_maxamount,"
			cols = cols .. "int_hp,"
			cols = cols .. "int_hpmax,"
			cols = cols .. "int_ar,"
			cols = cols .. "int_armax,"
			cols = cols .. "int_speedwalk,"
			cols = cols .. "int_speedrun,"
			cols = cols .. "int_powerjump,"
			cols = cols .. "int_prerole,"
			cols = cols .. "bool_instructor,"
			cols = cols .. "int_salarytime,"
			cols = cols .. "string_licenses"

			local vals = "'" .. role.roleID .. "', "
			vals = vals .. "'" .. role.description .. "', "
			vals = vals .. "'" .. role.salary .. "', "
			vals = vals .. "'" .. role.groupID .. "', "
			vals = vals .. "'" .. role.sweps .. "', "
			vals = vals .. "'" .. role.voteable .. "', "
			vals = vals .. "'" .. role.adminonly .. "', "
			vals = vals .. "'" .. role.whitelist .. "', "
			vals = vals .. "'" .. role.maxamount .. "', "
			vals = vals .. "'" .. role.hp .. "', "
			vals = vals .. "'" .. role.hpmax .. "', "
			vals = vals .. "'" .. role.ar .. "', "
			vals = vals .. "'" .. role.armax .. "', "
			vals = vals .. "'" .. role.speedwalk .. "', "
			vals = vals .. "'" .. role.speedrun .. "', "
			vals = vals .. "'" .. role.powerjump .. "', "
			vals = vals .. "'" .. role.prerole .. "', "
			vals = vals .. "'" .. role.instructor .. "', "
			vals = vals .. "'" .. role.salarytime ..	"', "
			vals = vals .. "'" .. role.licenseIDs .. "' "

			SQL_INSERT_INTO(DATABASE_NAME, cols, vals)
			SQL_DELETE_FROM("yrp_roles", "uniqueID = '" .. role.uniqueID .. "'")
		end
	end
	SQL_DROP_TABLE("yrp_roles")
end
-- CONVERTING

-- darkrp
function ConvertToDarkRPJob(tab)
	local _job = {}

	_job.name = tab.string_name
	local _pms = string.Explode(",", tab.string_playermodels)
	_job.model = _pms
	_job.description = tab.string_description
	local _weapons = string.Explode(",", tab.string_sweps)
	_job.weapons = _weapons
	_job.max = tonumber(tab.int_maxamount)
	_job.salary = tonumber(tab.int_salary)
	_job.admin = tonumber(tab.bool_adminonly) or 0
	_job.vote = tobool(tab.bool_voteable) or false
	if tab.string_licenses != "" then
		_job.hasLicense = true
	else
		_job.hasLicense = false
	end
	_job.candemote =	tobool(tab.bool_instructor) or false
	local gname = SQL_SELECT("yrp_ply_groups", "*", "uniqueID = '" .. tab.int_groupID .. "'")
	if wk(gname) then
		gname = gname[1].string_name
	end
	_job.category = gname or "invalid group"

	return _job
end

local drp_allroles = SQL_SELECT(DATABASE_NAME, "*", nil)
local TEAMS = {}
if wk(drp_allroles) then
	for i, role in pairs(drp_allroles) do
		local teamname = "TEAM_" .. role.string_name
		teamname = string.Replace(teamname, " ", "_")
		TEAMS[teamname] = ConvertToDarkRPJob(role)
		_G[teamname] = TEAMS["TEAM_" .. role.string_name]
	end
end

util.AddNetworkString("send_team")
function SendTeamsToPlayer(ply)
	for i, role in pairs(TEAMS) do
		net.Start("send_team")
			net.WriteString(i)
			net.WriteTable(role)
		net.Send(ply)
	end
end
-- darkrp

local yrp_ply_roles = {}
local _init_ply_roles = SQL_SELECT(DATABASE_NAME, "*", "uniqueID = '1'")
if wk(_init_ply_roles) then
	yrp_ply_roles = _init_ply_roles[1]
end

local HANDLER_GROUPSANDROLES = {}
HANDLER_GROUPSANDROLES["roleslist"] = {}
HANDLER_GROUPSANDROLES["roles"] = {}

for str, val in pairs(yrp_ply_roles) do
	if string.find(str, "string_") then
		local tab = {}
		tab.netstr = "update_role_" .. str
		util.AddNetworkString(tab.netstr)
		net.Receive(tab.netstr, function(len, ply)
			local uid = tonumber(net.ReadString())
			local s = net.ReadString()
			tab.ply = ply
			tab.id = str
			tab.value = s
			tab.db = DATABASE_NAME
			tab.uniqueID = uid
			UpdateString(tab)
			tab.handler = HANDLER_GROUPSANDROLES["roles"][tonumber(tab.uniqueID)]
			BroadcastString(tab)
			if tab.netstr == "update_role_string_name" then
				util.AddNetworkString("settings_role_update_name")
				local puid = SQL_SELECT(DATABASE_NAME, "*", "uniqueID = '" .. uid .. "'")
				if wk(puid) then
					puid = puid[1]
					tab.handler = HANDLER_GROUPSANDROLES["roleslist"][tonumber(puid.int_parentrole)]
					tab.netstr = "settings_role_update_name"
					tab.uniqueID = tonumber(puid.uniqueID)
					tab.force = true
					BroadcastString(tab)
				end
			elseif tab.netstr == "update_role_string_color" then
				util.AddNetworkString("settings_role_update_color")
				local puid = SQL_SELECT(DATABASE_NAME, "*", "uniqueID = '" .. uid .. "'")
				if wk(puid) then
					puid = puid[1]
					tab.handler = HANDLER_GROUPSANDROLES["roleslist"][tonumber(puid.int_parentrole)]
					tab.netstr = "settings_role_update_color"
					tab.uniqueID = tonumber(puid.uniqueID)
					tab.force = true
					BroadcastString(tab)
				end
			elseif tab.netstr == "update_role_string_icon" then
				util.AddNetworkString("settings_role_update_icon")
				local puid = SQL_SELECT(DATABASE_NAME, "*", "uniqueID = '" .. uid .. "'")
				if wk(puid) then
					puid = puid[1]
					tab.handler = HANDLER_GROUPSANDROLES["roleslist"][tonumber(puid.int_parentrole)]
					tab.netstr = "settings_role_update_icon"
					tab.uniqueID = tonumber(puid.uniqueID)
					tab.force = true
					BroadcastString(tab)
				end
			end
		end)
	elseif string.find(str, "int_") then
		local tab = {}
		tab.netstr = "update_role_" .. str
		util.AddNetworkString(tab.netstr)
		net.Receive(tab.netstr, function(len, ply)
			local uid = tonumber(net.ReadString())
			local int = tonumber(net.ReadString())
			local cur = SQL_SELECT(DATABASE_NAME, "*", "uniqueID = '" .. uid .. "'")
			tab.ply = ply
			tab.id = str
			tab.value = int
			tab.db = DATABASE_NAME
			tab.uniqueID = uid
			UpdateInt(tab)
			tab.handler = HANDLER_GROUPSANDROLES["roles"][tonumber(tab.uniqueID)]
			BroadcastInt(tab)
			if tab.netstr == "update_int_parentrole" then
				if wk(cur) then
					cur = cur[1]
					SendGroupList(tonumber(cur.int_parentrole))
				end
				SendGroupList(int)
			end
		end)
	elseif string.find(str, "float_") then
		local tab = {}
		tab.netstr = "update_role_" .. str
		util.AddNetworkString(tab.netstr)
		net.Receive(tab.netstr, function(len, ply)
			local uid = tonumber(net.ReadString())
			local float = tonumber(net.ReadString())
			local cur = SQL_SELECT(DATABASE_NAME, "*", "uniqueID = '" .. uid .. "'")
			tab.ply = ply
			tab.id = str
			tab.value = float
			tab.db = DATABASE_NAME
			tab.uniqueID = uid
			UpdateFloat(tab)
			tab.handler = HANDLER_GROUPSANDROLES["roles"][tonumber(tab.uniqueID)]
			BroadcastFloat(tab)
			if tab.netstr == "update_float_parentrole" then
				if wk(cur) then
					cur = cur[1]
					SendGroupList(tonumber(cur.float_parentrole))
				end
				SendGroupList(float)
			end
		end)
	elseif string.find(str, "bool_") then
		local tab = {}
		tab.netstr = "update_role_" .. str
		util.AddNetworkString(tab.netstr)
		net.Receive(tab.netstr, function(len, ply)
			local uid = tonumber(net.ReadString())
			local int = tonumber(net.ReadString())
			local cur = SQL_SELECT(DATABASE_NAME, "*", "uniqueID = '" .. uid .. "'")
			tab.ply = ply
			tab.id = str
			tab.value = int
			tab.db = DATABASE_NAME
			tab.uniqueID = uid
			UpdateInt(tab)
			tab.handler = HANDLER_GROUPSANDROLES["roles"][tonumber(tab.uniqueID)]
			BroadcastInt(tab)
			if tab.netstr == "update_int_parentrole" then
				if wk(cur) then
					cur = cur[1]
					SendGroupList(tonumber(cur.int_parentrole))
				end
				SendGroupList(int)
			end
		end)
	end
end

function SubscribeRoleList(ply, gro, pre)
	if HANDLER_GROUPSANDROLES["roleslist"][gro] == nil then
		HANDLER_GROUPSANDROLES["roleslist"][gro] = {}
	end
	if HANDLER_GROUPSANDROLES["roleslist"][gro][pre] == nil then
		HANDLER_GROUPSANDROLES["roleslist"][gro][pre] = {}
	end
	if !table.HasValue(HANDLER_GROUPSANDROLES["roleslist"][gro][pre], ply) then
		table.insert(HANDLER_GROUPSANDROLES["roleslist"][gro][pre], ply)
		printGM("gm", ply:YRPName() .. " subscribed to RoleList " .. gro .. " pre: " .. pre)
	else
		printGM("gm", ply:YRPName() .. " already subscribed to RoleList " .. gro.. " pre: " .. pre)
	end
end

function UnsubscribeRoleList(ply, gro, pre)
	if HANDLER_GROUPSANDROLES["roleslist"][gro] == nil then
		HANDLER_GROUPSANDROLES["roleslist"][gro] = {}
	end
	if HANDLER_GROUPSANDROLES["roleslist"][gro][pre] == nil then
		HANDLER_GROUPSANDROLES["roleslist"][gro][pre] = {}
	end
	if table.HasValue(HANDLER_GROUPSANDROLES["roleslist"][gro][pre], ply) then
		table.RemoveByValue(HANDLER_GROUPSANDROLES["roleslist"][gro][pre], ply)
		printGM("gm", ply:YRPName() .. " unsubscribed from RoleList " .. gro .. " pre: " .. pre)
	end
end

function SubscribeRole(ply, uid)
	if HANDLER_GROUPSANDROLES["roles"][uid] == nil then
		HANDLER_GROUPSANDROLES["roles"][uid] = {}
	end
	if !table.HasValue(HANDLER_GROUPSANDROLES["roles"][uid], ply) then
		table.insert(HANDLER_GROUPSANDROLES["roles"][uid], ply)
		printGM("gm", ply:YRPName() .. " subscribed to Role " .. uid)
	else
		printGM("gm", ply:YRPName() .. " already subscribed to Role " .. uid)
	end
end

function UnsubscribeRole(ply, uid)
	if HANDLER_GROUPSANDROLES["roles"][uid] == nil then
		HANDLER_GROUPSANDROLES["roles"][uid] = {}
	end
	if table.HasValue(HANDLER_GROUPSANDROLES["roles"][uid], ply) then
		table.RemoveByValue(HANDLER_GROUPSANDROLES["roles"][uid], ply)
		printGM("gm", ply:YRPName() .. " unsubscribed from Role " .. uid)
	end
end

function SortRoles(gro, pre)
	local siblings = SQL_SELECT(DATABASE_NAME, "*", "int_groupID = '" .. gro .. "' AND int_prerole = '" .. pre .. "'")

	if wk(siblings) then
		for i, sibling in pairs(siblings) do
			sibling.int_position = tonumber(sibling.int_position)
		end

		local count = 0
		for i, sibling in SortedPairsByMemberValue(siblings, "int_position", false) do
			count = count + 1
			SQL_UPDATE(DATABASE_NAME, "int_position = '" .. count .. "'", "uniqueID = '" .. sibling.uniqueID .. "'")
		end
	end
end

function SendRoleList(gro, pre)
	SortRoles(gro, pre)

	local tbl_roles = SQL_SELECT(DATABASE_NAME, "*", "int_groupID = '" .. gro .. "' AND int_prerole = '" .. pre .. "'")
	if !wk(tbl_roles) then
		tbl_roles = {}
	end

	local headername = "NOT FOUND"
	if pre > 0 then
		headername = SQL_SELECT(DATABASE_NAME, "*", "uniqueID = '" .. pre .. "'")
		headername = headername[1].string_name
	else
		headername = SQL_SELECT("yrp_ply_groups", "*", "uniqueID = '" .. gro .. "'")
		headername = headername[1].string_name
	end

	local tbl_bc = HANDLER_GROUPSANDROLES["roleslist"][gro][pre] or {}
	for i, pl in pairs(tbl_bc) do
		net.Start("settings_subscribe_rolelist")
			net.WriteTable(tbl_roles)
			net.WriteString(headername)
			net.WriteString(gro)
			net.WriteString(pre)
		net.Send(pl)
	end
end

-- Role menu
util.AddNetworkString("get_grp_roles")
net.Receive("get_grp_roles", function(len, ply)
	local _uid = net.ReadString()
	local _roles = SQL_SELECT(DATABASE_NAME, "*", "int_groupID = " .. _uid)
	for i, ro in pairs(_roles) do
		ro.string_playermodels = GetPlayermodelsOfRole(ro.uniqueID)
	end
	if _roles != nil then
		net.Start("get_grp_roles")
			net.WriteTable(_roles)
		net.Send(ply)
	else
		printGM("note", "Group [" .. _uid .. "] has no roles.")
	end
end)

util.AddNetworkString("get_rol_prerole")
net.Receive("get_rol_prerole", function(len, ply)
	local _uid = net.ReadString()
	local _roles = SQL_SELECT(DATABASE_NAME, "*", "int_prerole = " .. _uid)
	if wk(_roles) then
		for i, ro in pairs(_roles) do
			ro.string_playermodels = GetPlayermodelsOfRole(ro.uniqueID)
		end
		_roles = _roles[1]
		net.Start("get_rol_prerole")
			net.WriteTable(_roles)
		net.Send(ply)
	end
end)

-- Role Settings
util.AddNetworkString("settings_subscribe_rolelist")
net.Receive("settings_subscribe_rolelist", function(len, ply)
	local gro = tonumber(net.ReadString())
	local pre = tonumber(net.ReadString())

	SubscribeRoleList(ply, gro, pre)
	SendRoleList(gro, pre)
end)

util.AddNetworkString("settings_subscribe_prerolelist")
net.Receive("settings_subscribe_prerolelist", function(len, ply)
	local gro = tonumber(net.ReadString())
	local pre = tonumber(net.ReadString())

	pre = SQL_SELECT(DATABASE_NAME, "*", "uniqueID = '" .. pre .. "'")
	pre = tonumber(pre[1].int_prerole)
	SubscribeRoleList(ply, gro, pre)
	SendRoleList(gro, pre)
end)

util.AddNetworkString("settings_add_role")
net.Receive("settings_add_role", function(len, ply)
	local gro = tonumber(net.ReadString())
	local pre = tonumber(net.ReadString())
	SQL_INSERT_INTO(DATABASE_NAME, "int_groupID, int_prerole", "'" .. gro .. "', '" .. pre .. "'")

	local roles = SQL_SELECT(DATABASE_NAME, "*", "int_groupID = '" .. gro .. "' AND int_prerole = '" .. pre .. "'")

	local count = tonumber(table.Count(roles))
	local new_role = roles[count]
	local up = roles[count - 1]
	if count == 1 then
		SQL_UPDATE(DATABASE_NAME, "int_position = '" .. count .. "'", "uniqueID = '" .. new_role.uniqueID .. "'")
	else
		SQL_UPDATE(DATABASE_NAME, "int_position = '" .. count .. "', int_up = '" .. up.uniqueID .. "'", "uniqueID = '" .. new_role.uniqueID .. "'")
		SQL_UPDATE(DATABASE_NAME, "int_dn = '" .. new_role.uniqueID .. "'", "uniqueID = '" .. up.uniqueID .. "'")
	end

	printGM("db", "Added new role: " .. new_role.uniqueID)

	SendRoleList(gro, pre)
end)

util.AddNetworkString("settings_role_position_up")
net.Receive("settings_role_position_up", function(len, ply)
	local uid = tonumber(net.ReadString())
	local role = SQL_SELECT(DATABASE_NAME, "*", "uniqueID = '" .. uid .. "'")
	role = role[1]

	role.int_position = tonumber(role.int_position)

	local siblings = SQL_SELECT(DATABASE_NAME, "*", "int_groupID = '" .. role.int_groupID .. "'")

	for i, sibling in pairs(siblings) do
		sibling.int_position = tonumber(sibling.int_position)
	end

	local count = 0
	for i, sibling in SortedPairsByMemberValue(siblings, "int_position", false) do
		count = count + 1
		if tonumber(sibling.int_position) == role.int_position - 1 then
			SQL_UPDATE(DATABASE_NAME, "int_position = '" .. role.int_position .. "'", "uniqueID = '" .. sibling.uniqueID .. "'")
			SQL_UPDATE(DATABASE_NAME, "int_position = '" .. sibling.int_position .. "'", "uniqueID = '" .. uid .. "'")
		end
	end

	role.int_groupID = tonumber(role.int_groupID)
	role.int_prerole = tonumber(role.int_prerole)
	SendRoleList(role.int_groupID, role.int_prerole)
end)

util.AddNetworkString("settings_role_position_dn")
net.Receive("settings_role_position_dn", function(len, ply)
	local uid = tonumber(net.ReadString())
	local role = SQL_SELECT(DATABASE_NAME, "*", "uniqueID = '" .. uid .. "'")
	role = role[1]

	role.int_position = tonumber(role.int_position)

	local siblings = SQL_SELECT(DATABASE_NAME, "*", "int_groupID = '" .. role.int_groupID .. "'")

	for i, sibling in pairs(siblings) do
		sibling.int_position = tonumber(sibling.int_position)
	end

	local count = 0
	for i, sibling in SortedPairsByMemberValue(siblings, "int_position", false) do
		count = count + 1
		if tonumber(sibling.int_position) == role.int_position + 1 then
			SQL_UPDATE(DATABASE_NAME, "int_position = '" .. role.int_position .. "'", "uniqueID = '" .. sibling.uniqueID .. "'")
			SQL_UPDATE(DATABASE_NAME, "int_position = '" .. sibling.int_position .. "'", "uniqueID = '" .. uid .. "'")
		end
	end

	role.int_groupID = tonumber(role.int_groupID)
	role.int_prerole = tonumber(role.int_prerole)
	SendRoleList(role.int_groupID, role.int_prerole)
end)

util.AddNetworkString("settings_subscribe_role")
net.Receive("settings_subscribe_role", function(len, ply)
	local uid = tonumber(net.ReadString())
	SubscribeRole(ply, uid)

	local role = SQL_SELECT(DATABASE_NAME, "*", "uniqueID = '" .. uid .. "'")
	if !wk(role) then
		role = {}
	else
		role = role[1]
	end

	local roles = SQL_SELECT(DATABASE_NAME, "string_name, uniqueID", nil)
	if !wk(roles) then
		roles = {}
	end

	local usergroups = SQL_SELECT("yrp_usergroups", "*", nil)

	local groups = SQL_SELECT("yrp_ply_groups", "*", nil)

	net.Start("settings_subscribe_role")
		net.WriteTable(role)
		net.WriteTable(roles)
		net.WriteTable(usergroups)
		net.WriteTable(groups)
	net.Send(ply)
end)

util.AddNetworkString("settings_unsubscribe_role")
net.Receive("settings_unsubscribe_role", function(len, ply)
	local uid = tonumber(net.ReadString())
	UnsubscribeRole(ply, uid)
end)

util.AddNetworkString("settings_unsubscribe_rolelist")
net.Receive("settings_unsubscribe_rolelist", function(len, ply)
	local gro = tonumber(net.ReadString())
	local pre = tonumber(net.ReadString())
	UnsubscribeRoleList(ply, gro, pre)
end)

util.AddNetworkString("settings_delete_role")
net.Receive("settings_delete_role", function(len, ply)
	local uid = tonumber(net.ReadString())
	local role = SQL_SELECT(DATABASE_NAME, "*", "uniqueID = '" .. uid .. "'")
	if wk(role) then
		role = role[1]
		SQL_DELETE_FROM(DATABASE_NAME, "uniqueID = '" .. uid .. "'")

		local siblings = SQL_SELECT(DATABASE_NAME, "*", "int_groupID = '" .. role.int_groupID .. "'")
		if wk(siblings) then
			for i, sibling in pairs(siblings) do
				sibling.int_position = tonumber(sibling.int_position)
			end
			local count = 0
			for i, sibling in SortedPairsByMemberValue(siblings, "int_position", false) do
				count = count + 1
				SQL_UPDATE(DATABASE_NAME, "int_position = '" .. count .. "'", "uniqueID = '" .. sibling.uniqueID .. "'")
			end
		end

		role.int_groupID = tonumber(role.int_groupID)
		role.int_prerole = tonumber(role.int_prerole)
		SendRoleList(role.int_groupID, role.int_prerole)
	end
end)

util.AddNetworkString("getScoreboardGroups")
net.Receive("getScoreboardGroups", function(len, ply)
	local _tmpGroups = SQL_SELECT("yrp_ply_groups", "*", nil)
	if wk(_tmpGroups) then
		net.Start("getScoreboardGroups")
			net.WriteTable(_tmpGroups)
		net.Broadcast()
	else
		printGM("note", "getScoreboardGroups failed!")
		pTab(_tmpGroups)
	end
end)

function GetRole(uid)
	local role = SQL_SELECT(DATABASE_NAME, "*", "uniqueID = '" .. uid .. "'")
	if wk(role) then
		return role[1]
	end
	return nil
end

function SendCustomFlags(uid)
	local role = GetRole(uid)
	if wk(role) then
		local nettab = {}
		local flags = string.Explode(",", role.string_customflags)
		for i, val in pairs(flags) do
			local flag = SQL_SELECT("yrp_flags", "*", "uniqueID = '" .. val .. "'")
			if wk(flag) then
				flag = flag[1]
				local entry = {}
				entry.uniqueID = flag.uniqueID
				entry.string_name = flag.string_name
				table.insert(nettab, entry)
			end
		end

		for i, pl in pairs(HANDLER_GROUPSANDROLES["roles"][uid]) do
			net.Start("get_role_customflags")
				net.WriteTable(nettab)
			net.Send(pl)
		end
	end
end

util.AddNetworkString("get_role_customflags")
net.Receive("get_role_customflags", function(len, ply)
	local uid = net.ReadInt(32)
	SendCustomFlags(uid)
end)

util.AddNetworkString("get_all_role_customflags")
net.Receive("get_all_role_customflags", function(len, ply)
	local allflags = SQL_SELECT("yrp_flags", "*", "string_type = 'role'")
	if !wk(allflags) then
		allflags = {}
	end

	net.Start("get_all_role_customflags")
		net.WriteTable(allflags)
	net.Send(ply)
end)

util.AddNetworkString("add_role_flag")
net.Receive("add_role_flag", function(len, ply)
	local ruid = net.ReadInt(32)
	local fuid = net.ReadInt(32)
	role = GetRole(ruid)

	local customflags = string.Explode(",", role.string_customflags)
	if !table.HasValue(customflags, tostring(fuid)) then
		local oldflags = {}
		for i, v in pairs(customflags) do
			if v != "" then
				table.insert(oldflags, v)
			end
		end

		local newflags = oldflags
		table.insert(newflags, fuid)
		newflags = string.Implode(",", newflags)

		SQL_UPDATE(DATABASE_NAME, "string_customflags = '" .. newflags .. "'", "uniqueID = '" .. ruid .. "'")
		SendCustomFlags(ruid)
	end
end)

util.AddNetworkString("rem_role_flag")
net.Receive("rem_role_flag", function(len, ply)
	local ruid = net.ReadInt(32)
	local fuid = net.ReadInt(32)
	role = GetRole(ruid)

	local customflags = string.Explode(",", role.string_customflags)
	local oldflags = {}
	for i, v in pairs(customflags) do
		if v != "" then
			table.insert(oldflags, v)
		end
	end

	local newflags = oldflags
	table.RemoveByValue(newflags, tostring(fuid))
	newflags = string.Implode(",", newflags)

	SQL_UPDATE(DATABASE_NAME, "string_customflags = '" .. newflags .. "'", "uniqueID = '" .. ruid .. "'")
	SendCustomFlags(ruid)
end)

function SendPlayermodels(uid)
	local role = GetRole(uid)
	if wk(role) then
		local nettab = {}
		local flags = string.Explode(",", role.string_playermodels)
		for i, val in pairs(flags) do
			local pm = SQL_SELECT("yrp_playermodels", "*", "uniqueID = '" .. val .. "'")
			if wk(pm) then
				pm = pm[1]
				local entry = {}
				entry.uniqueID = pm.uniqueID
				local name = pm.string_name
				if name == "" or	name == " " then
					name = pm.string_model
				end
				entry.string_name = name
				entry.string_model = pm.string_model
				table.insert(nettab, entry)
			end
		end

		for i, pl in pairs(HANDLER_GROUPSANDROLES["roles"][uid]) do
			net.Start("get_role_playermodels")
				net.WriteTable(nettab)
			net.Send(pl)
		end
	end
end

util.AddNetworkString("get_role_playermodels")
net.Receive("get_role_playermodels", function(len, ply)
	local uid = net.ReadInt(32)
	SendPlayermodels(uid)
end)

util.AddNetworkString("get_all_playermodels")
net.Receive("get_all_playermodels", function(len, ply)
	local allpms = SQL_SELECT("yrp_playermodels", "*", nil)
	if !wk(allpms) then
		allpms = {}
	end
	net.Start("get_all_playermodels")
		net.WriteTable(allpms)
	net.Send(ply)
end)

function AddPlayermodelToRole(ruid, muid)
	role = GetRole(ruid)
	local pms = string.Explode(",", role.string_playermodels)
	if !table.HasValue(pms, tostring(muid)) then
		local oldpms = {}
		for i, v in pairs(pms) do
			if v != "" and v != " " then
				table.insert(oldpms, v)
			end
		end

		local newpms = oldpms
		table.insert(newpms, tostring(muid))
		newpms = string.Implode(",", newpms)

		SQL_UPDATE(DATABASE_NAME, "string_playermodels = '" .. newpms .. "'", "uniqueID = '" .. ruid .. "'")
		SendPlayermodels(ruid)
	end
end

util.AddNetworkString("add_role_playermodel")
net.Receive("add_role_playermodel", function(len, ply)
	local ruid = net.ReadInt(32)
	local muid = net.ReadInt(32)

	AddPlayermodelToRole(ruid, muid)
end)

util.AddNetworkString("add_playermodel")
net.Receive("add_playermodel", function(len, ply)
	local ruid = net.ReadInt(32)
	local WorldModel = net.ReadString()
	SQL_INSERT_INTO("yrp_playermodels", "string_model", "'" .. WorldModel .. "'")

	local lastentry = SQL_SELECT("yrp_playermodels", "*", nil)
	lastentry = lastentry[table.Count(lastentry)]
	AddPlayermodelToRole(ruid, lastentry.uniqueID)
end)

function RemPlayermodelFromRole(ruid, muid)
	role = GetRole(ruid)
	local pms = string.Explode(",", role.string_playermodels)
	local oldpms = {}
	for i, v in pairs(pms) do
		if v != "" and v != " " then
			table.insert(oldpms, v)
		end
	end

	local newpms = oldpms
	table.RemoveByValue(newpms, tostring(muid))
	newpms = string.Implode(",", newpms)

	SQL_UPDATE(DATABASE_NAME, "string_playermodels = '" .. newpms .. "'", "uniqueID = '" .. ruid .. "'")
	SendPlayermodels(ruid)
end

util.AddNetworkString("rem_role_playermodel")
net.Receive("rem_role_playermodel", function(len, ply)
	local ruid = net.ReadInt(32)
	local muid = net.ReadInt(32)

	RemPlayermodelFromRole(ruid, muid)
end)

function SendSweps(uid)
	local role = GetRole(uid)
	if wk(role) then
		local nettab = {}
		local sweps = string.Explode(",", role.string_sweps)
		for i, swep in pairs(sweps) do
			if swep != "" and swep != " " then
				table.insert(nettab, swep)
			end
		end

		for i, pl in pairs(HANDLER_GROUPSANDROLES["roles"][uid]) do
			net.Start("get_role_sweps")
				net.WriteTable(nettab)
			net.Send(pl)
		end
	end
end

util.AddNetworkString("get_role_sweps")
net.Receive("get_role_sweps", function(len, ply)
	local uid = net.ReadInt(32)
	SendSweps(uid)
end)

function AddSwepToRole(ruid, swepcn)
	role = GetRole(ruid)
	local sweps = string.Explode(",", role.string_sweps)
	if !table.HasValue(sweps, tostring(swepcn)) then
		local oldsweps = {}
		for i, v in pairs(sweps) do
			if v != "" and v != " " then
				table.insert(oldsweps, v)
			end
		end

		local newsweps = oldsweps
		table.insert(newsweps, tostring(swepcn))
		newsweps = string.Implode(",", newsweps)

		SQL_UPDATE(DATABASE_NAME, "string_sweps = '" .. newsweps .. "'", "uniqueID = '" .. ruid .. "'")
		SendSweps(ruid)
	end
end

util.AddNetworkString("add_role_swep")
net.Receive("add_role_swep", function(len, ply)
	local ruid = net.ReadInt(32)
	local swepcn = net.ReadString()

	AddSwepToRole(ruid, swepcn)
end)

function RemSwepFromRole(ruid, swepcn)
	role = GetRole(ruid)
	local sweps = string.Explode(",", role.string_sweps)
	local oldsweps = {}
	for i, v in pairs(sweps) do
		if v != "" and v != " " then
			table.insert(oldsweps, v)
		end
	end

	local newsweps = oldsweps
	table.RemoveByValue(newsweps, tostring(swepcn))
	newsweps = string.Implode(",", newsweps)

	SQL_UPDATE(DATABASE_NAME, "string_sweps = '" .. newsweps .. "'", "uniqueID = '" .. ruid .. "'")
	SendSweps(ruid)
end

util.AddNetworkString("rem_role_swep")
net.Receive("rem_role_swep", function(len, ply)
	local ruid = net.ReadInt(32)
	local swepcn = net.ReadString()

	RemSwepFromRole(ruid, swepcn)
end)

--not droppable sweps
function SendNDSweps(uid)
	local role = GetRole(uid)
	if wk(role) then
		local nettab = {}
		local ndsweps = string.Explode(",", role.string_ndsweps)
		for i, ndswep in pairs(ndsweps) do
			if ndswep != "" and ndswep != " " then
				table.insert(nettab, ndswep)
			end
		end

		for i, pl in pairs(HANDLER_GROUPSANDROLES["roles"][uid]) do
			net.Start("get_role_ndsweps")
				net.WriteTable(nettab)
			net.Send(pl)
		end
	end
end

util.AddNetworkString("get_role_ndsweps")
net.Receive("get_role_ndsweps", function(len, ply)
	local uid = net.ReadInt(32)
	SendNDSweps(uid)
end)

function AddNDSwepToRole(ruid, ndswepcn)
	role = GetRole(ruid)
	local ndsweps = string.Explode(",", role.string_ndsweps)
	if !table.HasValue(ndsweps, tostring(ndswepcn)) then
		local oldndsweps = {}
		for i, v in pairs(ndsweps) do
			if v != "" and v != " " then
				table.insert(oldndsweps, v)
			end
		end

		local newndsweps = oldndsweps
		table.insert(newndsweps, tostring(ndswepcn))
		newndsweps = string.Implode(",", newndsweps)

		SQL_UPDATE(DATABASE_NAME, "string_ndsweps = '" .. newndsweps .. "'", "uniqueID = '" .. ruid .. "'")
		SendNDSweps(ruid)
	end
end

util.AddNetworkString("add_role_ndswep")
net.Receive("add_role_ndswep", function(len, ply)
	local ruid = net.ReadInt(32)
	local ndswepcn = net.ReadString()

	AddNDSwepToRole(ruid, ndswepcn)
end)

function RemNDSwepFromRole(ruid, ndswepcn)
	role = GetRole(ruid)
	local ndsweps = string.Explode(",", role.string_ndsweps)
	local oldndsweps = {}
	for i, v in pairs(ndsweps) do
		if v != "" and v != " " then
			table.insert(oldndsweps, v)
		end
	end

	local newndsweps = oldndsweps
	table.RemoveByValue(newndsweps, tostring(ndswepcn))
	newndsweps = string.Implode(",", newndsweps)

	SQL_UPDATE(DATABASE_NAME, "string_ndsweps = '" .. newndsweps .. "'", "uniqueID = '" .. ruid .. "'")
	SendNDSweps(ruid)
end

util.AddNetworkString("rem_role_ndswep")
net.Receive("rem_role_ndswep", function(len, ply)
	local ruid = net.ReadInt(32)
	local ndswepcn = net.ReadString()

	RemNDSwepFromRole(ruid, ndswepcn)
end)

util.AddNetworkString("openInteractMenu")
net.Receive("openInteractMenu", function(len, ply)
	local tmpTargetSteamID = net.ReadString()

	local tmpTarget = nil
	for k, v in pairs(player.GetAll()) do
		if v:SteamID() == tmpTargetSteamID then
			tmpTarget = v
		end
	end
	if ea(tmpTarget) then
		if tmpTarget:IsPlayer() then
			local tmpTargetChaTab = tmpTarget:GetChaTab()
			if tmpTargetChaTab != nil then
				local tmpTargetRole = SQL_SELECT("yrp_ply_roles", "*", "uniqueID = " .. tmpTargetChaTab.roleID)

				local tmpT = ply:GetChaTab()
				local tmpTable = ply:GetRolTab()
				if wk(tmpT) and wk(tmpTable) then
					local tmpBool = false

					local tmpPromote = false
					local tmpPromoteName = ""

					local tmpDemote = false
					local tmpDemoteName = ""

					if tonumber(tmpTable.instructor) == 1 then
						tmpBool = true

						local tmpSearch = true	--tmpTargetSteamID
						local tmpTableSearch = SQL_SELECT("yrp_ply_roles", "*", "uniqueID = " .. tmpTable.int_prerole)
						if tmpTableSearch != nil then
							local tmpSearchUniqueID = tmpTableSearch[1].int_prerole
							local tmpCounter = 0
							while (tmpSearch) do
								tmpSearchUniqueID = tonumber(tmpTableSearch[1].int_prerole)

								if tonumber(tmpTargetRole[1].int_prerole) != -1 and tmpTableSearch[1].uniqueID == tmpTargetRole[1].uniqueID then
									tmpDemote = true
									local tmp = SQL_SELECT("yrp_ply_roles", "*", "uniqueID = " .. tmpTargetRole[1].int_prerole)
									tmpDemoteName = tmp[1].string_name
								end

								if tonumber(tmpSearchUniqueID) == tonumber(tmpTargetRole[1].uniqueID) then
									tmpPromote = true
									tmpPromoteName = tmpTableSearch[1].string_name
								end
								if tmpSearchUniqueID == -1 then
									tmpSearch = false
								end
								if tmpCounter >= 100 then
									printGM("note", "You have a loop in your preroles!")
									tmpSearch = false
								end
								tmpCounter = tmpCounter + 1
								tmpTableSearch = SQL_SELECT("yrp_ply_roles", "*", "uniqueID = " .. tmpSearchUniqueID)
							end
						end
					end

					net.Start("openInteractMenu")
						net.WriteBool(tmpBool)

						net.WriteBool(tmpPromote)
						net.WriteString(tmpPromoteName)

						net.WriteBool(tmpDemote)
						net.WriteString(tmpDemoteName)

					net.Send(ply)
				end
			end
		end
	end
end)
