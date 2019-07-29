--Copyright (C) 2017-2019 Arno Zura (https://www.gnu.org/licenses/gpl.txt)

-- DO NOT TOUCH THE DATABASE FILES! If you have errors, report them here:
-- https://discord.gg/sEgNZxg

local DATABASE_NAME_DOORS = "yrp_" .. GetMapNameDB() .. "_doors"
SQL_ADD_COLUMN(DATABASE_NAME_DOORS, "buildingID", "TEXT DEFAULT '-1'")
SQL_ADD_COLUMN(DATABASE_NAME_DOORS, "level", "INTEGER DEFAULT 1")
SQL_ADD_COLUMN(DATABASE_NAME_DOORS, "keynr", "INTEGER DEFAULT -1")

--db_drop_table(DATABASE_NAME_DOORS)
--db_is_empty(DATABASE_NAME_DOORS)

local DATABASE_NAME_BUILDINGS = "yrp_" .. GetMapNameDB() .. "_buildings"
SQL_ADD_COLUMN(DATABASE_NAME_BUILDINGS, "groupID", "INTEGER DEFAULT -1")
SQL_ADD_COLUMN(DATABASE_NAME_BUILDINGS, "buildingprice", "TEXT DEFAULT 100")
SQL_ADD_COLUMN(DATABASE_NAME_BUILDINGS, "ownerCharID", "TEXT DEFAULT ' '")
SQL_ADD_COLUMN(DATABASE_NAME_BUILDINGS, "name", "TEXT DEFAULT 'Building'")
SQL_ADD_COLUMN(DATABASE_NAME_BUILDINGS, "text_header", "TEXT DEFAULT ''")
SQL_ADD_COLUMN(DATABASE_NAME_BUILDINGS, "text_description", "TEXT DEFAULT ''")
--db_drop_table(DATABASE_NAME_BUILDINGS)
--db_is_empty(DATABASE_NAME_BUILDINGS)

function IsUnderGroup(uid, tuid)
	local group = SQL_SELECT("yrp_ply_groups", "*", "uniqueID = '" .. uid .. "'")
	group = group[1]
	local undergroup = SQL_SELECT("yrp_ply_groups", "*", "uniqueID = '" .. group.int_parentgroup .. "'")
	if wk(undergroup) then
		undergroup = undergroup[1]
		if undergroup.uniqueID == tuid then
			return true
		else
			return IsUnderGroup(undergroup.uniqueID, tuid)
		end
	end
	return false
end

function IsUnderGroupOf(ply, uid)
	local ply_group = SQL_SELECT("yrp_ply_groups", "*", "string_name = '" .. ply:GetGroupName() .. "'")
	ply_group = ply_group[1]
	local group = SQL_SELECT("yrp_ply_groups", "*", "uniqueID = '" .. ply_group.uniqueID .. "'")
	group = group[1]
	return IsUnderGroup(group.uniqueID, uid)
end
--[[
if wk(group) then
	group = group[1]
	local undergroup = SQL_SELECT("yrp_ply_groups", "*", "uniqueID = '" .. group.int_parentgroup .. "'")
	if wk(undergroup) then
		undergroup = undergroup[1]
		return GetFactionTable(undergroup.uniqueID)
	end
	return group
end
]]--

function allowedToUseDoor(id, ply)
	if ply:HasAccess() then
		return true
	else
		local _tmpBuildingTable = SQL_SELECT("yrp_" .. GetMapNameDB() .. "_buildings", "*", "uniqueID = '" .. id .. "'")
		if wk(_tmpBuildingTable) then

			if (tostring(_tmpBuildingTable[1].ownerCharID) == "" or tostring(_tmpBuildingTable[1].ownerCharID) == " ") and tonumber(_tmpBuildingTable[1].groupID) == -1 then
				return true
			else
				local _tmpChaTab = SQL_SELECT("yrp_characters", "*", "uniqueID = " .. _tmpBuildingTable[1].ownerCharID)
				if wk(_tmpChaTab) then
					local _tmpGroupTable = SQL_SELECT("yrp_ply_groups", "*", "uniqueID = " .. _tmpChaTab[1].groupID)

					if tostring(_tmpBuildingTable[1].ownerCharID) == tostring(ply:CharID()) or tonumber(_tmpBuildingTable[1].groupID) == tonumber(_tmpGroupTable[1].uniqueID) then
						return true
					elseif IsUnderGroupOf(ply, _tmpBuildingTable[1].groupID) then
						return true
					else
						printGM("note", "[allowedToUseDoor] not allowed")
						return false
					end
				else
					printGM("note", "[allowedToUseDoor] buildings database not available, maybe database corrupt: " .. tostring(_tmpChaTab))
					return false
				end
			end
		else
			printGM("note", "[allowedToUseDoor] not allowed 2")
			return false
		end
	end
end

function searchForDoors()
	printGM("db", "[Buildings] Search Map for Doors")

	local _allPropDoors = ents.FindByClass("prop_door_rotating")
	for k, v in pairs(_allPropDoors) do
		SQL_INSERT_INTO_DEFAULTVALUES("yrp_" .. GetMapNameDB() .. "_buildings")

		local _tmpBuildingTable = SQL_SELECT("yrp_" .. GetMapNameDB() .. "_buildings", "*", nil)
		if wk(_tmpBuildingTable) then
			SQL_INSERT_INTO("yrp_" .. GetMapNameDB() .. "_doors", "buildingID", "'" .. _tmpBuildingTable[#_tmpBuildingTable].uniqueID .. "'")

			local _tmpDoorsTable = SQL_SELECT("yrp_" .. GetMapNameDB() .. "_doors", "*", nil)
		end
	end

	local _allFuncDoors = ents.FindByClass("func_door")
	for k, v in pairs(_allFuncDoors) do
		SQL_INSERT_INTO_DEFAULTVALUES("yrp_" .. GetMapNameDB() .. "_buildings")

		local _tmpBuildingTable = SQL_SELECT("yrp_" .. GetMapNameDB() .. "_buildings", "*", nil)
		SQL_INSERT_INTO("yrp_" .. GetMapNameDB() .. "_doors", "buildingID", "'" .. _tmpBuildingTable[#_tmpBuildingTable].uniqueID .. "'")

		local _tmpDoorsTable = SQL_SELECT("yrp_" .. GetMapNameDB() .. "_doors", "*", nil)
	end

	local _allFuncRDoors = ents.FindByClass("func_door_rotating")
	for k, v in pairs(_allFuncRDoors) do
		SQL_INSERT_INTO_DEFAULTVALUES("yrp_" .. GetMapNameDB() .. "_buildings")

		local _tmpBuildingTable = SQL_SELECT("yrp_" .. GetMapNameDB() .. "_buildings", "*", nil)
		SQL_INSERT_INTO("yrp_" .. GetMapNameDB() .. "_doors", "buildingID", "'" .. _tmpBuildingTable[#_tmpBuildingTable].uniqueID .. "'")

		local _tmpDoorsTable = SQL_SELECT("yrp_" .. GetMapNameDB() .. "_doors", "*", nil)
	end

	printGM("db", "[Buildings] Done finding them (" .. #_allPropDoors+#_allFuncDoors+#_allFuncRDoors .. " doors found)")
	return #_allPropDoors+#_allFuncDoors+#_allFuncRDoors
end

util.AddNetworkString("loaded_doors")
function loadDoors()
	printGM("db", "[Buildings] Setting up Doors!")
	local _allPropDoors = ents.FindByClass("prop_door_rotating")
	local _allFuncDoors = ents.FindByClass("func_door")
	local _allFuncRDoors = ents.FindByClass("func_door_rotating")
	local _tmpDoors = SQL_SELECT("yrp_" .. GetMapNameDB() .. "_doors", "*", nil)
	local _count = 1

	if worked(_tmpDoors, "[Buildings] No Map Doors found") then
		--for k, v in pairs(_tmpDoors) do
			for l, door in pairs(_allPropDoors) do
				if worked(_tmpDoors[_count], "loadDoors 2") then
					door:SetDString("buildingID", _tmpDoors[_count].buildingID)
					door:SetDString("uniqueID", _count)
					HasUseFunction(door)
				else
					printGM("note", "[Buildings] more doors, then in list!")
				end
				_count = _count + 1
			end

			for l, door in pairs(_allFuncDoors) do
				if wk(_tmpDoors[_count]) then
					door:SetDString("buildingID", _tmpDoors[_count].buildingID)
					door:SetDString("uniqueID", _count)
					HasUseFunction(door)
				else
					printGM("note", "[Buildings] more doors, then in list!")
				end
				_count = _count + 1
			end

			for l, door in pairs(_allFuncRDoors) do
				if wk(_tmpDoors[_count]) then
					door:SetDString("buildingID", _tmpDoors[_count].buildingID)
					door:SetDString("uniqueID", _count)
					HasUseFunction(door)

				else
					printGM("note", "[Buildings] more doors, then in list!")
				end
				_count = _count + 1
			end
		--end
	end

	local _allDoors = {}
	for i, v in pairs(_allPropDoors) do
		table.insert(_allDoors, v)
	end
	for i, v in pairs(_allFuncDoors) do
		table.insert(_allDoors, v)
	end
	for i, v in pairs(_allFuncRDoors) do
		table.insert(_allDoors, v)
	end
	local _tmpBuildings = SQL_SELECT("yrp_" .. GetMapNameDB() .. "_buildings", "*", nil)
	if wk(_tmpBuildings) then
		for k, v in pairs(_allDoors) do
			for l, w in pairs(_tmpBuildings) do
				if tonumber(w.uniqueID) == tonumber(v:GetDString("buildingID")) then
					if !strEmpty(w.ownerCharID) then
						local _tmpRPName = SQL_SELECT("yrp_characters", "*", "uniqueID = " .. w.ownerCharID)
						if wk(_tmpRPName) then
							_tmpRPName = _tmpRPName[1]
							if wk(_tmpRPName.rpname) then
								v:SetDString("ownerRPName", _tmpRPName.rpname)
								v:SetDString("ownerCharID", w.ownerCharID)
							end
						end
					else
						if tonumber(w.groupID) != -1 then
							local _tmpGroupName = SQL_SELECT("yrp_ply_groups", "string_name", "uniqueID = " .. w.groupID)
							if wk(_tmpGroupName) then
								_tmpGroupName = _tmpGroupName[1]
								if wk(_tmpGroupName) then
									v:SetDString("ownerGroup", tostring(_tmpGroupName.string_name))
								end
							end
						end
					end

					if !strEmpty(w.text_header) then
						v:SetDString("text_header", w.text_header)
					end
					if !strEmpty(w.text_description) then
						v:SetDString("text_description", w.text_description)
					end

					break
				end
			end
		end
	end

	printGM("db", "[Buildings] Map Doors are now available!")
	SetGlobalBool("loaded_doors", true)
	net.Start("loaded_doors")
	net.Broadcast()
end

function check_map_doors()
	printGM("db", "[Buildings] Get Database Doors and Buildings")
	local _tmpTable = SQL_SELECT("yrp_" .. GetMapNameDB() .. "_doors", "*", nil)
	local _tmpTable2 = SQL_SELECT("yrp_" .. GetMapNameDB() .. "_buildings", "*", nil)
	if wk(_tmpTable) and wk(_tmpTable2) then
		printGM("db", "[Buildings] Found! (" .. tostring(#_tmpTable) .. " Doors | " .. tostring(#_tmpTable) .. " Buildings)")
		local _allPropDoors = ents.FindByClass("prop_door_rotating")
		local _allFuncDoors = ents.FindByClass("func_door")
		local _allFuncRDoors = ents.FindByClass("func_door_rotating")
		if (#_tmpTable) < (#_allPropDoors + #_allFuncDoors + #_allFuncRDoors) then
			printGM("db", "[Buildings] New doors found!")
			searchForDoors()
		end
	else
		searchForDoors()
	end

	loadDoors()
end

util.AddNetworkString("getBuildingInfo")
util.AddNetworkString("getBuildings")
util.AddNetworkString("changeBuildingName")
util.AddNetworkString("changeBuildingID")
util.AddNetworkString("changeBuildingPrice")

util.AddNetworkString("changeBuildingHeader")
util.AddNetworkString("changeBuildingDescription")

util.AddNetworkString("getBuildingGroups")

util.AddNetworkString("setBuildingOwnerGroup")

util.AddNetworkString("buyBuilding")
util.AddNetworkString("removeOwner")
util.AddNetworkString("sellBuilding")

util.AddNetworkString("lockDoor")

function canLock(ply, tab)
	if !strEmpty(tab.ownerCharID) then
		if tostring(ply:CharID()) == tostring(tab.ownerCharID) then
			return true
		end
		return false
	elseif tab.groupID != "-1" then
		if ply:GetDString("GroupUniqueID", "Failed") == tab.groupID then
			return true
		elseif IsUnderGroupOf(ply, tab.groupID) then
			return true
		end
		return false
	elseif (tab.ownerCharID == "" or tab.ownerCharID == " ") and tab.groupID == "-1" then
		return false
	else
		printGM("error", "canLock ELSE")
		return false
	end
end

function unlockDoor(ply, ent, nr)
	local _tmpBuildingTable = SQL_SELECT("yrp_" .. GetMapNameDB() .. "_buildings", "*", "uniqueID = '" .. nr .. "'")
	if wk(_tmpBuildingTable) then
		_tmpBuildingTable = _tmpBuildingTable[1]
		if canLock(ply, _tmpBuildingTable) then
			ent:Fire("Unlock")
			return true
		end
	else
		return false
	end
end

function lockDoor(ply, ent, nr)
	local _tmpBuildingTable = SQL_SELECT("yrp_" .. GetMapNameDB() .. "_buildings", "*", "uniqueID = '" .. nr .. "'")
	if wk(_tmpBuildingTable) then
		_tmpBuildingTable = _tmpBuildingTable[1]
		if canLock(ply, _tmpBuildingTable) then
			ent:Fire("Lock")
			return true
		end
	else
		return false
	end
end

function BuildingRemoveOwner(SteamID)
	YRP.msg("db", "BuildingRemoveOwner(" .. tostring(SteamID) .. ")")
	local chars = SQL_SELECT("yrp_characters", "*", "SteamID = '" .. SteamID .. "'")

	for i, c in pairs(chars) do
		local charid = c.uniqueID
		local _tmpDoors = ents.FindByClass("prop_door_rotating")
		for k, v in pairs(_tmpDoors) do
			if v:GetDString("ownerCharID") == charid then
				v:SetDString("ownerRPName", "")
				v:SetDString("ownerGroup", "")
				v:SetDString("ownerCharID", "")
				v:Fire("Unlock")
				SQL_UPDATE("yrp_" .. GetMapNameDB() .. "_buildings", "ownerCharID = ''", "uniqueID = '" .. v:GetDString("uniqueID") .. "'")
			end
		end
		local _tmpFDoors = ents.FindByClass("func_door")
		for k, v in pairs(_tmpFDoors) do
			if v:GetDString("ownerCharID") == charid then
				v:SetDString("ownerRPName", "")
				v:SetDString("ownerGroup", "")
				v:SetDString("ownerCharID", "")
				v:Fire("Unlock")
				SQL_UPDATE("yrp_" .. GetMapNameDB() .. "_buildings", "ownerCharID = ''", "uniqueID = '" .. v:GetDString("uniqueID") .. "'")
			end
		end
		local _tmpFRDoors = ents.FindByClass("func_door_rotating")
		for k, v in pairs(_tmpFRDoors) do
			if v:GetDString("ownerCharID") == charid then
				v:SetDString("ownerRPName", "")
				v:SetDString("ownerGroup", "")
				v:SetDString("ownerCharID", "")
				v:Fire("Unlock")
				SQL_UPDATE("yrp_" .. GetMapNameDB() .. "_buildings", "ownerCharID = ''", "uniqueID = '" .. v:GetDString("uniqueID") .. "'")
			end
		end
	end
end

net.Receive("removeOwner", function(len, ply)
	local _tmpBuildingID = net.ReadString()
	local _tmpTable = SQL_SELECT("yrp_" .. GetMapNameDB() .. "_buildings", "*", "uniqueID = '" .. _tmpBuildingID .. "'")

	local result = SQL_UPDATE("yrp_" .. GetMapNameDB() .. "_buildings", "ownerCharID = '', groupID = -1", "uniqueID = '" .. _tmpBuildingID .. "'")

	local _tmpDoors = ents.FindByClass("prop_door_rotating")
	for k, v in pairs(_tmpDoors) do
		if tonumber(v:GetDString("buildingID")) == tonumber(_tmpBuildingID) then
			v:SetDString("ownerRPName", "")
			v:SetDString("ownerGroup", "")
			v:SetDString("ownerCharID", "")
		end
	end
	local _tmpFDoors = ents.FindByClass("func_door")
	for k, v in pairs(_tmpFDoors) do
		if tonumber(v:GetDString("buildingID")) == tonumber(_tmpBuildingID) then
			v:SetDString("ownerRPName", "")
			v:SetDString("ownerGroup", "")
			v:SetDString("ownerCharID", "")
		end
	end
	local _tmpFRDoors = ents.FindByClass("func_door_rotating")
	for k, v in pairs(_tmpFRDoors) do
		if tonumber(v:GetDString("buildingID")) == tonumber(_tmpBuildingID) then
			v:SetDString("ownerRPName", "")
			v:SetDString("ownerGroup", "")
			v:SetDString("ownerCharID", "")
		end
	end
end)

net.Receive("sellBuilding", function(len, ply)
	local _tmpBuildingID = net.ReadString()
	local _tmpTable = SQL_SELECT("yrp_" .. GetMapNameDB() .. "_buildings", "*", "uniqueID = '" .. _tmpBuildingID .. "'")

	SQL_UPDATE("yrp_" .. GetMapNameDB() .. "_buildings", "ownerCharID = '', groupID = -1", "uniqueID = '" .. _tmpBuildingID .. "'")
	local _tmpDoors = ents.FindByClass("prop_door_rotating")

	for k, v in pairs(_tmpDoors) do
		if tonumber(v:GetDString("buildingID")) == tonumber(_tmpBuildingID) then
			v:SetDString("ownerRPName", "")
			v:SetDString("ownerGroup", "")
			v:SetDString("ownerCharID", "")
			v:Fire("Unlock")
			SQL_UPDATE("yrp_" .. GetMapNameDB() .. "_doors", "keynr = -1", "buildingID = " .. tonumber(v:GetDString("buildingID")))
		end
	end

	local _tmpFDoors = ents.FindByClass("func_door")

	for k, v in pairs(_tmpFDoors) do
		if tonumber(v:GetDString("buildingID")) == tonumber(_tmpBuildingID) then
			v:SetDString("ownerRPName", "")
			v:SetDString("ownerGroup", "")
			v:SetDString("ownerCharID", "")
			v:Fire("Unlock")
			SQL_UPDATE("yrp_" .. GetMapNameDB() .. "_doors", "keynr = -1", "buildingID = " .. tonumber(v:GetDString("buildingID")))
		end
	end

	local _tmpFRDoors = ents.FindByClass("func_door_rotating")

	for k, v in pairs(_tmpFRDoors) do
		if tonumber(v:GetDString("buildingID")) == tonumber(_tmpBuildingID) then
			v:SetDString("ownerRPName", "")
			v:SetDString("ownerGroup", "")
			v:SetDString("ownerCharID", "")
			v:Fire("Unlock")
			SQL_UPDATE("yrp_" .. GetMapNameDB() .. "_doors", "keynr = -1", "buildingID = " .. tonumber(v:GetDString("buildingID")))
		end
	end

	ply:addMoney(_tmpTable[1].buildingprice / 2)
end)

net.Receive("buyBuilding", function(len, ply)
	if GetGlobalDBool("bool_building_system", false) then
		local _tmpBuildingID = net.ReadString()
		local _tmpTable = SQL_SELECT("yrp_" .. GetMapNameDB() .. "_buildings", "*", "uniqueID = '" .. _tmpBuildingID .. "'")

		if ply:canAfford(_tmpTable[1].buildingprice) and (_tmpTable[1].ownerCharID == "" or _tmpTable[1].ownerCharID == " ") and tonumber(_tmpTable[1].groupID) == -1 then
			ply:addMoney(- (_tmpTable[1].buildingprice))
			SQL_UPDATE("yrp_" .. GetMapNameDB() .. "_buildings", "ownerCharID = '" .. ply:CharID() .. "'", "uniqueID = '" .. _tmpBuildingID .. "'")
			local _tmpDoors = ents.FindByClass("prop_door_rotating")
			local _tmpPlys = SQL_SELECT("yrp_characters", "rpname", "uniqueID = " .. ply:CharID())
			for k, v in pairs(_tmpDoors) do
				if tonumber(v:GetDString("buildingID")) == tonumber(_tmpBuildingID) then
					v:SetDString("ownerRPName", _tmpPlys[1].rpname)
					v:SetDString("ownerCharID", ply:CharID())
				end
			end
			local _tmpFDoors = ents.FindByClass("func_door")
			for k, v in pairs(_tmpFDoors) do
				if tonumber(v:GetDString("buildingID")) == tonumber(_tmpBuildingID) then
					v:SetDString("ownerRPName", _tmpPlys[1].rpname)
					v:SetDString("ownerCharID", ply:CharID())
				end
			end
			local _tmpFRDoors = ents.FindByClass("func_door_rotating")
			for k, v in pairs(_tmpFRDoors) do
				if tonumber(v:GetDString("buildingID")) == tonumber(_tmpBuildingID) then
					v:SetDString("ownerRPName", _tmpPlys[1].rpname)
					v:SetDString("ownerCharID", ply:CharID())
				end
			end

			printGM("gm", ply:RPName() .. " has buyed a door")
		else
			printGM("gm", ply:RPName() .. " has not enough money to buy door")
		end
	else
		printGM("note", "buildings disabled")
	end
end)

net.Receive("setBuildingOwnerGroup", function(len, ply)
	local _tmpBuildingID = net.ReadString()
	local _tmpGroupID = net.ReadInt(32)

	SQL_UPDATE("yrp_" .. GetMapNameDB() .. "_buildings", "groupID = " .. _tmpGroupID, "uniqueID = " .. _tmpBuildingID)

	local _tmpGroupName = SQL_SELECT("yrp_ply_groups", "string_name", "uniqueID = " .. _tmpGroupID)
	local _tmpDoors = ents.FindByClass("prop_door_rotating")
	for k, v in pairs(_tmpDoors) do
		if tonumber(v:GetDString("buildingID")) == tonumber(_tmpBuildingID) then
			v:SetDString("ownerGroup", _tmpGroupName[1].string_name)
		end
	end
	local _tmpFDoors = ents.FindByClass("func_door")
	for k, v in pairs(_tmpFDoors) do
		if tonumber(v:GetDString("buildingID")) == tonumber(_tmpBuildingID) then
			v:SetDString("ownerGroup", _tmpGroupName[1].string_name)
		end
	end
	local _tmpFRDoors = ents.FindByClass("func_door_rotating")
	for k, v in pairs(_tmpFRDoors) do
		if tonumber(v:GetDString("buildingID")) == tonumber(_tmpBuildingID) then
			v:SetDString("ownerGroup", _tmpGroupName[1].string_name)
		end
	end
end)

net.Receive("getBuildingGroups", function(len, ply)
	local _tmpTable = SQL_SELECT("yrp_ply_groups", "*", nil)

	net.Start("getBuildingGroups")
		net.WriteTable(_tmpTable)
	net.Send(ply)
end)

net.Receive("changeBuildingPrice", function(len, ply)
	local _tmpBuildingID = net.ReadString()
	local _tmpNewPrice = net.ReadString()
	_tmpNewPrice = tonumber(_tmpNewPrice) or 99

	local _result = SQL_UPDATE("yrp_" .. GetMapNameDB() .. "_buildings", "buildingprice = " .. _tmpNewPrice , "uniqueID = " .. _tmpBuildingID)
	worked(_result, "changeBuildingPrice failed")
end)


function hasDoors(id)
	local _allDoors = SQL_SELECT("yrp_" .. GetMapNameDB() .. "_doors", "*", nil)
	for k, v in pairs(_allDoors) do
		if tonumber(v.buildingID) == tonumber(id) then
			return true
		end
	end
	return false
end

function lookForEmptyBuildings()
	local _allBuildings = SQL_SELECT("yrp_" .. GetMapNameDB() .. "_buildings", "*", nil)

	for k, v in pairs(_allBuildings) do
		if !hasDoors(v.uniqueID) then
			SQL_DELETE_FROM("yrp_" .. GetMapNameDB() .. "_buildings", "uniqueID = " .. tonumber(v.uniqueID))
		end
	end
end

net.Receive("changeBuildingID", function(len, ply)
	local _tmpDoor = net.ReadEntity()
	local _tmpBuildingID = net.ReadString()

	_tmpDoor:SetDString("buildingID", _tmpBuildingID)
	SQL_UPDATE("yrp_" .. GetMapNameDB() .. "_doors", "buildingID = " .. tonumber(_tmpBuildingID) , "uniqueID = " .. _tmpDoor:GetDString("uniqueID"))

	lookForEmptyBuildings()
end)

net.Receive("changeBuildingName", function(len, ply)
	local _tmpBuildingID = net.ReadString()
	local _tmpNewName = net.ReadString()
	if wk(_tmpBuildingID) then
		printGM("note", "renamed Building: " .. _tmpNewName)
		SQL_UPDATE("yrp_" .. GetMapNameDB() .. "_buildings", "name = '" .. SQL_STR_IN(_tmpNewName) .. "'" , "uniqueID = " .. _tmpBuildingID)
	else
		printGM("note", "changeBuildingName failed")
	end
end)

function ChangeBuildingString(uid, net_str, new_str)
	local _allPropDoors = ents.FindByClass("prop_door_rotating")
	local _allFuncDoors = ents.FindByClass("func_door")
	local _allFuncRDoors = ents.FindByClass("func_door_rotating")

	local _allDoors = {}
	for i, v in pairs(_allPropDoors) do
		table.insert(_allDoors, v)
	end
	for i, v in pairs(_allFuncDoors) do
		table.insert(_allDoors, v)
	end
	for i, v in pairs(_allFuncRDoors) do
		table.insert(_allDoors, v)
	end

	for i, v in pairs(_allDoors) do
		if uid == tonumber(v:GetDString("buildingID")) then
			v:SetDString(net_str, new_str)
		end
	end
end

net.Receive("changeBuildingHeader", function(len, ply)
	local _tmpBuildingID = net.ReadString()
	local _tmpNewName = net.ReadString()
	if wk(_tmpBuildingID) then
		printGM("note", "header Building: " .. _tmpNewName)
		SQL_UPDATE("yrp_" .. GetMapNameDB() .. "_buildings", "text_header = '" .. SQL_STR_IN(_tmpNewName) .. "'" , "uniqueID = " .. _tmpBuildingID)
		ChangeBuildingString(tonumber(_tmpBuildingID), "text_header", _tmpNewName)
	else
		printGM("note", "changeBuildingName failed")
	end
end)

net.Receive("changeBuildingDescription", function(len, ply)
	local _tmpBuildingID = net.ReadString()
	local _tmpNewName = net.ReadString()
	if wk(_tmpBuildingID) then
		printGM("note", "description Building: " .. _tmpNewName)
		SQL_UPDATE("yrp_" .. GetMapNameDB() .. "_buildings", "text_description = '" .. SQL_STR_IN(_tmpNewName) .. "'" , "uniqueID = " .. _tmpBuildingID)
		ChangeBuildingString(tonumber(_tmpBuildingID), "text_description", _tmpNewName)
	else
		printGM("note", "changeBuildingName failed")
	end
end)

net.Receive("getBuildings", function(len, ply)
	local _tmpTable = SQL_SELECT("yrp_" .. GetMapNameDB() .. "_buildings", "*", nil)
	if wk(_tmpTable) then
		for k, building in pairs(_tmpTable) do
			building.name = SQL_STR_OUT(building.name)
		end
		net.Start("getBuildings")
			net.WriteTable(_tmpTable)
		net.Send(ply)
	end
end)

net.Receive("getBuildingInfo", function(len, ply)
	local _tmpDoor = net.ReadEntity()
	local _tmpBuildingID = _tmpDoor:GetDString("buildingID")

	if wk(_tmpBuildingID) then
		local _tmpTable = SQL_SELECT("yrp_" .. GetMapNameDB() .. "_buildings", "*", "uniqueID = '" .. _tmpBuildingID .. "'")
		local owner = ""
		if wk(_tmpTable) then
			_tmpTable = _tmpTable[1]
			_tmpTable.name = SQL_STR_OUT(_tmpTable.name)
			if !strEmpty(_tmpTable.ownerCharID) then
				local _tmpChaTab = SQL_SELECT("yrp_characters", "*", "uniqueID = " .. _tmpTable.ownerCharID)
				if wk(_tmpChaTab) then
					_tmpChaTab = _tmpChaTab[1]
					owner = _tmpChaTab.rpname
				end
			elseif _tmpTable.groupID != "" then
				local _tmpGroTab = SQL_SELECT("yrp_ply_groups", "*", "uniqueID = " .. _tmpTable.groupID)
				if wk(_tmpGroTab) then
					_tmpGroTab = _tmpGroTab[1]
					owner = _tmpGroTab.string_name
				end
			end

			if allowedToUseDoor(_tmpBuildingID, ply) then
				net.Start("getBuildingInfo")
					net.WriteBool(true)
					net.WriteEntity(_tmpDoor)
					net.WriteString(_tmpBuildingID)
					net.WriteTable(_tmpTable)
					net.WriteString(owner)
					net.WriteString(_tmpTable.text_header)
					net.WriteString(_tmpTable.text_description)
				net.Send(ply)
			end
		else
			printGM("note", "getBuildingInfo -> Building not found in Database.")
			net.Start("getBuildingInfo")
				net.WriteBool(false)
			net.Send(ply)
		end
	else
		printGM("note", "getBuildingInfo -> BuildingID is not valid")
	end
end)
