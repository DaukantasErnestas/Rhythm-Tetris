extends Node2D

var rotation_index = 0
var rotation_matrix = []
var piece_name = ""
var spawn_offset = Vector2(0,0)

export(bool) var inactive = false
export(bool) var indestructible = false
export(bool) var ghost = false

onready var bop_shader = preload("res://VFX/BobShader.tres")

func _ready():
	for block in get_children():
		block.inactive = inactive
		block.indestructible = indestructible
		block.material = bop_shader
	if inactive:
		deactivate_piece()

func move(hard_drop) -> bool:
	if check_gravity():
		global_position.y += Global.block_size
		return false
	else:
		if hard_drop:
			deactivate_piece()
			Global.main_scene.check_lines()
			Global.main_scene.make_new_piece()
		return true

func hard_drop():
	var on_ground = false
	while on_ground == false:
		on_ground = move(true)

func can_move_x(dirx) -> bool:
	for block in get_children():
		if !Global.placed_block_positions.has(block.global_position+Vector2(Global.block_size*dirx,0)):
			continue
		else:
			return false
	return true

func move_x(dirx) -> void:
	if can_move_x(dirx):
		global_position.x += Global.block_size*dirx
	
func deactivate_piece() -> void:
	for block in get_children():
		block.inactive = true
		inactive = true
		Global.placed_blocks.append(block)
		Global.placed_block_positions.append(Global.main_scene.to_local(block.global_position))
	
func check_gravity() -> bool:
	for block in get_children():
		if block.global_position.y + Global.block_size < Global.main_scene.global_position.y + Global.block_size*20 and !Global.placed_block_positions.has(block.global_position+Vector2(0,Global.block_size)):
			continue
		else:
			return false
	return true
		
		
func check_rotation(dir):
	var old_positions = []
	var block_index = 0
	for block in get_children():
		old_positions.append(block.position)
		block.position = rotation_matrix[rotation_index][block_index]*Global.block_size
		block_index += 1
	if dir == 1:
		if piece_name != "I" and piece_name != "O":
			for kick in WallKickData.wall_kick_data_main["cw"][rotation_index]:
				var correct_pieces = 0
				for block in get_children():
					if !Global.placed_block_positions.has(Vector2(block.global_position.x+kick.x*Global.block_size,block.global_position.y+kick.y*Global.block_size)):
						correct_pieces += 1
						continue
					else:
						break
				if correct_pieces == 4:
					return kick
				else:
					print("no_kick")
			block_index = 0
			for block in get_children():
				block.position = old_positions[block_index]
				block_index += 1
			return null
		elif piece_name == "I":
			for kick in WallKickData.wall_kick_data_I["cw"][rotation_index]:
				var correct_pieces = 0
				for block in get_children():
					if !Global.placed_block_positions.has(Vector2(block.global_position.x+kick.x*Global.block_size,block.global_position.y+kick.y*Global.block_size)):
						correct_pieces += 1
						continue
					else:
						break
				if correct_pieces == 4:
					return kick
			block_index = 0
			for block in get_children():
				block.position = old_positions[block_index]
				block_index += 1
			return null
		else:
			return Vector2(0,0)
	elif dir == -1:
		if piece_name != "I" and piece_name != "O":
			for kick in WallKickData.wall_kick_data_main["ccw"][rotation_index]:
				var correct_pieces = 0
				for block in get_children():
					if !Global.placed_block_positions.has(Vector2(block.global_position.x+kick.x*Global.block_size,block.global_position.y+kick.y*Global.block_size)):
						correct_pieces += 1
						continue
					else:
						break
				if correct_pieces == 4:
					return kick
			block_index = 0
			for block in get_children():
				block.position = old_positions[block_index]
				block_index += 1
			return null
		elif piece_name == "I":
			for kick in WallKickData.wall_kick_data_main["ccw"][rotation_index]:
				var correct_pieces = 0
				for block in get_children():
					if !Global.placed_block_positions.has(Vector2(block.global_position.x+kick.x*Global.block_size,block.global_position.y+kick.y*Global.block_size)):
						correct_pieces += 1
						continue
					else:
						break
				if correct_pieces == 4:
					return kick
			block_index = 0
			for block in get_children():
				block.position = old_positions[block_index]
				block_index += 1
			return null
		else:
			return Vector2(0,0)
		
func rotate(dir):
	var previous_rot_index = rotation_index
	if dir == 1:
		if rotation_index < 3:
			rotation_index += dir
		else:
			rotation_index = 0
	elif dir == -1:
		if rotation_index > 0:
			rotation_index += dir
		else:
			rotation_index = 3
	var rotation_check_result = check_rotation(dir)
	if rotation_check_result != null:
		var block_index = 0
		for block in get_children():
			block.position = rotation_matrix[rotation_index][block_index]*Global.block_size
			block_index += 1
		global_position += rotation_check_result*Global.block_size
		if !Global.main_scene.get_node("PlaceTimer").is_stopped():
			Global.main_scene.get_node("PlaceTimer").start()
	else:
		rotation_index = previous_rot_index

func check_rotation_180():
	var old_positions = []
	var block_index = 0
	for block in get_children():
		old_positions.append(block.position)
		block.position = rotation_matrix[rotation_index][block_index]*Global.block_size
		block_index += 1
	if piece_name != "I" and piece_name != "O":
		for kick in WallKickData.wall_kick_data_main_180[rotation_index]:
			var correct_pieces = 0
			print(kick)
			for block in get_children():
				if !Global.placed_block_positions.has(Vector2(block.global_position.x+kick.x*Global.block_size,block.global_position.y+kick.y*Global.block_size)):
					correct_pieces += 1
					continue
				else:
					break
			if correct_pieces == 4:
				return kick
		block_index = 0
		for block in get_children():
			block.position = old_positions[block_index]
			block_index += 1
		return null
	if piece_name != "O":
		for kick in WallKickData.wall_kick_data_I_180[rotation_index]:
			var correct_pieces = 0
			for block in get_children():
				if !Global.placed_block_positions.has(Vector2(block.global_position.x+kick.x*Global.block_size,block.global_position.y+kick.y*Global.block_size)):
					correct_pieces += 1
					continue
				else:
					break
			if correct_pieces == 4:
				return kick
		block_index = 0
		for block in get_children():
			block.position = old_positions[block_index]
			block_index += 1
		return null
	else:
		return Vector2(0,0)

func rotate_180():
	var previous_rot_index = rotation_index
	if rotation_index + 2 <= 3:
		rotation_index += 2
	else:
		rotation_index -= 2
	print(rotation_index)
	var rotation_check_result = check_rotation_180()
	print(rotation_check_result)
	if rotation_check_result != null:
		var block_index = 0
		for block in get_children():
			block.position = rotation_matrix[rotation_index][block_index]*Global.block_size
			block_index += 1
		global_position += rotation_check_result*Global.block_size
		if !Global.main_scene.get_node("PlaceTimer").is_stopped():
			Global.main_scene.get_node("PlaceTimer").start()
	else:
		rotation_index = previous_rot_index

func _process(delta):
	if get_children().size() == 0:
		queue_free()
	if !inactive and !ghost:
		var gravity_check_result = check_gravity()
		if !gravity_check_result and Global.main_scene.get_node("PlaceTimer").is_stopped():
			Global.main_scene.get_node("PlaceTimer").start()
