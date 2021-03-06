--Copyright (C) 2017-2018 Arno Zura ( https://www.gnu.org/licenses/gpl.txt )

function combineTables( tab1, tab2 )
	for i, item in pairs( tab2 ) do
		table.insert( tab1, item )
	end
	for i, item in pairs( tab1 ) do
		if item == "" then
			table.RemoveByValue( tab1, "" )
		end
	end
	return tab1
end

function combineStringTables( str1, str2 )
	local _tab1 = string.Explode( ",", str1 )
	local _tab2 = string.Explode( ",", str2 )
	return combineTables( _tab1, _tab2 )
end

local _addons = engine.GetAddons()
local _wsids = {}
for i, add in pairs( _addons ) do
	table.insert( _wsids, add.wsid )
end

function GetWorkshopIDs()
	return _wsids
end

function SENTSTable( str )
  local se = string.Explode( ";", str )
  local tbl = {}
  for i, senttbl in pairs( se ) do
    if senttbl != "" then
      senttbl = string.Explode( ",", senttbl )
			if senttbl[1] != nil and senttbl[2] != nil then
      	tbl[senttbl[2]] = senttbl[1]
			end
    end
  end
  return tbl
end

function SENTSString( tbl )
	local str = ""
	local count = 0
  for cname, amount in pairs( tbl ) do
		if count < 1 then
    	str = str .. amount .. "," .. cname
		else
			str = str .. ";" .. amount .. "," .. cname
		end
		count = count + 1
  end
	return str
end
