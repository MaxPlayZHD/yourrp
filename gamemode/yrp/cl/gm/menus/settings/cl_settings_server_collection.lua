--Copyright (C) 2017-2018 Arno Zura ( https://www.gnu.org/licenses/gpl.txt )

net.Receive( "get_workshop_collection", function()
  local ply = LocalPlayer()
  local _wscnr = tostring( net.ReadString() )
  if _wscnr != "" and _wscnr != "0" then
    if settingsWindow.window != nil then
      local _dlv_wscso = createD( "DButton", settingsWindow.window.site, ctr( 800 ), ctr( 50 ), ctr( 10 ), ctr( 10 + 50 ) )
      _dlv_wscso:SetText( "" )
      function _dlv_wscso:Paint( pw, ph )
        local _color = Color( 255, 255, 255 )
        if self:IsHovered() then
          _color = Color( 255, 255, 0 )
        end
        surfaceBox( 0, 0, pw, ph, _color )
        surfaceText( lang_string( "openinsteamoverlay" ), "roleInfoHeader", pw/2, ph/2, Color( 255, 255, 255 ), 1, 1 )
      end
      function _dlv_wscso:DoClick()
        gui.OpenURL( "http://steamcommunity.com/sharedfiles/filedetails/?id=" .. _wscnr )
      end

      local _dlv_wsc = createD( "HTML", settingsWindow.window.site, BScrW() - ctr( 20 ), ScrH() - ctr( 180 + 50 ), ctr( 10 ), ctr( 10 + 50 + 50 ) )
      _dlv_wsc:OpenURL( "http://steamcommunity.com/sharedfiles/filedetails/?id=" .. _wscnr )
    end
  else
    local _wsc = net.ReadTable()

    if settingsWindow.window != nil then
      local _dlv_wsc = createD( "DListView", settingsWindow.window.site, BScrW() - ctr( 20 ), ScrH() - ctr( 180 ), ctr( 10 ), ctr( 10 + 50 ) )
      _dlv_wsc:AddColumn( lang_string( "title" ) )
      _dlv_wsc:AddColumn( lang_string( "id" ) )
      _dlv_wsc:AddColumn( lang_string( "link" ) )
      for i, wsi in pairs( _wsc ) do
        _dlv_wsc:AddLine( tostring( wsi.title ), tostring( wsi.wsid ), "http://steamcommunity.com/sharedfiles/filedetails/?id=" .. tostring( wsi.wsid ) )
      end

      _dlv_wsc.OnRowSelected = function( lst, index, pnl )
        gui.OpenURL( pnl:GetColumnText( 3 ) )
      end
    end
  end
end)

hook.Add( "open_server_collection", "open_server_collection", function()
  SaveLastSite()
  local ply = LocalPlayer()

  local w = settingsWindow.window.sitepanel:GetWide()
  local h = settingsWindow.window.sitepanel:GetTall()

  settingsWindow.window.site = createD( "DPanel", settingsWindow.window.sitepanel, w, h, 0, 0 )
  function settingsWindow.window.site:Paint( w, h )
    surfaceText( lang_string( "workshopcollection" ), "roleInfoHeader", ctr( 10 ), ctr( 10 + 25 ), Color( 255, 255, 255 ), 0, 1 )
  end

  net.Start( "get_workshop_collection" )
  net.SendToServer()
end)
