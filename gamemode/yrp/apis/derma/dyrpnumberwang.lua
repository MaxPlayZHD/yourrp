--Copyright (C) 2017-2018 Arno Zura ( https://www.gnu.org/licenses/gpl.txt )

local PANEL = {}

function PANEL:Init()
	self.header = createD( "DPanel", self, self:GetWide(), ctr( 50 ), 0, 0 )
	self.header.text = "UNNAMED"
	function self:SetHeader( text )
		self.header.text = text
	end
	function self.header:Paint( pw, ph )
		draw.RoundedBox( 0, 0, 0, pw, ph, Color( 255, 255, 255 ) )
		surfaceText( SQL_STR_OUT( self.text ), "SettingsNormal", pw/2, ph/2, Color( 255, 255, 255 ), 1, 1 )
	end

	self.numberwang = createD( "DNumberWang", self, self:GetWide(), self:GetTall() - self.header:GetTall(), 0, ctr( 50 ) )
	function self:SetText( text )
		self.numberwang:SetText( text )
	end
end

function PANEL:Think()
	if self.header:GetWide() != self:GetWide() then
		self.header:SetWide( self:GetWide() )
	end
	if self.numberwang:GetWide() != self:GetWide() then
		self.numberwang:SetWide( self:GetWide() )
	end

	if self.numberwang:GetTall() != self:GetTall() - self.header:GetTall() then
		self.numberwang:SetTall( self:GetTall() - self.header:GetTall() )
	end

	if self.numberwang:GetPos() != self:GetPos() + ctr( 50 ) then
		self.numberwang:SetPos( 0, self:GetPos() + ctr( 50 ) )
	end
end

function PANEL:Paint( w, h )
	draw.RoundedBox( 0, 0, 0, w, h, Color( 255, 0, 0 ) )
end


vgui.Register( "DYRPNumberWang", PANEL, "Panel" )
