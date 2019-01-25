--Copyright (C) 2017-2019 Arno Zura (https://www.gnu.org/licenses/gpl.txt)

CreateConVar("yrp_cl_hud", 1, {}, "")
--##############################################################################
--Resolution Change
hook.Add("Initialize", "Resolution Change", function()
	vgui.CreateFromTable {
		Base = "Panel",
		PerformLayout = function()
			hook.Run("ResolutionChanged", ScrW(), ScrH())
		end
	} : ParentToHUD()
end)

hook.Add("ResolutionChanged", "Resolution Change", function(w, h)
	local rw, rh = getResolutionRatio()
	printGM("gm", "Changed Resolution to " .. w .. "x" .. h .. " (" .. rw .. ":" .. rh .. ")")
	changeFontSize()
end)
--##############################################################################

--##############################################################################

function GM:DrawDeathNotice(x, y)
	--No Kill Feed
end

hook.Add("HUDShouldDraw", "yrp_hidehud", function(name)
	local hide = {
		CHudHealth = true,
		CHudBattery = true,
		CHudAmmo = true,
		CHudSecondaryAmmo = true,
		CHudCrosshair = LocalPlayer():GetNWBool("bool_yrp_crosshair", false),
		CHudVoiceStatus = false
	}

	if g_VoicePanelList != nil then
		g_VoicePanelList:SetVisible(false)
	end
	if (hide[ name ]) then return false end
end)

--##############################################################################

--##############################################################################
--includes
include("hud/cl_hud_map.lua")
include("hud/cl_hud_player.lua")
include("hud/cl_hud_view.lua")
include("hud/cl_hud_crosshair.lua")
--##############################################################################

Material("voice/icntlk_pl"):SetFloat("$alpha", 0)

function IsScreenshotting()
	if input.IsKeyDown(KEY_F12) or input.IsKeyDown(KEY_F5) then
		return true
	else
		return false
	end
end

function GM:PlayerStartVoice(pl)
	if pl != nil then
		if pl == LocalPlayer() then
			_showVoice = true
			net.Start("yrp_voice_start")
			net.SendToServer()
		end
		if pl.SteamID != nil then
			local stid = pl:SteamID()
			stid = stid or ""
			if stid == LocalPlayer():GetNWString("voice_global_steamid") and pl:GetNWInt("speak_channel", 0) == 2 then
				_showGlobalVoice = true
			end
		end
	end
end

function GM:PlayerEndVoice(pl)
	if pl == LocalPlayer() then
		_showVoice = false
		net.Start("yrp_voice_end")
		net.SendToServer()
	end
	local stid = pl:SteamID()
	stid = stid or ""
	if stid == LocalPlayer():GetNWString("voice_global_steamid") then
		_showGlobalVoice = false
	end
end

function show_global_voice_info(ply)
	if _showGlobalVoice then
		local _role_name = ply:GetNWString("voice_global_rolename", "")
		draw.SimpleTextOutlined(YRP.lang_string("LID_makesanannoucmentpre") .. " " .. _role_name .. " " .. YRP.lang_string("LID_makesanannoucmentpos") .. "!", "HudBars", ScrW2(), ctr(400), Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color(0, 0, 0))
	end
end

function show_voice_info(ply)
	--Voice
	if _showVoice then
		local _voice_text = YRP.lang_string("LID_youarespeaking") .. " ("
		if ply:GetNWInt("speak_channel", -1) == 1 then
			_voice_text = _voice_text .. YRP.lang_string("LID_speakgroup")
		elseif ply:GetNWInt("speak_channel", -1) == 2 then
			_voice_text = _voice_text .. YRP.lang_string("LID_speakglobal")
		else
			_voice_text = _voice_text .. YRP.lang_string("LID_speaklocal")
		end
		_voice_text = _voice_text .. ")"

		draw.SimpleTextOutlined(_voice_text, "HudBars", ScrW2(), ctr(500), Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color(0, 0, 0))
	end
end

local _yrp_icon = Material("vgui/yrp/logo100_beta.png")
local _yrp_testing = Material("yrp/warn_testing.png")
local star = Material("vgui/material/icon_star.png")

function DrawEquipment(ply, name)
	local _tmp = ply:GetNWEntity(name, NULL)
	if ea(_tmp) then
		if tonumber(ply:GetNWString("view_range", "0")) <= 0 then
			_tmp:SetNoDraw(true)
		else
			_tmp:SetNoDraw(false)
		end
	end
end

hook.Add("HUDPaint", "yrp_hud", function()
	local ply = LocalPlayer()

	if ply:GetNWBool("blinded", false) then
		surfaceBox(0, 0, ScrW(), ScrH(), Color(255, 255, 255, 255))
		surfaceText(YRP.lang_string("LID_blinded"), "SettingsHeader", ScrW2(), ScrH2() + ctr(100), Color(255, 255, 0, 255), 1, 1)
	end
	if ply:IsFlagSet(FL_FROZEN) then
		surfaceText(YRP.lang_string("LID_frozen"), "SettingsHeader", ScrW2(), ScrH2() + ctr(150), Color(255, 255, 0, 255), 1, 1)
	end
	if ply:GetNWBool("cloaked", false) then
		surfaceText(YRP.lang_string("LID_cloaked"), "SettingsHeader", ScrW2(), ScrH2() - ctr(400), Color(255, 255, 0, 255), 1, 1)
	end

	DrawEquipment(ply, "backpack")
	DrawEquipment(ply, "weaponprimary1")
	DrawEquipment(ply, "weaponprimary2")
	DrawEquipment(ply, "weaponsecondary1")
	DrawEquipment(ply, "weaponsecondary2")
	DrawEquipment(ply, "weapongadget")

	if !ply:InVehicle() then
		HudPlayer(ply)
		HudView()
		HudCrosshair()
	end

	show_voice_info(ply)
	show_global_voice_info(ply)

	if game.SinglePlayer() then
		draw.SimpleTextOutlined("[YourRP] " .. "DO NOT USE SINGLEPLAYER" .. "!", "72", ScrW2(), ScrH2(), Color(255, 0, 0, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, ctr(1), Color(0, 0, 0, 255))
	end

	local _target = LocalPlayer():GetNWString("hittargetName", "")
	if _target != "" then
		surfaceText(YRP.lang_string("LID_target") .. ": " .. LocalPlayer():GetNWString("hittargetName", ""), "HudBars", ctr(10), ctr(10), Color(255, 0, 0, 255), 0, 0)
		LocalPlayer():drawHitInfo()
	end

	if IsSpVisible() then
		local _br = {}
		_br.y = 50
		_br.x = 10

		local _r = 60

		local _sp = GetSpTable()

		draw.RoundedBox(ctrb(_r), _sp.x - _br.x, _sp.y - _br.y, _sp.w + 2 * _br.x, _sp.h + 2 * _br.y, getSpCaseColor())

		surface.SetDrawColor(255, 255, 255, 255)
		surface.SetMaterial(_yrp_icon	)
		surface.DrawTexturedRect(_sp.x + _sp.w / 2 - ctrb(246) / 2, _sp.y - ctrb(80 + 10), ctrb(246), ctrb(80))
	end

	if ply:GetNWBool("bool_wanted_system", false) and false then
		local stars = {}
		stars.size = ctr(80)
		stars.cur = stars.size
		stars.x = -ctr(32) + ScrW() - 6 * stars.size
		stars.y = ctr(32)

		-- Slot
		surface.SetDrawColor(0, 0, 0, 255)
		surface.SetMaterial(star)
		for x = 1, 5 do
			surface.DrawTexturedRect(stars.x + x * stars.size, stars.y, stars.cur, stars.cur)
		end

		stars.cur = ctr(60)
		stars.br = (stars.size - stars.cur) / 2
		surface.SetDrawColor(100, 100, 100, 255)
		for x = 1, 5 do
			surface.DrawTexturedRect(stars.x + x * stars.size + stars.br, stars.y + stars.br, stars.cur, stars.cur)
		end

		-- Current Stars
		surface.SetDrawColor(255, 255, 255, 255)
		for x = 1, 5 do
			if ply:GetNWInt("yrp_stars", 0) >= x then
				surface.DrawTexturedRect(stars.x + x * stars.size + stars.br, stars.y + stars.br, stars.cur, stars.cur)
			end
		end
	end

	if !ply:GetNWBool("serverdedicated", false) then
		if !string.find(tostring(_yrp_testing), "error") then
			local icon = {}
			icon.s = 165 * 2
			surface.SetDrawColor(255, 255, 255, 255)
			surface.SetMaterial(_yrp_testing	)
			surface.DrawTexturedRect(ScrW() - ctr(icon.s), 0, ctr(icon.s), ctr(icon.s))
		else
			draw.SimpleText("YOURRP CONTENT IS MISSING/OUTDATED!", "HudBars", ScrW2(), ScrH2(), Color(255, 255, 0, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		end
	end
end)
--##############################################################################
