extends Sprite

var inactive = true
var indestructible = false
var temporary = false
var existance_frame = 0

func _ready():
	if temporary:
		modulate.a = 0.5

func _process(delta):
	if temporary:
		existance_frame += 1
		modulate.a -= 0.01
		if existance_frame >= 120:
			queue_free()
