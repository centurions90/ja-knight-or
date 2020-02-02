extends Area2D

signal hurt

export(float) var speed = 1

var direction = Vector2()

func bounce():
	var rand = RandomNumberGenerator.new()
	rand.randomize()
	var temp = Vector2(rand.randf_range(-10, 10), rand.randf_range(-10, 10))
	return temp.normalized()



func _ready():
	direction = bounce()

func _process(delta):
	position += direction * speed

func _on_Fire_Enemy_body_entered(body):
	direction = bounce()
	
	var test = body.get_name()
	
	if test == "Platformer Character":
		emit_signal("hurt")
