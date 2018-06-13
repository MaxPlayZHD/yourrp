--Copyright (C) 2017-2018 Arno Zura ( https://www.gnu.org/licenses/gpl.txt )

function createFont( _name, _font, _size, __weight, _outline, _shadow )
	--printGM( "db", "createFont: " .. _name )
	--printGM( "db", _font .. ", " .. _size .. ", " .. __weight )
	_size = ctr( _size*2 )
	surface.CreateFont( _name, {
		font = _font, -- Use the font-name which is shown to you by your operating system Font Viewer, not the file name
		extended = true,
		size = _size,
		weight = __weight,
		blursize = 0,
		scanlines = 0,
		antialias = true,
		underline = false,
		italic = false,
		strikeout = false,
		symbol = false,
		rotary = false,
		shadow = _shadow or false,
		additive = false,
		outline = _outline or false
	} )
end

local tmpFont = "Roboto"
local _weight = 500

function changeFontSizeOf( _font, _size )
	printGM( "note", "changeFontSizeOf" .. _font .. _size)
	createFont( _font, tmpFont, _size, weight, false )
end

function update_db_fonts()
	createFont( "mmsf", tmpFont, HudV("mmsf"), _weight, false )
	createFont( "hpsf", tmpFont, HudV("hpsf"), _weight, false )
	createFont( "arsf", tmpFont, HudV("arsf"), _weight, false )
	createFont( "wpsf", tmpFont, HudV("wpsf"), _weight, false )
	createFont( "wssf", tmpFont, HudV("wssf"), _weight, false )
	createFont( "wnsf", tmpFont, HudV("wnsf"), _weight, false )
	createFont( "ttsf", tmpFont, HudV("ttsf"), _weight, false )
	createFont( "mosf", tmpFont, HudV("mosf"), _weight, false )
	createFont( "mhsf", tmpFont, HudV("mhsf"), _weight, false )
	createFont( "mtsf", tmpFont, HudV("mtsf"), _weight, false )
	createFont( "mssf", tmpFont, HudV("mssf"), _weight, false )
	createFont( "vtsf", tmpFont, HudV("vtsf"), _weight, false )
	createFont( "cbsf", tmpFont, HudV("cbsf"), _weight, false )
	createFont( "masf", tmpFont, HudV("masf"), _weight, false )
	createFont( "casf", tmpFont, HudV("casf"), _weight, false )
	createFont( "stsf", tmpFont, HudV("stsf"), _weight, false )
	createFont( "xpsf", tmpFont, HudV("xpsf"), _weight, false )
	createFont( "utsf", tmpFont, HudV("utsf"), _weight, false )
	createFont( "blsf", tmpFont, HudV("utsf"), _weight, false )
	createFont( "rtsf", tmpFont, HudV("utsf"), _weight, false )
end

function changeFontSize()
	printGM( "db", "changeFontSize" )

	--[[ DESIGNS ]]--
	createFont( "mat1header", tmpFont, 22, _weight, false )
	createFont( "mat1text", tmpFont, 18, 0, false )

	--[[ EMOTES ]]--
	createFont( "emotes", tmpFont, 22, _weight, false )

	--[[ 3D2D ]]--
	createFont( "3d2d_string", tmpFont, 22, _weight, false )

	--[[ Settings ]]--
	createFont( "Settings_Normal", tmpFont, 22, _weight, false )
	createFont( "Settings_Header", tmpFont, 26, _weight, false )

	createFont( "apph1", tmpFont, fontr( 36 ), _weight, false )
	createFont( "appt", tmpFont, fontr( 30 ), _weight, false )

	createFont( "appname", tmpFont, ctrb( 28 ), _weight, false )

	createFont( "plates", tmpFont, 30, _weight, false )
	createFont( "plyinfo", tmpFont, 18, _weight, false )

	createFont( "mdMenu", tmpFont, 17, 1000, false )

	createFont( "windowTitle", tmpFont, 18, 1000, false )

	createFont( "HudSettings", tmpFont, 24, _weight, false )

	createFont( "HudDefault", tmpFont, 72, _weight, false )

	createFont( "SettingsNormal", tmpFont, 24, _weight, false )
	createFont( "SettingsHeader", tmpFont, 30, _weight, false )

	createFont( "roleInfoHeader", tmpFont, 24, _weight, false )
	createFont( "roleInfoText", tmpFont, 20, _weight, false )

	createFont( "charTitle", tmpFont, 20, 800, false )
	createFont( "charHeader", tmpFont, 20, 800, false )
	createFont( "charText", tmpFont, 20, 800, false )

	createFont( "pmT", tmpFont, 18, _weight, false )
	createFont( "weaponT", tmpFont, 14, _weight, false )

	createFont( "HudBars", tmpFont, 24, _weight, false )
	createFont( "HudHeader", tmpFont, 36, _weight, false )
	createFont( "HudVersion", tmpFont, 30, 1000, false )

	createFont( "72", tmpFont, 72, _weight, false )
	--Creating
	createFont( "mmsf", tmpFont, 24, _weight, false )
	createFont( "hpsf", tmpFont, 24, _weight, false )
	createFont( "arsf", tmpFont, 24, _weight, false )
	createFont( "wpsf", tmpFont, 24, _weight, false )
	createFont( "wssf", tmpFont, 24, _weight, false )
	createFont( "wnsf", tmpFont, 24, _weight, false )
	createFont( "ttsf", tmpFont, 24, _weight, false )
	createFont( "mosf", tmpFont, 24, _weight, false )
	createFont( "mhsf", tmpFont, 24, _weight, false )
	createFont( "mtsf", tmpFont, 24, _weight, false )
	createFont( "mssf", tmpFont, 24, _weight, false )
	createFont( "vtsf", tmpFont, 24, _weight, false )
	createFont( "cbsf", tmpFont, 24, _weight, false )
	createFont( "masf", tmpFont, 24, _weight, false )
	createFont( "casf", tmpFont, 24, _weight, false )
	createFont( "stsf", tmpFont, 24, _weight, false )
	createFont( "xpsf", tmpFont, 24, _weight, false )
	createFont( "utsf", tmpFont, 24, _weight, false )
	createFont( "blsf", tmpFont, 24, _weight, false )
	createFont( "rtsf", tmpFont, 24, _weight, false )

	createFont( "sef", tmpFont, 24, 1, false )

	timer.Create( "createFontDB", 0.1, 0, function()
		if is_hud_db_loaded() then
			--Changing to right values
			update_db_fonts()

			printGM( "db", "HUD Fonts loaded." )

			timer.Remove( "createFontDB" )
		end
	end)

	createFont( "ScoreBoardTitle", tmpFont, 24, _weight, false )
	createFont( "ScoreBoardNormal", tmpFont, 20, _weight, false )

	createFont( "ATM_Header", tmpFont, 80, _weight, false )
	createFont( "ATM_Normal", tmpFont, 60, _weight, false )
	createFont( "ATM_Name", tmpFont, 40, _weight, false )

	--DarkRP Fonts
	createFont( "DarkRPHUD1", tmpFont, 16, _weight, false )
	createFont( "DarkRPHUD2", tmpFont, 24, _weight, false )
	createFont( "Trebuchet18", tmpFont, 16, _weight, false )
	createFont( "Trebuchet20", tmpFont, 20, _weight, false )
	createFont( "Trebuchet24", tmpFont, 24, _weight, false )
	createFont( "Trebuchet48", tmpFont, 48, _weight, false )
	createFont( "TabLarge", tmpFont, 16, 700, false )
	createFont( "UiBold", tmpFont, 16, 800, false )
	createFont( "HUDNumber5", tmpFont, 30, 800, false )
	createFont( "ScoreboardHeader", tmpFont, 32, _weight, false )
	createFont( "ScoreboardSubtitle", tmpFont, 24, _weight, false )
	createFont( "ScoreboardPlayerName", tmpFont, 19, _weight, false )
	createFont( "ScoreboardPlayerName2", tmpFont, 15, _weight, false )
	createFont( "ScoreboardPlayerNameBig", tmpFont, 24, _weight, false )
	createFont( "AckBarWriting", tmpFont, 20, _weight, false )
	createFont( "DarkRP_tipjar", tmpFont, 100, _weight, false )
end
changeFontSize()
