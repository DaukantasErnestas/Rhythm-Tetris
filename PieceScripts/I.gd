extends "res://PieceScripts/PieceMain.gd"

func _ready():
	piece_name = "I"
	visual_spawn_offset = Vector2(-1,-0.5)
	spawn_offset = Vector2(-1,0)
	rotation_matrix = [
		[Vector2(0,0),Vector2(-1,0),Vector2(1,0),Vector2(2,0)],
		[Vector2(1,0),Vector2(1,-1),Vector2(1,1),Vector2(1,2)],
		[Vector2(1,1),Vector2(2,1),Vector2(0,1),Vector2(-1,1)],
		[Vector2(0,0),Vector2(0,-1),Vector2(0,1),Vector2(0,2)],
	]
