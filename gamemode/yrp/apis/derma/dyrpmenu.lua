--Copyright (C) 2017-2018 Arno Zura ( https://www.gnu.org/licenses/gpl.txt )

local PANEL = {}

function PANEL:Init()
	self.content = {}
	self.lastheight = 0
end

function PANEL:Think()
	local _mx, _my = gui.MousePos()
	local _px, _py = self:GetPos()
	if _mx < _px then
		self:Remove()
	end
	if _my < _py then
		self:Remove()
	end

	if _mx > _px + self:GetWide() then
		self:Remove()
	end
	if _my > _py + self:GetTall() then
		self:Remove()
	end
end

function PANEL:UpdateMenu()
	local Height = 0
	for i, ele in pairs( self.content ) do
		Height = Height + ele.size
	end
	self:SetTall( ctr( Height ) )
end

function PANEL:AddSpacer()
	local Entry = {}
	Entry.size = 10

	Entry.spacer = createD( "DPanel", self, self:GetWide(), ctr( Entry.size ), 0, ctr( self.lastheight ) )
	function Entry.spacer:Paint( pw, ph )
		surfaceBox( 0, ph/4, pw, ph/2, Color( 0, 0, 0 ) )
	end
	self.lastheight = self.lastheight + Entry.size

	table.insert( self.content, Entry )

	self:UpdateMenu()
end

function PANEL:AddOption( name, icon )
	local Entry = {}
	Entry.name = name
	Entry.iconpng = icon or ""
	if Entry.iconpng != "" then
		Entry.iconmat = Material( Entry.iconpng )
	end
	Entry.size = 50
	Entry.icon = createD( "DPanel", self, ctr( Entry.size ), ctr( Entry.size ), 0, ctr( self.lastheight ) )
	function Entry.icon:Paint( pw, ph )
		if Entry.iconpng != "" then
			surface.SetDrawColor( 255, 255, 255, 255 )
			surface.SetMaterial( Entry.iconmat )
			surface.DrawTexturedRect( ctr( 9 ), ctr( 9 ), ctr( 32 ), ctr( 32 ) )
		end
	end
	Entry.button = createD( "DButton", self, self:GetWide() - ctr( Entry.size ), ctr( Entry.size ), ctr( Entry.size ), ctr( self.lastheight ) )
	Entry.button:SetText( "" )
	function Entry.button:Paint( pw, ph )
		surfaceButton( self, pw, ph, Entry.name )
	end

	self.lastheight = self.lastheight + Entry.size

	table.insert( self.content, Entry )
	self:UpdateMenu()

	return Entry.button
end

function PANEL:Paint( w, h )
	surfacePanel( self, w, h, "" )
end

vgui.Register( "DYRPMenu", PANEL, "Panel" )
