extends ParallaxLayer

onready var timer = $Timer
onready var label = $Label

func _process(delta):
	label.text = str(int(timer.time_left))
