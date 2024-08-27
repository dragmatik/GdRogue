extends GPUParticles2D

func _ready() -> void:
	emitting = true
	one_shot = true
	
	$Sub_Particles.emitting = true
	$Sub_Particles.one_shot = true
	
	$Dust.emitting = true
	$Dust.one_shot = true
	
	$Timer.start(2)
	
func _on_timer_timeout() -> void:
	queue_free()
