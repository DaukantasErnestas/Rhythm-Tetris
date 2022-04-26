extends CPUParticles2D

func _ready():
	$SelfDestruct.connect("timeout",self,"on_self_destruct")
	
func on_self_destruct():
	queue_free()
