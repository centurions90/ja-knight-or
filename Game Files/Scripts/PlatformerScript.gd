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

onready var anim_tree = $AnimationTree
onready var sprite = $Pivot/Sprite
onready var pivot = $Pivot

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
	
	if (Input.is_action_pressed("move_left") or Input.is_action_pressed("move_right") and on_floor):
		anim_tree["parameters/conditions/roll"] = true
	else:
		anim_tree["parameters/conditions/roll"] = false
	
	linear_vel.y = min(linear_vel.y, fall_speed)
	
	### ATTACK ###
