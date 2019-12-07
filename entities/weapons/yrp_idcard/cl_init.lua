
include("shared.lua")

--local logos = {}
--local mats = {}

function YDrawIDCards()
	for _, ply in pairs(player.GetAll()) do
		if ply:GetPos():Distance(LocalPlayer():GetPos()) < 400 and ply:GetActiveWeapon().ClassName == "yrp_idcard" then
			local ang = Angle(0, ply:EyeAngles().y - 270, ply:EyeAngles().p + 90)
			local sca = 0.016

			local correction = 3
			if ply:LookupBone("ValveBiped.Bip01_R_Hand") then
				pos = ply:GetBonePosition(ply:LookupBone("ValveBiped.Bip01_R_Hand"))
				correction = 6
			end

			cam.Start3D2D(pos + ply:EyeAngles():Forward() * correction, ang, sca)
				drawIDCard(ply)
			cam.End3D2D()
		end
	end
end
hook.Add("PostDrawTranslucentRenderables", "yrp_draw_idcards", YDrawIDCards)

hook.Add("HUDPaint", "yrp_yrp_idcard", function()
	local ply = LocalPlayer()
	local weapon = ply:GetActiveWeapon()
	if weapon:IsValid() and weapon:GetClass() == "yrp_idcard" then
		local scale = YRP.ctr(900) / GetGlobalDInt("int_" .. "background" .. "_w", 100)
		local w = GetGlobalDInt("int_" .. "background" .. "_w", 100)
		local h = GetGlobalDInt("int_" .. "background" .. "_h", 100)
		w = w * scale
		h = h * scale
		drawIDCard(ply, scale, ScrW() - w - YRP.ctr(200), ScrH() - h - YRP.ctr(200))
	end
end)