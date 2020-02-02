extends Camera2D

export(float) var displace
export(float) var left
export(float) var right

onready var shaker = $"../Camera Shaker"
onready var player = $"../Platform Character"

func _process(delta):
	if Input.is_action_pressed("move_left"):
		position.x = lerp(position.x, player.position.x - displace, 0.03)
	elif Input.is_action_pressed("move_right"):
		position.x = lerp(position.x, player.position.x + displace, 0.03)
	else:
		position.x = lerp(position.x, player.position.x, 0.01)
	
	position.x = clamp(position.x, left, right)
	
	position += shaker.position
	rotation = shaker.rotation
