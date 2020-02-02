extends Node2D

export(float) var near_chance
export(float) var mid_chance
export(float) var far_chance
export(float) var nothing_chance
# how many things to do at once
export(float) var difficulty

onready var player = get_node("../Platform Character")
onready var tiles:TileMap = get_node("../TileMap")
onready var cracks:TileMap = get_node("../Cracks")

var rand = RandomNumberGenerator.new()

func _ready():
	rand.randomize()

func spawnMissions():
	var temp = difficulty
	var tile = 0
	var world
	
	while temp > 0:
		if rand.randf_range(0, 100) <= far_chance:
			while tile < 2 or tile > 4:
				world = tiles.world_to_map(Vector2(player.position.x + rand.randi_range(-1200, 1200), rand.randi_range(-120, 420)))
				tile = tiles.get_cell(world.x, world.y)
				yield(get_tree(),"idle_frame")
			cracks.set_cell(world.x, world.y, clamp(cracks.get_cell(world.x, world.y) + 1, 0, 2))
			temp -= 1
		elif rand.randf_range(0, 100) <= mid_chance:
			while tile < 2 or tile > 4:
				world = tiles.world_to_map(Vector2(player.position.x + rand.randi_range(-600, 600), rand.randi_range(-120, 420)))
				tile = tiles.get_cell(world.x, world.y)
				yield(get_tree(),"idle_frame")
			cracks.set_cell(world.x, world.y, clamp(cracks.get_cell(world.x, world.y) + 1, 0, 2))
			temp -= 1
		elif rand.randf_range(0, 100) <= near_chance:
			while tile < 2 or tile > 4:
				world = tiles.world_to_map(Vector2(player.position.x + rand.randi_range(-100, 100), rand.randi_range(-120, 420)))
				tile = tiles.get_cell(world.x, world.y)
				yield(get_tree(),"idle_frame")
			cracks.set_cell(world.x, world.y, clamp(cracks.get_cell(world.x, world.y) + 1, 0, 2))
			temp -= 1
		elif rand.randf_range(0, 100) <= nothing_chance:
			temp -= 1
		
		tile = 0
		yield(get_tree().create_timer(0.5), "timeout")

func _process(delta):
	if Input.is_action_just_pressed("look_down"):
		spawnMissions()
