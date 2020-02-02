extends Node2D

export(float) var max_shake = 15
export(float, 0, 1) var shake_add_value = 0.196
export(float, 0, 1) var shake_reduce_speed = 0.859
export(float) var max_rot = 0.1

var shake = 0
onready var init_pos = position
onready var init_rot = rotation
var rand = RandomNumberGenerator.new()

func convertShake(var value):
	return sqrt(value)

func shakeCam():
	shake = clamp(shake + shake_add_value, 0, 1)

func shakeBy(var value):
	shake = clamp(shake + value, 0, 1)
func _ready():
	rand.randomize()

func _process(delta):
	var s = convertShake(shake)
	position = init_pos + Vector2(rand.randf_range(-max_shake, max_shake) * s, rand.randf_range(-max_shake, max_shake) * s)
	rotation = init_rot + rand.randf_range(-max_rot, max_rot) * s
	
	shake = clamp(shake - shake_reduce_speed * delta, 0, 1)
