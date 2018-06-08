--Copyright (C) 2017-2018 Arno Zura ( https://www.gnu.org/licenses/gpl.txt )

function DrawSelector( btn, w, h, text, selected )
  draw.SimpleTextOutlined( text, "mat1text", w/2, h/2, Color( 255, 255, 255, 255 ), 1, 1, ctr( 1 ), Color( 0, 0, 0, 255 ) )
  if btn.ani_h == nil then
    btn.ani_h = 0
  end
  if btn:IsHovered() or selected then
    if btn.ani_h < 10 then
      btn.ani_h = btn.ani_h + 1
    end
  else
    if btn.ani_h > 0 then
      btn.ani_h = btn.ani_h - 1
    end
  end
  local color = Color( 49, 135, 255, 255 )
  if selected then
    color = Color( 26, 121, 255, 255 )
  end
  surfaceBox( 0, h - ctr( btn.ani_h ), w, ctr( btn.ani_h ), color )
end

local PANEL = {}

function PANEL:Init()
  self.tabs = {}
  self.hscroller = createD( "DHorizontalScroller", self, self:GetWide(), ctr( 100 ), 0, 0 )
  function self.hscroller:Paint( pw, ph )
    --surfaceBox( 0, 0, pw, ph, Color( 255, 255, 255, 255 ) )
  end

  self.w = 0
  self.h = 0

  self.site = createD( "DPanel", self, 0, 0, 0, 0 )
  function self.site:Paint( pw, ph )
    surfaceBox( 0, 0, pw, ph, Color( 255, 0, 0, 100 ) )
  end
end

function PANEL:AddPanel( pnl )
  table.insert( self.tabs, pnl )
  self.hscroller:AddPanel( pnl )

  self.w = 0
  self.x = 0
  for i, tab in pairs( self.tabs ) do
    self.w = self.w + tab:GetWide()
  end
  self.hscroller:SetSize( self.w, ctr( 100 ) )
  self.hscroller:SetPos( self:GetWide()/2 - self.w/2, 0 )
end

function PANEL:MakeSpacer()
  local spacer = createD( "DButton", self, ctr( 30 ), ctr( 100 ), 0, 0 )
  spacer:SetText( "" )
  function spacer:Paint( pw, ph )
  end
  self:AddPanel( spacer )
end

function PANEL:ClearSite()
  for i, child in pairs( self.site:GetChildren() ) do
    child:Remove()
  end
  function self.site:Paint( pw, ph )
    --
  end
end

function PANEL:SiteNotFound()
  self:ClearSite()
  function self.site:Paint( pw, ph )
    draw.SimpleTextOutlined( "[Site Not Found]", "mat1text", pw/2, ph/2, Color( 255, 255, 0, 255 ), 1, 1, ctr( 1 ), Color( 0, 0, 0 ) )
    draw.SimpleTextOutlined( "[" .. lang_string( "wip" ) .. "]", "mat1text", pw/2, ph/2 + ctr( 50 ), Color( 255, 255, 0, 255 ), 1, 1, ctr( 1 ), Color( 0, 0, 0 ) )
  end
end

function PANEL:AddTab( name, netstr, starttab )
  if #self.tabs > 0 then
    self:MakeSpacer()
  end
  local TAB = createD( "DButton", self, GetTextLength( lang_string( name ), "mat1text" ) + ctr( 30 * 2 ), ctr( 100 ), ctr( 400 ), 0 )
  TAB.menu = self
  TAB.name = name
  TAB.netstr = netstr
  TAB:SetText( "" )
  function TAB:Paint( pw, ph )
    if self.menu.current_site == self.name then
      self.selected = true
    else
      self.selected = false
    end
    DrawSelector( self, pw, ph, lang_string( self.name ), self.selected )
  end
  function TAB:DoClick()
    self.menu.current_site = self.name
    if self.netstr != "" then
      self.menu:ClearSite()
      net.Start( self.netstr )
      net.SendToServer()
    else
      self.menu:SiteNotFound()
    end
  end
  if starttab then
    TAB:DoClick()
  end

  self:AddPanel( TAB )
  return TAB
end

function PANEL:SetStartTab( name )
  self.starttab = name
  for i, tab in pairs( self.tabs ) do
    if tab.name == name then
      tab:DoClick()
      break
    end
  end
end

function PANEL:GetMenuInfo( netstr )
  net.Start( netstr )
  net.SendToServer()
  net.Receive( netstr, function( len )
    local tabs = net.ReadTable()
    for i, tab in pairs( tabs ) do
      local starttab = false
      if tab.name == self.starttab then
        starttab = true
      end
      self:AddTab( tab.name, tab.netstr, starttab )
    end
  end)
end

function PANEL:Think()
  local _mx, _my = gui.MousePos()
  if self.w != self:GetWide() or self.h != self:GetTall() then
    self.w = self:GetWide()
    self.h = self:GetTall()
    self.site:SetSize( self:GetWide() - ctr( 2*20 ), self:GetTall() - ctr( 100 + 20 + 20 ) )
    self.site:SetPos( ctr( 20 ), ctr( 100 + 20 ) )
  end
end

function PANEL:Paint( w, h )
  surfaceBox( 0, 0, w, ctr( 100 ), Color( 255, 255, 255, 10 ) )
  --surfaceBox( 0, 0, w, h, Color( 255, 255, 0, 100 ) )
end

vgui.Register( "DYRPHorizontalMenu", PANEL, "Panel" )