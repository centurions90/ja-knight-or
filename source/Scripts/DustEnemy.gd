extends Area2D

signal hurt

export(float) var speed = 1

var direction:float

func bounce(var value):
	return -value

func _ready():
	var rand = RandomNumberGenerator.new()
	rand.randomize()
	direction = rand.randi_range(0, 1)
	if direction == 0:
		direction = -1

func _process(delta):
	position.x += direction * speed

func _on_Dust_body_entered(body):
	direction = bounce(direction)
	
	if body.get_name() == 'Platformer Character':
		emit_signal("hurt")
