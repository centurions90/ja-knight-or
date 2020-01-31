extends KinematicBody2D

# pixels per second
export(float) var walk_speed = 280

export(float, 0, 1) var walk_acceleration = 2
export(float, 0, 1) var walk_deceleration = 4

export(float) var jump_height = 480

# doesn't work yet
export(float) var fall_speed = 20
export(float) var fall_acceleration = 4

var floor_normal = Vector2(0, -1)
var linear_vel = Vector2()

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
	if Input.is_action_pressed("move_right"):
		target_speed += 1.0
	
	# Acceleration and deceleration
	var acceleration = 0
	if target_speed != 0:
		acceleration = walk_acceleration
	else:
		acceleration = walk_deceleration
	linear_vel.x = lerp(linear_vel.x, target_speed * walk_speed, acceleration)

	# Jumping
	if on_floor and Input.is_action_just_pressed("jump"):
		linear_vel.y = -jump_height
