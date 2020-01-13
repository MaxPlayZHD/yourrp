--Copyright (C) 2017-2019 Arno Zura (https://www.gnu.org/licenses/gpl.txt)
local PANEL = {}

function PANEL:UPDATESIZE()
	self.hs:SetSize(self:GetWide(), YRP.ctr(100))
	self.site:SetSize(self:GetWide(), self:GetTall() - YRP.ctr(100))

	self.site:SetPos(0, YRP.ctr(100))
end

function PANEL:Init()
	self.hs = createD("DHorizontalScroller", self, 0, 0, 0, 0)
	self.site = createD("DPanel", self, 0, 0, 0, 0)
	function self.site:Paint(pw, ph)
	end

	self.tabwide = 400

	self.tabs = {}
end

function PANEL:Think()

end

function PANEL:SetTabWide(num)
	self.tabwide = num
end

function PANEL:AddOption(name, func)
	self:UPDATESIZE()

	local tab = createD("DButton", nil, YRP.ctr(400), YRP.ctr(100), 0, 0)
	tab:SetText("")
	tab.tabs = self
	function tab:DoClick()
		self.tabs:GoToSite(name)
	end
	function tab:Paint(pw, ph)
		self:SetWide(YRP.ctr(self.tabs.tabwide))
		self.color = Color(100, 100, 255)
		self.h = self.h or 0
		self.delay = 0.8
		if self.tabs.current == name then
			self.h = self.h + self.delay
			self.color = Color(100, 100, 255)
		elseif self:IsHovered() then
			self.h = self.h + self.delay
			self.color = Color(200, 200, 255)
		else
			self.h = self.h - self.delay
		end
		self.h = math.Clamp(self.h, 0, 10)

		draw.RoundedBox(0, YRP.ctr(20), ph - YRP.ctr(self.h), pw - YRP.ctr(40), YRP.ctr(self.h), self.color)

		draw.SimpleText(YRP.lang_string(name), "Y_25_500", pw / 2, ph / 2, Color(255,255,255,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
	end

	self.tabs[name] = func
	self.hs:AddPanel(tab)
end

function PANEL:GoToSite(name)
	self.site:Clear()
	self.current = name
	self.tabs[name](self.site)
end

function PANEL:Paint(w, h)

end

vgui.Register("YTabs", PANEL, "Panel")