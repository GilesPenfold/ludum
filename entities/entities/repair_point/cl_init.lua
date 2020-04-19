include ( "shared.lua" )


-- Draw some 3D text
local function Draw3DText( pos, ang, scale, text, flipView, red, green, blue )
	if ( flipView ) then
		-- Flip the angle 180 degrees around the UP axis
		ang:RotateAroundAxis( Vector( 0, 0, 1 ), 180 )
	end

	cam.Start3D2D( pos, ang, scale )
		-- Actually draw the text. Customize this to your liking.
		draw.DrawText( text, "Default", 0, 0, Color( red, green, blue, 255 ), TEXT_ALIGN_CENTER )
	cam.End3D2D()
end

function ENT:Draw()
	-- Draw the model
	self:DrawModel()

	-- The text to display
	local text = "REPAIR POINT"

	-- The position. We use model bounds to make the text appear just above the model. Customize this to your liking.
	local mins, maxs = self:GetModelBounds()
	local pos = self:GetPos() + Vector( 0, 0, maxs.z + 2 )
	local posHealth = self:GetPos() + Vector( 0, 0, maxs.z + 4 )
	
	local entityDurability = self:GetEntityDurability()
	local dangerZone = self:GetRepairPointDangerZone()
	local capped = self:GetCapped()
	local broken = self:GetBroken()
	
	local danger = false
	if(entityDurability < dangerZone) then
		danger = true
	end
	
	
	-- The angle
	local ang = Angle( 0, SysTime() * 100 % 360, 90 )

	if(capped) then
	
		text = "CAPPED"
		-- Draw front
		Draw3DText( pos, ang, 0.2, text, false, 0, 255, 0 )
		-- DrawDraw3DTextback
		Draw3DText( pos, ang, 0.2, text, true, 0, 255, 0 )
	elseif(broken) then
		
		text = "BROKEN"
		-- Draw front
		Draw3DText( pos, ang, 0.2, text, false, 255, 0, 0 )
		-- DrawDraw3DTextback
		Draw3DText( pos, ang, 0.2, text, true, 255, 0, 0 )
	else
	
		local red = 0
		local green = 255
		local blue = 255
		
		if(danger) then
			red = 255
			green = 140
			blue = 0
		end
		
		-- Draw front
		Draw3DText( pos, ang, 0.2, text, false, red, green, blue )
		-- DrawDraw3DTextback
		Draw3DText( pos, ang, 0.2, text, true, red, green, blue )
		
		-- Draw front
		Draw3DText( posHealth, ang, 0.2, entityDurability, false, red, green, blue  )
		-- DrawDraw3DTextback
		Draw3DText( posHealth, ang, 0.2, entityDurability, true, red, green, blue  )
	end
end