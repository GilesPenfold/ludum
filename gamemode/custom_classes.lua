PLAYER_CLASSES = {

	{
		name = "Default",
		health = 100,
		walkspeed = 200,
		runspeed = 400,
		weapons = {},
		model = "models/player/Group03m/Male_0" .. math.random(1,9) .. ".mdl"
	},
	
	{
		name = "Engineer",
		health = 100,
		walkspeed = 200,
		runspeed = 400,
		weapons = {"weapon_weakcrowbar" },
		model = "models/player/Group03m/Male_0" .. math.random(1,9) .. ".mdl"
	},
	
	{
		name = "Soldier",
		health = 100,
		walkspeed = 200,
		runspeed = 400,
		weapons = {"weapon_soldiershotgun"},
		model = "models/player/Group03m/Male_0" .. math.random(1,9) .. ".mdl"
	}
}