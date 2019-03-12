--[[
Copyright (C) 2017-2019 Arno Zura

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.	See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program.	If not, see < http://www.gnu.org/licenses/ >.
]]--

--[[ AddCSLuaFiles ]]--
AddCSLuaFile("shared.lua")
AddCSLuaFile("cl_init.lua")

AddCSLuaFile("yrp/cl/db/db_database.lua")
AddCSLuaFile("yrp/cl/db/db_keybinds.lua")
AddCSLuaFile("yrp/cl/db/db_fonts.lua")
AddCSLuaFile("yrp/cl/db/db_tutorials.lua")
AddCSLuaFile("yrp/cl/db/db_apps.lua")
AddCSLuaFile("yrp/cl/db/db_smartphone.lua")

AddCSLuaFile("yrp/cl/cl_includes.lua")
AddCSLuaFile("yrp/cl/gm/cl_playerisready.lua")
AddCSLuaFile("yrp/cl/gm/cl_startup.lua")
AddCSLuaFile("yrp/cl/gm/cl_hud.lua")
AddCSLuaFile("yrp/cl/gm/cl_chat.lua")
AddCSLuaFile("yrp/cl/gm/cl_think.lua")

AddCSLuaFile("yrp/cl/gm/huds/cl_hud_simple.lua")
AddCSLuaFile("yrp/cl/gm/huds/cl_hud_fallout76.lua")

AddCSLuaFile("yrp/cl/gm/interfaces/cl_if_simple.lua")

AddCSLuaFile("yrp/cl/gm/hud/cl_hud_crosshair.lua")
AddCSLuaFile("yrp/cl/gm/hud/cl_hud_map.lua")
AddCSLuaFile("yrp/cl/gm/hud/cl_hud_player.lua")
AddCSLuaFile("yrp/cl/gm/hud/cl_hud_view.lua")
AddCSLuaFile("yrp/cl/gm/menus/cl_feedback.lua")
AddCSLuaFile("yrp/cl/gm/menus/cl_help.lua")
AddCSLuaFile("yrp/cl/gm/menus/cl_buymenu.lua")
AddCSLuaFile("yrp/cl/gm/menus/cl_character.lua")
AddCSLuaFile("yrp/cl/gm/menus/cl_door_options.lua")
AddCSLuaFile("yrp/cl/gm/menus/cl_interact.lua")
AddCSLuaFile("yrp/cl/gm/menus/cl_inventory.lua")
AddCSLuaFile("yrp/cl/gm/menus/cl_appearance.lua")
AddCSLuaFile("yrp/cl/gm/menus/cl_rolesmenu.lua")
AddCSLuaFile("yrp/cl/gm/menus/cl_scoreboard.lua")
AddCSLuaFile("yrp/cl/gm/menus/cl_vehicle_options.lua")
AddCSLuaFile("yrp/cl/gm/menus/settings/cl_settings.lua")


AddCSLuaFile("yrp/cl/gm/menus/settings/cl_settings_server_console.lua")
AddCSLuaFile("yrp/cl/gm/menus/settings/cl_settings_server_status.lua")
AddCSLuaFile("yrp/cl/gm/menus/settings/cl_settings_server_feedback.lua")

AddCSLuaFile("yrp/cl/gm/menus/settings/cl_settings_server_general.lua")
AddCSLuaFile("yrp/cl/gm/menus/settings/cl_settings_server_realistic.lua")
AddCSLuaFile("yrp/cl/gm/menus/settings/cl_settings_server_groups_and_roles.lua")
AddCSLuaFile("yrp/cl/gm/menus/settings/cl_settings_server_levelsystem.lua")
AddCSLuaFile("yrp/cl/gm/menus/settings/cl_settings_server_design.lua")

AddCSLuaFile("yrp/cl/gm/menus/settings/cl_settings_server_database.lua")
AddCSLuaFile("yrp/cl/gm/menus/settings/cl_settings_server_usergroups.lua")

AddCSLuaFile("yrp/cl/gm/menus/settings/cl_settings_server_yourrp_addons.lua")

AddCSLuaFile("yrp/cl/gm/menus/settings/cl_settings_client_charakter.lua")
AddCSLuaFile("yrp/cl/gm/menus/settings/cl_settings_client_keybinds.lua")
AddCSLuaFile("yrp/cl/gm/menus/settings/cl_settings_server_give.lua")
AddCSLuaFile("yrp/cl/gm/menus/settings/cl_settings_server_map.lua")
AddCSLuaFile("yrp/cl/gm/menus/settings/cl_settings_server_licenses.lua")
AddCSLuaFile("yrp/cl/gm/menus/settings/cl_settings_server_shops.lua")
AddCSLuaFile("yrp/cl/gm/menus/settings/cl_settings_server_whitelist.lua")
AddCSLuaFile("yrp/cl/gm/menus/cl_smartphone.lua")
AddCSLuaFile("yrp/cl/gm/menus/cl_emotes.lua")
AddCSLuaFile("yrp/cl/gm/menus/cl_laws.lua")

AddCSLuaFile("yrp/cl/gm/apps/cl_app_settings_yrp.lua")
AddCSLuaFile("yrp/cl/gm/apps/cl_app_settings_sp.lua")
AddCSLuaFile("yrp/cl/gm/apps/cl_app_dark_web.lua")

AddCSLuaFile("yrp/cl/gm/designs/cl_d_material1.lua")
AddCSLuaFile("yrp/cl/gm/designs/cl_d_futuristic.lua")

--[[ includes ]]--
include("shared.lua")

include("yrp/sv/sv_includes.lua")
