extends "res://PieceScripts/PieceMain.gd"

func _ready():
	piece_name = "J"
	spawn_offset = Vector2(-0.5,0)
	rotation_matrix = [
		[Vector2(0,0),Vector2(-1,0),Vector2(-1,-1),Vector2(1,0)],
		[Vector2(0,0),Vector2(0,-1),Vector2(1,-1),Vector2(0,1)],
		[Vector2(0,0),Vector2(1,0),Vector2(1,1),Vector2(-1,0)],
		[Vector2(0,0),Vector2(0,1),Vector2(-1,1),Vector2(0,-1)],
	]
