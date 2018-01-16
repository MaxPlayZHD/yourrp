--Copyright (C) 2017 Arno Zura ( https://www.gnu.org/licenses/gpl.txt )

local _hm = {}

function toggleHelpMenu()
  if isNoMenuOpen() then
    openHelpMenu()
  else
    closeHelpMenu()
  end
end

function closeHelpMenu()
  if _hm.window != nil then
    closeMenu()
    _hm.window:Remove()
    _hm.window = nil
  end
end

function openHelpMenu()
  done_tutorial( "tut_hudhelp" )
  openMenu()
  _hm.window = createD( "DFrame", nil, ctr( 2000 ), ctr( 1600 ), 0, 0 )
  _hm.window:Center()
  _hm.window:SetTitle( "" )
  function _hm.window:OnClose()
    closeMenu()
  end
  function _hm.window:OnRemove()
    closeMenu()
  end

  _hm.langu = derma_change_language( _hm.window, ctr( 400 ), ctr( 50 ), ctr( 1400 ), ctr( 50 ) )

  function _hm.window:Paint( pw, ph )
    paintWindow( self, pw, ph, lang_string( "help" ) )

    local _abstand = ctr( HudV("ttsf") ) * 3.8

    draw.SimpleTextOutlined( "Language: ", "ttsf", ctr( 1400 ), ctr( 50 ), Color( 255, 255, 255, 255 ), TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP, 1, Color( 0, 0, 0 ) )

    draw.SimpleTextOutlined( "[" .. "F1" .. "] " .. lang_string( "help" ), "ttsf", ctr( 10 ) + ctr( 32 ), ctr( 10 ) + ctr( 10 + 1*_abstand ), Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP, 1, Color( 0, 0, 0 ) )
    draw.SimpleTextOutlined( "[" .. string.upper( input.GetKeyName( get_keybind( "menu_character_selection" ) ) ) .. "] " .. lang_string( "characterselection" ), "ttsf", ctr( 10 ) + ctr( 32 ), ctr( 10 ) + ctr( 10 + 2*_abstand ), Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP, 1, Color( 0, 0, 0 ) )
    draw.SimpleTextOutlined( "[" .. string.upper( input.GetKeyName( get_keybind( "menu_role" ) ) ) .. "] " .. lang_string( "rolemenu" ), "ttsf", ctr( 10 ) + ctr( 32 ), ctr( 10 ) + ctr( 10 ) + ctr( 3*_abstand ), Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP, 1, Color( 0, 0, 0 ) )
    draw.SimpleTextOutlined( "[" .. string.upper( input.GetKeyName( get_keybind( "menu_buy" ) ) ) .. "] " .. lang_string( "buymenu" ), "ttsf", ctr( 10 ) + ctr( 32 ), ctr( 10 ) + ctr( 10 ) + ctr( 4*_abstand ), Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP, 1, Color( 0, 0, 0 ) )
    draw.SimpleTextOutlined( "[" .. string.upper( input.GetKeyName( get_keybind( "menu_settings" ) ) ) .. "] " .. lang_string( "settings" ), "ttsf", ctr( 10 ) + ctr( 32 ), ctr( 10 ) + ctr( 10 ) + ctr( 5*_abstand ), Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP, 1, Color( 0, 0, 0 ) )
    draw.SimpleTextOutlined( "[" .. string.upper( input.GetKeyName( get_keybind( "toggle_mouse" ) ) ) .. "] " .. lang_string( "guimouse" ), "ttsf", ctr( 10 ) + ctr( 32 ), ctr( 10 ) + ctr( 10 ) + ctr( 6*_abstand ), Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP, 1, Color( 0, 0, 0 ) )
    draw.SimpleTextOutlined( lang_string( "viewzoomoutpre" ) .. " " .. "[" .. string.upper( input.GetKeyName( get_keybind( "view_zoom_out" ) ) ) .. "]" .. " " .. lang_string( "viewzoomoutpos" ), "ttsf", ctr( 10 ) + ctr( 32 ), ctr( 10 ) + ctr( 10 ) + ctr( 7*_abstand ), Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP, 1, Color( 0, 0, 0 ) )
    draw.SimpleTextOutlined( lang_string( "viewzoominpre" ) .. " " .. "[" .. string.upper( input.GetKeyName( get_keybind( "view_zoom_in" ) ) ) .. "]" .. " " .. lang_string( "viewzoominpos" ), "ttsf", ctr( 10 ) + ctr( 32 ), ctr( 10 ) + ctr( 10 ) + ctr( 8*_abstand ), Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP, 1, Color( 0, 0, 0 ) )
    draw.SimpleTextOutlined( "[" .. string.upper( input.GetKeyName( get_keybind( "toggle_map" ) ) ) .. "] " .. lang_string( "map" ), "ttsf", ctr( 10 ) + ctr( 32 ), ctr( 10 ) + ctr( 10 ) + ctr( 9*_abstand ), Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP, 1, Color( 0, 0, 0 ) )
    draw.SimpleTextOutlined( "[" .. string.upper( input.GetKeyName( get_keybind( "menu_inventory" ) ) ) .. "] " .. lang_string( "inventory" ), "ttsf", ctr( 10 ) + ctr( 32 ), ctr( 10 ) + ctr( 10 ) + ctr( 10*_abstand ), Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP, 1, Color( 0, 0, 0 ) )
    draw.SimpleTextOutlined( "[" .. string.upper( input.GetKeyName( get_keybind( "speak_next" ) ) ) .. "] " .. lang_string( "voicenext" ), "ttsf", ctr( 10 ) + ctr( 32 ), ctr( 10 ) + ctr( 10 ) + ctr( 11*_abstand ), Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP, 1, Color( 0, 0, 0 ) )
    draw.SimpleTextOutlined( "[" .. string.upper( input.GetKeyName( get_keybind( "speak_prev" ) ) ) .. "] " .. lang_string( "voiceprev" ), "ttsf", ctr( 10 ) + ctr( 32 ), ctr( 10 ) + ctr( 10 ) + ctr( 12*_abstand ), Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP, 1, Color( 0, 0, 0 ) )
    draw.SimpleTextOutlined( "[" .. string.upper( input.GetKeyName( get_keybind( "drop_item" ) ) ) .. "] " .. lang_string( "drop" ), "ttsf", ctr( 10 ) + ctr( 32 ), ctr( 10 ) + ctr( 10 ) + ctr( 13*_abstand ), Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP, 1, Color( 0, 0, 0 ) )

    if LocalPlayer():IsSuperAdmin() or LocalPlayer():IsAdmin() then
      draw.SimpleTextOutlined( "[" .. string.upper( input.GetKeyName( get_keybind( "menu_settings" ) ) ) .. "] " .. lang_string( "ifadminsettings" ).. "!", "ttsf", ctr( 10 ) + ctr( 32 ), ctr( 10 ) + ctr( 10 ) + ctr( 15*_abstand ), Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP, 1, Color( 0, 0, 0 ) )
    else
      draw.SimpleTextOutlined( lang_string( "ifnotadminsettings" ) .. "!", "ttsf", ctr( 10 ) + ctr( 32 ), ctr( 10 ) + ctr( 10 ) + ctr( 15*_abstand ), Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP, 1, Color( 0, 0, 0 ) )
    end

    draw.SimpleTextOutlined( lang_string( "notshowagain"), "ttsf", ctr( 110 ), ctr( 860 ), Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP, 1, Color( 0, 0, 0 ) )
  end

  _hm.feedback = createD( "DButton", _hm.window, ctr( 500 ), ctr( 50 ), ctr( 50 ), ctr( 800 ) )
  _hm.feedback:SetText( "" )
  function _hm.feedback:Paint( pw, ph )
    paintButton( self, pw, ph, "Give Feedback / Report problem" )
  end
  function _hm.feedback:DoClick()
    gui.OpenURL( "https://docs.google.com/forms/d/e/1FAIpQLSd2uI9qa5CCk3s-l4TtOVMca-IXn6boKhzx-gUrPFks1YCKjA/viewform?usp=sf_link" )
  end

  _hm.discord = createD( "DButton", _hm.window, ctr( 400 ), ctr( 50 ), ctr( 560 ), ctr( 800 ) )
  _hm.discord:SetText( "" )
  function _hm.discord:Paint( pw, ph )
    paintButton( self, pw, ph, "Live Support" )
  end
  function _hm.discord:DoClick()
    gui.OpenURL( "https://discord.gg/sEgNZxg" )
  end

  _hm.dontopenagain = createD( "DCheckBox", _hm.window, ctr( 50 ), ctr( 50 ), ctr( 50 ), ctr( 860 ) )
  local _value = 0
  if !tobool(get_tutorial( "tut_welcome" )) then
    _value = 1
  end
  _hm.dontopenagain:SetValue( _value )
  function _hm.dontopenagain:OnChange( bVal )
    if bVal then
      done_tutorial( "tut_welcome" )
    else
      reset_tutorial( "tut_welcome" )
    end
  end

  _hm.window:MakePopup()
end