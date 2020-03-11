--Copyright (C) 2017-2020 Arno Zura (https://www.gnu.org/licenses/gpl.txt)

printGM("gm", "Loading sv_includes.lua")

include("db/db_database.lua")

include("gm/sv_playerisready.lua")
include("gm/sv_gamemode.lua")
include("gm/sv_net.lua")
include("gm/sv_map.lua")
include("gm/sv_think.lua")
include("gm/sv_chat.lua")
include("gm/sv_teleport.lua")
include("gm/sv_startup.lua")

printGM("gm", "Loaded sv_includes.lua")
