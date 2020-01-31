extends KinematicBody2D

export(float) var gravity = 900

# pixels per second
export(float) var walk_speed = 250

# doesn't work yet
export(float) var walk_acceleration = 2
# doesn't work yet
export(float) var walk_deceleration = 4

export(float) var jump_height = 480
# doesn't work yet
export(float) var jump_speed = 20

# doesn't work yet
export(float) var fall_speed = 20

var floor_normal = Vector2(0, -1)
var linear_vel = Vector2()

func _physics_process(delta):
	# Apply gravity
	linear_vel.y += delta * gravity
	# Move and slide
	linear_vel = move_and_slide(linear_vel, floor_normal)
	# Detect if we are on floor - only works if called *after* move_and_slide
	var on_floor = is_on_floor()

	### CONTROL ###

	# Horizontal movement
	var target_speed = 0
	if Input.is_action_pressed("move_left"):
		target_speed -= 1
	if Input.is_action_pressed("move_right"):
		target_speed += 1

	target_speed *= walk_speed
	linear_vel.x = lerp(linear_vel.x, target_speed, 0.1)

	# Jumping
	if on_floor and Input.is_action_just_pressed("jump"):
		linear_vel.y = -jump_height
