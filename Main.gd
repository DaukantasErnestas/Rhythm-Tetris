extends Node2D

var move_dir = Vector2(0,1)

onready var Block = preload("res://Block.tscn")
onready var block_clear_particles = preload("res://VFX/BlockClearParticles.tscn")
onready var PieceI = preload("res://Pieces/I.tscn")
onready var PieceJ = preload("res://Pieces/J.tscn")
onready var PieceL = preload("res://Pieces/L.tscn")
onready var PieceO = preload("res://Pieces/O.tscn")
onready var PieceS = preload("res://Pieces/S.tscn")
onready var PieceZ = preload("res://Pieces/Z.tscn")
onready var PieceT = preload("res://Pieces/T.tscn")

onready var piece_names = {"I":PieceI,"J":PieceJ,"L":PieceL,"O":PieceO,"S":PieceS,"T":PieceT,"Z":PieceZ}
onready var all_pieces = [PieceI,PieceJ,PieceL,PieceO,PieceS,PieceT,PieceZ]
onready var pieces = []


onready var normal_fall_speed = 0.01
onready var soft_drop_fall_speed = 10

onready var place_time = 0.5
onready var soft_drop_place_time = 0.25

var held_piece = null
var ghost_piece = null
var ghost_transparency = 0.25

var RNG = RandomNumberGenerator.new()

func _init():
	Global.main_scene = self

func _ready():
	Global.main_scene = self
	make_new_piece()
	$TickTimer.wait_time = 1.0/normal_fall_speed
	$PlaceTimer.wait_time = place_time
	Global.block_size *= scale.x

func _process(delta):
	update_ghost_piece()

func make_new_piece():
	if pieces.size() == 0:
		pieces = all_pieces.duplicate()
		pieces.shuffle()
	RNG.randomize()
	var chosen_piece = RNG.randi_range(0,pieces.size()-1)
	var piece_instance = pieces[chosen_piece].instance()
	pieces.remove(chosen_piece)
	piece_instance.global_position = Vector2(10*Global.block_size/2,Global.block_size)
	$Pieces.add_child(piece_instance)
	Global.current_piece = piece_instance
	for ghost in $GhostBlocks.get_children():
		ghost.queue_free()
	var ghost_instance = piece_names[Global.current_piece.piece_name].instance()
	$GhostBlocks.add_child(ghost_instance)
	ghost_instance.modulate.a = ghost_transparency
	ghost_piece = ghost_instance

func check_lines():
	for y in range(20):
		var pieces_count = 0
		var found_pieces = []
		var y_coords = []
		var found_pieces_max_y = 900
		for x in range(10):
			if Global.placed_block_positions.has(Vector2(x*Global.block_size,y*Global.block_size)):
				var placed_block_index = Global.placed_block_positions.find(Vector2(x*Global.block_size,y*Global.block_size))
				if Global.placed_blocks[placed_block_index].indestructible == false:
					pieces_count += 1
					found_pieces.append(placed_block_index)
		found_pieces.sort()
		found_pieces.invert()
		if pieces_count >= 10:
			for piece in found_pieces:
				var particles_instance = block_clear_particles.instance()
				particles_instance.global_position = Global.placed_block_positions[piece] + Vector2(15,15)
				particles_instance.emitting = true
				particles_instance.modulate = Global.placed_blocks[piece].get_parent().modulate
				add_child(particles_instance)
				if Global.placed_block_positions[piece].y < found_pieces_max_y:
					found_pieces_max_y = Global.placed_block_positions[piece].y
				if !y_coords.has(Global.placed_block_positions[piece].y):
					y_coords.append(Global.placed_block_positions[piece].y)
				Global.placed_blocks[piece].queue_free()
				Global.placed_blocks.remove(piece)
				Global.placed_block_positions.remove(piece)
			for piece in Global.placed_blocks:
				if piece.global_position.y < found_pieces_max_y and piece.indestructible == false:
					piece.global_position.y += y_coords.size()*Global.block_size
			for piece in Global.placed_block_positions:
				var found_piece_index = Global.placed_block_positions.find(piece)
				if piece.y < found_pieces_max_y and Global.placed_blocks[found_piece_index].indestructible == false:
					 Global.placed_block_positions[found_piece_index] = Vector2(piece.x,piece.y + y_coords.size()*Global.block_size)
		found_pieces.clear()

func check_movement_input_x_manual():
	move_dir.x = int(Input.is_action_pressed("Right")) - int(Input.is_action_pressed("Left"))
	$PreDASTimer.stop()
	$DASTimer.stop()
	if move_dir.x == -1 or move_dir.x == 1:
		$PreDASTimer.start()
		
func _input(event):
	if event.is_action_pressed("Left"):
		$PreDASTimer.start()
		$DASTimer.stop()
		move_dir.x = -1
	elif event.is_action_released("Left"):
		$PreDASTimer.stop()
		$DASTimer.stop()
		move_dir.x = 0
		check_movement_input_x_manual()
	if event.is_action_pressed("Right"):
		$PreDASTimer.start()
		$DASTimer.stop()
		move_dir.x = 1
	elif event.is_action_released("Right"):
		$PreDASTimer.stop()
		$DASTimer.stop()
		move_dir.x = 0
		check_movement_input_x_manual()
	if Input.is_action_pressed("Left") and Input.is_action_pressed("Right"):
		$PreDASTimer.stop()
		$DASTimer.stop()
		move_dir.x = 0
	Global.current_piece.move_x(move_dir.x)
	if event.is_action_pressed("rotate_clockwise"):
		Global.current_piece.rotate(1)
		update_ghost_piece_rotation()
	if event.is_action_pressed("rotate_counterclockwise"):
		Global.current_piece.rotate(-1)
		update_ghost_piece_rotation()
	if event.is_action_pressed("rotate_180"):
		Global.current_piece.rotate_180()
		update_ghost_piece_rotation()
	if event.is_action_pressed("soft_drop"):
		$TickTimer.wait_time = 1.0/soft_drop_fall_speed
		$TickTimer.start()
		$PlaceTimer.wait_time = soft_drop_place_time
	if event.is_action_released("soft_drop"):
		$TickTimer.wait_time = 1.0/normal_fall_speed
		$PlaceTimer.wait_time = place_time
	if event.is_action_pressed("hard_drop"):
		var on_ground = false
		while on_ground == false:
			on_ground = Global.current_piece.move(true)
		$Tween.stop_all()
		material.set_shader_param("time_stamp",0)
		$Tween.interpolate_property(material,"shader_param/time_stamp",null,PI/10,0.1,Tween.TRANS_LINEAR,Tween.EASE_IN_OUT)
		$Tween.start()
	if event.is_action_pressed("hold"):
		if held_piece != null:
			var piece_instance = piece_names[held_piece].instance()
			piece_instance.global_position = Vector2(10*Global.block_size/2,Global.block_size)
			$Pieces.add_child(piece_instance)
			held_piece = Global.current_piece.piece_name
			Global.current_piece.queue_free()
			Global.current_piece = piece_instance
			for ghost in $GhostBlocks.get_children():
				ghost.queue_free()
			var ghost_instance = piece_names[Global.current_piece.piece_name].instance()
			$GhostBlocks.add_child(ghost_instance)
			ghost_instance.modulate.a = ghost_transparency
			ghost_piece = ghost_instance
			update_hold_visual()
		else:
			held_piece = Global.current_piece.piece_name
			Global.current_piece.queue_free()
			make_new_piece()
			update_hold_visual()

func update_hold_visual():
	if get_parent().get_node("ThingsSide/Hold/BlockPos").get_children().size() != 0:
		for visual_piece in get_parent().get_node("ThingsSide/Hold/BlockPos").get_children():
			visual_piece.queue_free()
		var piece_instance = piece_names[held_piece].instance()
		get_parent().get_node("ThingsSide/Hold/BlockPos").add_child(piece_instance)
		piece_instance.position = piece_instance.spawn_offset * Global.block_size
	else:
		var piece_instance = piece_names[held_piece].instance()
		get_parent().get_node("ThingsSide/Hold/BlockPos").add_child(piece_instance)
		piece_instance.position = piece_instance.spawn_offset * Global.block_size

func update_ghost_piece_rotation():
	var block_index = 0
	var current_piece_blocks = Global.current_piece.get_children()
	for block in ghost_piece.get_children():
		block.position = current_piece_blocks[block_index].position
		block_index += 1

func update_ghost_piece():
	ghost_piece.global_position = Global.current_piece.global_position
	var on_ground = false
	while !on_ground:
		on_ground = ghost_piece.move(false)

func _on_TickTimer_timeout():
	Global.current_piece.move(false)

func _on_PreDASTimer_timeout():
	$DASTimer.start()

func _on_DASTimer_timeout():
	Global.current_piece.move_x(move_dir.x)

func _on_PlaceTimer_timeout():
	Global.current_piece.deactivate_piece()
	check_lines()
	make_new_piece()
	
func _on_Tween_tween_completed(object, key):
	material.set_shader_param("time_stamp",0)
