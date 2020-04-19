
local repairpoints = {}
local floodAmountPerPoint = 20

function SetupSubmarine()
	repairpoints = ents.FindByClass("repair_point")
end

function SubmarineFlood( sub )
	
	if(!IsRoundActive()) then return end
	if(!IsValid(GetSubmarine())) then return end
	if(#repairpoints == 0) then return end

	if( !timer.Exists( "floodTimer" ) ) then
		timer.Create( "floodTimer",5,1,function()	
			local totalDangerPoints = 0
			for k,v in pairs(repairpoints) do
				if(IsValid(v)) then
					if(v:GetEntityDurability() < v:GetRepairPointDangerZone()) then
						totalDangerPoints = totalDangerPoints + 1
					end
				end
			end
			local currentFlooding = sub:GetSubmarineFlooding()
			sub:SetSubmarineFlooding(currentFlooding + (totalDangerPoints * floodAmountPerPoint))
		end)
	end
	
end

function DestroyRepairPoints()
	for k,v in pairs(repairpoints) do
		SafeRemoveEntity(v)
	end
end
