extends KinematicBody2D

# pixels per second
export(float) var walk_speed = 800

export(float, 0, 1) var walk_acceleration = 0.052
export(float, 0, 1) var walk_deceleration = 0.141

export(float) var jump_height = 575
export(float) var jump_deceleration = 1200

export(float) var fall_speed = 1200
export(float) var fall_acceleration = 2200

var floor_normal = Vector2(0, -1)
var linear_vel = Vector2()
var up_attacked = false

onready var anim_tree = $AnimationTree
onready var sprite = $Pivot/Sprite
onready var pivot = $Pivot
onready var swoosh = $Pivot/Swoosh
onready var walking_sound = $"Walking Sound"
onready var attack1 = $Attack1
onready var attack2 = $Attack2
onready var attack3 = $Attack3
onready var attack4 = $Attack4
onready var rand = RandomNumberGenerator.new()
onready var cracks:TileMap = $"../Cracks"

func removeTile(var value):
	var world = cracks.world_to_map(value)
	cracks.set_cell(world.x, world.y, clamp(cracks.get_cell(world.x, world.y) - 1, -1, 2))

func _ready():
	rand.randomize()

func _physics_process(delta):
	# Move and slide
	linear_vel = move_and_slide(linear_vel, floor_normal)
	# Detect if we are on floor - only works if called *after* move_and_slide
	var on_floor = is_on_floor()

	### CONTROL ###
	var target_speed = 0
	# Horizontal movement
	if Input.is_action_pressed("move_left"):
		target_speed -= 1.0
		pivot.scale = Vector2(-1, 1)
		
	if Input.is_action_pressed("move_right"):
		target_speed += 1.0
		pivot.scale = Vector2(1, 1)
	
	if (Input.is_action_pressed("move_left") or Input.is_action_pressed("move_right")) and on_floor:
		if !walking_sound.playing:
			walking_sound.play()
	else:
		walking_sound.stop()
	
	# Animation
	if target_speed == 0:
		anim_tree["parameters/conditions/is_idle"] = true
		anim_tree["parameters/conditions/is_running"] = false
	else:
		anim_tree["parameters/conditions/is_idle"] = false
		anim_tree["parameters/conditions/is_running"] = true
	
	# Acceleration and Deceleration
	var x_acceleration = 0
	if target_speed != 0:
		x_acceleration = walk_acceleration
	else:
		x_acceleration = walk_deceleration
	linear_vel.x = lerp(linear_vel.x, target_speed * walk_speed, x_acceleration)

	# Jumping
	
	if on_floor and Input.is_action_just_pressed("jump"):
		linear_vel.y = -jump_height
		anim_tree["parameters/conditions/is_jumping"] = true
		anim_tree["parameters/conditions/on_floor"] = false
	
	# Falling
	if !on_floor and linear_vel.y < 0:
		linear_vel.y += jump_deceleration * delta
	elif linear_vel.y >= 0:
		linear_vel.y += fall_acceleration * delta
		anim_tree["parameters/conditions/is_jumping"] = false
		anim_tree["parameters/conditions/is_falling"] = true
		anim_tree["parameters/conditions/on_floor"] = false
	
	if on_floor:
		anim_tree["parameters/conditions/is_falling"] = false
		anim_tree["parameters/conditions/on_floor"] = true
	
	if (Input.is_action_pressed("move_left") or Input.is_action_pressed("move_right")) and on_floor:
		anim_tree["parameters/conditions/roll"] = true
	else:
		anim_tree["parameters/conditions/roll"] = false
	
	linear_vel.y = min(linear_vel.y, fall_speed)
	
	### ATTACK ###
	if on_floor:
		up_attacked = false
		anim_tree["parameters/conditions/up_attacked"] = false
	
	if !up_attacked and Input.is_action_just_pressed("attack"):
		linear_vel.y = -jump_height
		up_attacked = true
		
		var temp = rand.randi_range(0, 3)
		if temp == 0:
			attack1.play()
		elif temp == 1:
			attack2.play()
		elif temp == 2:
			attack3.play()
		else:
			attack4.play()
		
		anim_tree["parameters/conditions/up_attacked"] = true
		yield(get_tree().create_timer(0.29), "timeout")
		anim_tree["parameters/conditions/up_attacked"] = false
	
	if swoosh.visible:
		removeTile(swoosh.global_position)
		removeTile(swoosh.global_position + Vector2(-20, 20))
		removeTile(swoosh.global_position + Vector2(20, 20))
		removeTile(swoosh.global_position + Vector2(-20, -20))
		removeTile(swoosh.global_position + Vector2(20, -20))
		removeTile(swoosh.global_position + Vector2(0, 50))
