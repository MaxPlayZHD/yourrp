
include("shared.lua")

--local logos = {}
--local mats = {}

function YDrawIDCards()
	for _, ply in pairs(player.GetAll()) do
		if ply:GetPos():Distance(LocalPlayer():GetPos()) < 400 and ply:GetActiveWeapon().ClassName == "yrp_idcard" then
			local ang = Angle(0, ply:EyeAngles().y - 270, ply:EyeAngles().p + 90)
			local sca = 0.01

			local correction = 3
			if ply:LookupBone("ValveBiped.Bip01_R_Hand") then
				pos = ply:GetBonePosition(ply:LookupBone("ValveBiped.Bip01_R_Hand"))
				correction = 6
			end

			cam.Start3D2D(pos + ply:EyeAngles():Forward() * correction, ang, sca)

<<<<<<< HEAD
<<<<<<< HEAD
			local elements = {
				"background",
				"hostname",
				"role",
				"group",
				"idcardid",
				"faction",
				"rpname",
				"securitylevel",
				"box1",
				"box2",
				"box3",
				"box4",
				--"grouplogo",
				"serverlogo"
			}
=======
				local elements = {
=======
				drawIDCard(ply)
				--[[local elements = {
>>>>>>> canary
					"background",
					"hostname",
					"role",
					"group",
					"idcardid",
					"faction",
					"rpname",
					"securitylevel",
					"box1",
					"box2",
					"box3",
					"box4",
					--"grouplogo",
					"serverlogo"
				}
>>>>>>> canary

				for i, ele in pairs(elements) do
					if GetGlobalDBool("bool_" .. ele .. "_visible", false) then
						local w = GetGlobalDInt("int_" .. ele .. "_w", 100)
						local h = GetGlobalDInt("int_" .. ele .. "_h", 100)

						local x = GetGlobalDInt("int_" .. ele .. "_x", 0)
						local y = GetGlobalDInt("int_" .. ele .. "_y", 0)

						local color = {}
						color.r = GetGlobalDInt("int_" .. ele .. "_r", 0)
						color.g = GetGlobalDInt("int_" .. ele .. "_g", 0)
						color.b = GetGlobalDInt("int_" .. ele .. "_b", 0)
						color.a = GetGlobalDInt("int_" .. ele .. "_a", 0)

						local ax = GetGlobalDInt("int_" .. ele .. "_ax", 0)
						local ay = GetGlobalDInt("int_" .. ele .. "_ay", 0)

<<<<<<< HEAD
					if !string.find(ele, "logo") then
						if string.find(ele, "background") or string.find(ele, "box") then
							draw.RoundedBox(0, x, y, w, h, color)
						else
							local text = "LOAD"
							if ele == "hostname" then
								text = GetGlobalDString("text_server_name", "")
							elseif ele == "role" then
								text = ply:GetRoleName()
							elseif ele == "rpname" then
								text = ply:RPName()
							elseif ele == "securitylevel" then
								text = YRP.lang_string("LID_" .. ele) .. " " .. ply:GetDInt("int_securitylevel", 0)
							elseif ele == "faction" then
								text = ply:GetFactionName()
							elseif ele == "group" then
								text = ply:GetGroupName()
							elseif ele == "idcardid" then
								text = ply:GetDString("idcardid", "")
							end
=======
						if !string.find(ele, "logo") then
							if string.find(ele, "background") or string.find(ele, "box") then
								draw.RoundedBox(0, x, y, w, h, color)
							else
								local text = "LOAD"
								if ele == "hostname" then
									text = GetGlobalDString("text_server_name", "")
								elseif ele == "role" then
									text = ply:GetRoleName()
								elseif ele == "rpname" then
									text = ply:RPName()
								elseif ele == "securitylevel" then
									text = YRP.lang_string("LID_" .. ele) .. " " .. ply:GetDInt("int_securitylevel", 0)
								elseif ele == "faction" then
									text = ply:GetFactionName()
								elseif ele == "group" then
									text = ply:GetGroupName()
								elseif ele == "idcardid" then
									text = ply:GetDString("idcardid", "")
								end
>>>>>>> canary

								local tx = 0
								local ty = 0
								if ax == 0 then
									tx = x
								elseif ax == 1 then
									tx = x + w / 2
								elseif ax == 2 then
									tx = x + w
								end
								if ay == 0 then
									ay = 3
									ty = y
								elseif ay == 1 then
									ty = y + h / 2
								elseif ay == 2 then
									ay = 4
									ty = y + h
								end
								color.a = 255

								local ft = GetFontSizeTable()
								local fs = math.Round(10, 0)
								draw.SimpleText(text, "YRP_" .. ft[fs] .. "_500", tx, ty, color, ax, ay)
							end
<<<<<<< HEAD
							color.a = 255

							draw.SimpleText(text, "YRP_" .. "36" .. "_500", tx, ty, color, ax, ay)
						end
					else
						if logos[ele] == nil then
							logos[ele] = true
							local size = 64
							ply.html = createD("DHTML", nil, size, size, 0, 0)
							ply.html:SetHTML(GetHTMLImage(GetGlobalDString("text_server_logo", ""), size, size))
							function ply.html:Paint(pw, ph)
								if pa(ply.html) then
									ply.htmlmat = ply.html:GetHTMLMaterial()
									if ply.htmlmat != nil and !ply.html.found then
										ply.html.found = true
										timer.Simple(0.2, function()
											ply.matname = ply.htmlmat:GetName()
											local matdata =	{
												["$basetexture"] = ply.matname,
												["$translucent"] = 1,
												["$model"] = 1
											}
											local uid = string.Replace(ply.matname, "__vgui_texture_", "")
											mats[ele] = CreateMaterial("WebMaterial_" .. uid, "VertexLitGeneric", matdata)
											ply.html:Remove()
										end)
=======
						else
							if logos[ele] == nil then
								logos[ele] = true
								local size = 64
								ply.html = createD("DHTML", nil, size, size, 0, 0)
								ply.html:SetHTML(GetHTMLImage(GetGlobalDString("text_server_logo", ""), size, size))
								function ply.html:Paint(pw, ph)
									if pa(ply.html) then
										ply.htmlmat = ply.html:GetHTMLMaterial()
										if ply.htmlmat != nil and !ply.html.found then
											ply.html.found = true
											timer.Simple(0.5, function()
												ply.matname = ply.htmlmat:GetName()
												local matdata =	{
													["$basetexture"] = ply.matname,
													["$translucent"] = 1,
													["$model"] = 1
												}
												local uid = string.Replace(ply.matname, "__vgui_texture_", "")
												mats[ele] = CreateMaterial("WebMaterial_" .. uid, "VertexLitGeneric", matdata)
												ply.html:Remove()
											end)
										end
>>>>>>> canary
									end
								end
							end
							if mats[ele] != nil then
								surface.SetDrawColor(color)
								surface.SetMaterial(mats[ele])
								surface.DrawTexturedRect(x, y, w, h)
							end
						end
					end
				end]]

			cam.End3D2D()
		end
	end
end
hook.Add("PostDrawTranslucentRenderables", "yrp_draw_idcards", YDrawIDCards)

hook.Add("HUDPaint", "yrp_yrp_idcard", function()
	local ply = LocalPlayer()
	local weapon = ply:GetActiveWeapon()
	if weapon:IsValid() and weapon:GetClass() == "yrp_idcard" then
		local scale = 1.0
		local w = GetGlobalDInt("int_" .. "background" .. "_w", 100)
		local h = GetGlobalDInt("int_" .. "background" .. "_h", 100)
		w = w * scale
		h = h * scale
		drawIDCard(ply, scale, ScrW() - w - YRP.ctr(200), ScrH() - h - YRP.ctr(200))
	end
end)