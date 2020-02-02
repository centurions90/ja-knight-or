extends Label

func _process(delta):
	if Input.is_action_pressed("attack"):
		queue_free()
