
local repairpoints = {}
local floodAmountPerPoint = 8
local water = {}
local waterSet = false
local waterOriginalPos = nil
local floodIncrement = 0.1

function SetupSubmarine()
	repairpoints = ents.FindByClass("repair_point")
	water = ents.FindByClass( "func_water_analog" )
end

function SubmarineFlood( sub )
	if(!IsRoundActive()) then return end
	if(!IsValid(GetSubmarine())) then return end
	if(#repairpoints == 0) then return end
	if(!IsValid(sub)) then return end
	
	if( !timer.Exists( "floodTimer" ) ) then
		timer.Create( "floodTimer",10,1,function()	
			if(!IsValid(sub)) then return end
			if(!IsRoundActive()) then return end
			local totalDangerPoints = 0
			for k,v in pairs(repairpoints) do
				if(IsValid(v)) then
					if(v:GetEntityDurability() < v:GetRepairPointDangerZone()) then
						totalDangerPoints = totalDangerPoints + 1
					end
				end
			end

			local previousFlooding = sub:GetSubmarineFlooding()
			local currentFlooding = sub:GetSubmarineFlooding() + (totalDangerPoints * floodAmountPerPoint)
			sub:SetSubmarineFlooding(currentFlooding)
			if(#water != 0) then 
				if(!waterSet) then
					waterSet = true
					waterOriginalPos = water[1]:GetPos()
					waterOriginalPos = Vector(waterOriginalPos.x, waterOriginalPos.y, waterOriginalPos.z + 100)
					water[1]:SetPos(waterOriginalPos)
				end
				if((currentFlooding - previousFlooding) == 0) then return end
				floodIncrement = (currentFlooding - previousFlooding)

				if(previousFlooding != currentFlooding) then
			
						timer.Create( "waterIncrementTimer"..currentFlooding,0.02,floodIncrement * 10,function()
							if(!IsValid(water[1])) then return end
							if(!IsValid(sub)) then return end
							local currentWaterPos = water[1]:GetPos()
							local newWaterLevel = Vector(currentWaterPos.x,currentWaterPos.y, math.Clamp(currentWaterPos.z + 0.07, -600, 600)) -- 800 is flooded to max map height, so mult by 0.8 to scale properly
							water[1]:SetPos(newWaterLevel)
							sub:SetWaterLevel(newWaterLevel)
						end)
					
				end
			end		
		end)
	end
	
end

function ResetSubmarineManager()
	rp = ents.FindByClass("repair_point")
	for k,v in pairs(rp) do
		if(IsValid(v)) then
			SafeRemoveEntity(v)
		end
	end
	repairpoints = {}
	if(waterOriginalPos != nil) then
		if(IsValid(water[1])) then 
			water[1]:SetPos(Vector(waterOriginalPos.x, waterOriginalPos.y,waterOriginalPos.z))
		end
	end
end
