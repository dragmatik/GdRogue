extends Node

func impact(x: bool) -> void:
	if not x: # not flipped (looking right)
		$Impact_2.flip_h = true
		$Impact_3.flip_h = true
	else:
		$Impact_2.flip_h = false
		$Impact_3.flip_h = false
	var animations: Array = ["a", "b", "c", "d"]
	var random_animation: String = animations[randi() % animations.size()]
	$Animation.play(random_animation)
	await $Animation.animation_finished
	queue_free()
