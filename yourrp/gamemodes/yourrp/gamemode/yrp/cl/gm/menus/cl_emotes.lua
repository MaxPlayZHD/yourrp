--Copyright (C) 2017-2018 Arno Zura ( https://www.gnu.org/licenses/gpl.txt )

local _em = {}

function ToggleEmotesMenu()
  if isNoMenuOpen() then
    OpenEmotesMenu()
  else
    CloseEmotesMenu()
  end
end

function CloseEmotesMenu()
  if _em.window != nil then
    closeMenu()
    _em.window:Remove()
    _em.window = nil
  end
end

function circleBorder( x, y, radius, seg, a_start, a_ang )
  local cir = {}
	for i = 0, seg do
		local a = math.rad( ( ( i / seg ) * -a_ang ) + 180 - a_start )

    local _coord = {}
    _coord.x = x + math.sin( a ) * radius
    _coord.y = y + math.cos( a ) * radius
		table.insert( cir, _coord )
	end
  return cir
end

function circleCoords( x, y, radius_outside, radius_inside, seg, a_start, a_ang )
  local cir = circleBorder( x, y, radius_outside, seg, a_start, a_ang )
  local cir2 = circleBorder( x, y, radius_inside, seg, a_start, a_ang )
  for i, cord in pairs( table.Reverse( cir2 ) ) do
    table.insert( cir, cord )
  end
	return cir
end

local _emotes = {}
function GetEmotes()
  return _emotes
end
function AddEmote( name, cmd )
  local _new = {}
  _new.name = name
  _new.cmd = cmd
  table.insert( _emotes, _new )
end

AddEmote( "emotedancenormal", "dance" )
AddEmote( "emotedancesexy", "muscle" )
AddEmote( "emotedancerobot", "robot" )
AddEmote( "emoteimitiationzombie", "zombie" )

AddEmote( "emotewave", "wave" )
AddEmote( "emotesalute", "salute" )
AddEmote( "emotebow", "bow" )
AddEmote( "emotebecon", "becon" )

AddEmote( "emotelaugh", "laugh" )
AddEmote( "emotepers", "pers" )
AddEmote( "emotecheer", "cheer" )

AddEmote( "emoteagree", "agree" )
AddEmote( "emotedisagree", "disagree" )

AddEmote( "emotehalt", "halt" )
AddEmote( "emotegroup", "group" )
AddEmote( "emoteforward", "forward" )

local _vec_emo = {}
local _seg = #GetEmotes()

for i = 0, _seg do
  local a = math.rad( ( ( i / _seg ) * -360 ) + 180 - (360/_seg)/2 )
  local _coord = {}
  _coord.x = ctr( 950 ) + math.sin( a ) * ctr( 800 )
  _coord.y = ctr( 950 ) + math.cos( a ) * ctr( 800 )
  table.insert( _vec_emo, _coord )
end

local _test = {}
for i = 1, _seg do
  local _segment = circleCoords( ctr( 950 ), ctr( 950 ), ctr( 900 ), ctr( 700 ), 8, (i-1)*360/_seg + 0.5, 360/_seg - 1 )
  table.insert( _test, _segment )
end

function OpenEmotesMenu()
  openMenu()

  _em.window = createD( "DFrame", nil, ctr( 1900 ), ctr( 1900 ), 0, 0 )
  _em.window:Center()
  _em.window:ShowCloseButton( false )
  _em.window:SetDraggable( false )
  _em.window:MakePopup()
  _em.window:SetTitle( "" )

  _em.emotes = createD( "DButton", _em.window, ctr( 1900 ), ctr( 1900 ), 0, 0 )
  _em.emotes:SetText( "" )
  function _em.emotes:Paint( pw, ph )
    --
  end
  function _em.window:Paint( pw, ph )
    --surfaceWindow( self, pw, ph, "" )
    local _mx, _my = gui.MousePos()
    local _px, _py = _em.window:GetPos()
    _mx = _mx-self:GetWide()/2-_px
    _my = _my-self:GetTall()/2-_py

    --[[ Vectors ]]--
    local _mp = Vector( _mx, _my, 1 )
    local _mid = Vector( 0, self:GetTall(), 1 )

    --[[ ABS A and B ]]--
    local _abs_a = math.sqrt( math.pow( _mp.x, 2 ) + math.pow( _mp.y, 2 ), 2 )
    local _abs_b = math.sqrt( math.pow( _mid.x, 2 ) + math.pow( _mid.y, 2 ), 2 )

    local _multi = _mp.x*_mid.x + _mp.y*_mid.y

    local _cos_a = _multi / ( _abs_a * _abs_b )

    local _ang = 0
    if _mp.x >= 0 then
      _ang = 180 - math.deg( math.acos( _cos_a ) )
    else
      _ang = 180 + math.deg( math.acos( _cos_a ) )
    end

    _em.emotes.select = 1 + _ang/(360/#_test) - _ang/(360/#_test)%1

    for e = 1, _seg do
      for i = 1, #_test[e]/2 do
        local _quad = {}
        table.insert( _quad, _test[e][i] )
        table.insert( _quad, _test[e][i+1] )
        table.insert( _quad, _test[e][#_test[e] - (i)] )
        table.insert( _quad, _test[e][#_test[e] - (i-1)] )
        local _color = Color( 220, 220, 220, 120 )
        if e == _em.emotes.select then
          _color = Color( 255, 255, 0, 255 )
        end

        surface.SetDrawColor( _color.r, _color.g, _color.b, _color.a )
        draw.NoTexture()
        surface.DrawPoly( _quad )
      end
    end

    --surfaceText( "WINKEL: " .. tostring( math.Round( _ang, 0 ) ) .. " SELECT: " .. _em.emotes.select, "HudBars", _mx+self:GetWide()/2, _my+self:GetTall()/2, Color( 0, 0, 255 ), 1, 1 )

    for e = 1, _seg do
      surfaceText( lang_string( GetEmotes()[e].name ), "emotes", _vec_emo[e].x, _vec_emo[e].y, Color( 255, 255, 255 ), 1, 1 )
    end
  end
  function _em.emotes:DoClick()
    if self.select != nil then
      local _sel = self.select
      LocalPlayer():SetNWBool( "istaunting", true )
      CloseEmotesMenu()
      timer.Simple( 0.01, function()
        if _sel != nil then
          if GetEmotes()[_sel] != nil then
            LocalPlayer():SetNWBool( "istaunting", false )
            RunConsoleCommand( "act", GetEmotes()[_sel].cmd )
          end
        end
      end)
    end
  end
end
