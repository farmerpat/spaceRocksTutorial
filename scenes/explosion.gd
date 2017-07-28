extends AnimatedSprite

func _on_explosion_finished():
	print("clear queue")
	queue_free()