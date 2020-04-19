ZombiesInScene = {}

function SpawnZombies()
	timer.Create( "SpawnTimer",2,0,function() 
		if( #ZombiesInScene > 10 ) then
			return
		else
			SpawnZombie()
		end
	end)

end

function SpawnZombie()
	
	ZombieSpawnPoints = {}
	SpawnPointUsed = {}
	
	-- finds every entity called tagged as "gibshooter" in the bsp file
	for k,v in pairs(ents.FindByClass( "gibshooter" )) do	
		table.insert(ZombieSpawnPoints,v)
	end

	-- creates a zombie and adds it to a table
    local npc = ents.Create( "npc_zombie" )
    table.insert(ZombiesInScene,npc)
	SpawnZombieAt = ZombieSpawnPoints[math.random(1,#ZombieSpawnPoints)]:GetPos()
	npc:SetPos(SpawnZombieAt)
	npc:Spawn()
	
end

function RemoveAllZombies()
	for k,v in pairs(ZombiesInScene) do
		if(IsValid(v)) then
			SafeRemoveEntity(v)
		end
	end
	ZombiesInScene = {}
end
