//Copyright (C) 2017 Arno Zura ( https://www.gnu.org/licenses/gpl.txt )

//cl_settings.lua

include( "cl_settings_client.lua" )
include( "cl_settings_server.lua" )
include( "cl_settings_yourrp.lua")
include( "cl_settings_settings.lua" )

yrpsettings = {}
yrpsettings.color = {}
yrpsettings.color.black = Color( 0, 0, 0, 255 )
yrpsettings.color.background = Color( 0, 0, 0, 160 )
yrpsettings.color.background2 = Color( 0, 0, 0, 254 )
yrpsettings.color.panel = Color( 0, 143, 255, 120 )
yrpsettings.color.buttonInActive = Color( 100, 100, 100, 160 )

function drawBackground( x, y, w, h, br )
  draw.RoundedBox( 0, 0, 0, w, h, yrpsettings.color.background )

  draw.RoundedBox( 0,   x,      y,      w,  br, yrpsettings.color.black )
  draw.RoundedBox( 0,   x,      y+h-br, w,  br, yrpsettings.color.black )
  draw.RoundedBox( 0,   x,      y,      br, h,  yrpsettings.color.black )
  draw.RoundedBox( 0,   x+w-br, y,      br, h,  yrpsettings.color.black )
end

function openSettings()
  settingsOpen = 1

  settingsWindow = vgui.Create( "DFrame" )
  settingsWindow:SetSize( ctrW( 2160 ), ctrW( 2160 ) )
  settingsWindow:SetPos( ScrW2() - ctrW( 2160/2 ), 0 )
  settingsWindow:SetTitle( "" )
  settingsWindow:ShowCloseButton( true )
  function settingsWindow:OnClose()
    gui.EnableScreenClicker( false )
    if modelSelector != nil then
      modelSelector:Remove()
    end
    _menuIsOpen = 0
  end
  function settingsWindow:Paint()
    draw.RoundedBox( 0, ctrW( 0 ), ctrW( 98 ), settingsWindow:GetWide(), settingsWindow:GetTall(), yrpsettings.color.background )
  end

  local settingsSheet = vgui.Create( "DPropertySheet", settingsWindow )
  settingsSheet:Dock( FILL )
  function settingsSheet:Paint()
    //drawBackground( 0, 0, settingsSheet:GetWide(), settingsSheet:GetTall(), ctrW( 0 ) )
  end

  local Langu = createVGUI( "DComboBox", settingsWindow, 400, 50, 1400, 0 )
  Langu:SetValue( lang.lang )
  Langu:AddChoice("[AUTOMATIC]", "auto")
  Langu:AddChoice("English", "en")
  Langu:AddChoice("German/Deutsch", "de")
  Langu:AddChoice("Russian/Русский", "ru")
  Langu:AddChoice("Turkish/Turkey", "tr")
  Langu:AddChoice("French/Français", "fr")
  Langu.OnSelect = function( panel, index, value, data )
    changeLang(data)
  end

  tabClient( settingsSheet )

  tabServer( settingsSheet )

  tabYourRP( settingsSheet )

  tabSettings( settingsSheet )

  for k, v in pairs(settingsSheet.Items) do
  	if (!v.Tab) then continue end

    v.Tab.Paint = function(self,w,h)
      if v.Tab == settingsSheet:GetActiveTab() then
		    draw.RoundedBox( 0, 0, 0, w, h, yrpsettings.color.background )
      else
        draw.RoundedBox( 0, 0, 0, w, h, yrpsettings.color.buttonInActive )
      end
    end
  end

  settingsWindow:MakePopup()
end