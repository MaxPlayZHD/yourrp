--Copyright (C) 2017-2020 Arno Zura (https://www.gnu.org/licenses/gpl.txt)

local pp = {}
pp.c = 0

net.Receive("get_perma_props", function(len, ply)
	pp.tab = pp.tab or {}

	pp.c = pp.c + 1

	local i = net.ReadString()
	i = tonumber(i)
	pp.tab[i] = net.ReadTable()

	if pa(pp.list) then
		local h = YRP.ctr(240)
		
		local line = createD("DPanel", nil, pp.list:GetWide(), h, 0, 0)
		line.c = pp.c
		line.id = pp.tab[i].id
		line.max = pp.tab[i].max
		line.class = pp.tab[i].class
		line.model = pp.tab[i].model
		function line:Paint(pw, ph)
			draw.RoundedBox(0, 0, 0, pw, ph, Color(45, 45, 45, 100))

			draw.SimpleText("ID: " .. self.id .. "    " .. self.c .. "/" .. self.max, "Y_30_500", ph + YRP.ctr(20), ph / 4, Color(255, 255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
			draw.SimpleText("ClassName: " .. self.class, "Y_30_500", ph + YRP.ctr(20), ph / 4 * 2, Color(255, 255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
			draw.SimpleText("WorldModel: " .. self.model, "Y_30_500", ph + YRP.ctr(20), ph / 4 * 3, Color(255, 255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
		end
	
		local mdl = createD("DModelPanel", line, h, h, 0, 0)

		local sho = createD("YButton", line, h, h, 0, 0)
		sho:SetText("LID_show")
		sho.model = pp.tab[i].model
		sho.mdl = mdl
		function sho:Paint(pw, ph)
			self.o = self.o or false
			if self:IsVisible() and self.mdl:GetModel() == nil and !self.o then
				self.o = true
				self.mdl:SetModel(self.model)
			end
		end
		function sho:DoClick()
			--mdl:SetModel(self.model)
		end

		local tel = createD("YButton", line, YRP.ctr(480), h, line:GetWide() - YRP.ctr(480 + 20 + 240 + 36), 0)
		tel:SetText("LID_tpto")
		tel.line = line
		tel.id = pp.tab[i].id
		function tel:Paint(pw, ph)
			hook.Run("YButtonPaint", self, pw, ph)
		end
		function tel:DoClick()
			net.Start("yrp_pp_teleport")
				net.WriteString(self.id)
			net.SendToServer()
		end

		local rem = createD("YButton", line, YRP.ctr(240), h, line:GetWide() - YRP.ctr(240 + 36), 0)
		rem:SetText("LID_remove")
		rem.line = line
		rem.id = pp.tab[i].id
		function rem:Paint(pw, ph)
			hook.Run("YButtonRPaint", self, pw, ph)
		end
		function rem:DoClick()
			net.Start("yrp_pp_remove")
				net.WriteString(self.id)
			net.SendToServer()
			self.line:Remove()
		end

		pp.list:AddItem(line)
	end
end)


function CreatePermaPropsSetting()
	if pa(settingsWindow.window) then
		local PARENT = settingsWindow.window.site

		pp.list = createD("DPanelList", PARENT, PARENT:GetWide() - YRP.ctr(40), PARENT:GetTall() - YRP.ctr(40), YRP.ctr(20), YRP.ctr(20))
		pp.list:EnableVerticalScrollbar()
		pp.list:SetSpacing(YRP.ctr(20))
		function pp.list:Paint(pw, ph)
			--draw.RoundedBox(0, 0, 0, pw, ph, Color(255, 100, 100, 100))
		end
		function pp.list:OnRemove()
			net.Start("yrp_pp_close")
			net.SendToServer()
		end

		pp.tab = {}
		pp.c = 0

		net.Start("get_perma_props")
		net.SendToServer()
	end
end

hook.Add("open_server_permaprops", "open_server_permaprops", function()
	CreatePermaPropsSetting()
end)
