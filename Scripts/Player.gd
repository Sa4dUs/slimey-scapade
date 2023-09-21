extends CharacterBody2D

var last_move_success = false

var can_move = true 

var first_position_change = true

var grid_size = 16

var inputs = {
	"ui_up": Vector2.UP,
	"ui_down": Vector2.DOWN,
	"ui_left": Vector2.LEFT,
	"ui_right": Vector2.RIGHT
}


var sprites = {
	"ui_up": "res://Assets/Sprites/player_back.png",
	"ui_down": "res://Assets/Sprites/player_front.png",
	"ui_left": "res://Assets/Sprites/player_left.png",
	"ui_right": "res://Assets/Sprites/player_right.png"
}

func _unhandled_input(event):
	for dir in inputs.keys():
		if event.is_action_pressed(dir) and can_move:
			can_move = false
			$Player.texture = load(sprites[dir])
			
			if await move(dir):
				$"SFX/MoveSound".play()				
			else:
				$"SFX/CollideSound".play()
			
			last_move_success = false
			first_position_change = true
			can_move = true	
			
			var game = get_parent().get_parent().get_parent()
		
			if game.name == "GameManager":
				if self.name == "Player":
					game.logical_moves()
			
			
func get_tile_id(pos):
	var tilemap = $"../../TileMap"
	
	if !tilemap:
		return
	
	var tilemap_pos = tilemap.local_to_map(pos)

	var id = tilemap.get_cell_source_id(0, tilemap_pos)
	return id
	
func slime_tile(pos):
	
	var tilemap = $"../../TileMap"
	
	if !tilemap:
		return
	
	var tilemap_pos = tilemap.local_to_map(pos)
	
	if get_tile_id(pos) == 2:
		tilemap.set_cell(0, tilemap_pos, 3, Vector2i(0, 0))
			
func move(dir):	
	var vector_pos = inputs[dir] * grid_size
	
	# begin
	var space = get_world_2d().direct_space_state
	var from = global_position + Vector2(grid_size/2, grid_size/2)
	var to = from + vector_pos
	var query = PhysicsRayQueryParameters2D.create(from, to)
	var result = space.intersect_ray(query)
	# end
	
	if !result:
		return await execute_move(dir)
	else:
		var collider = result.collider
		if collider.is_in_group("Coin") or collider.is_in_group("Box"):
			if collider.move(dir):
				# shitty bug solving
				await get_tree().create_timer(0.01).timeout
				return await execute_move(dir)	

func execute_move(dir):
	slime_tile(global_position)
	
	var vector_pos = inputs[dir] * grid_size
	
	position += vector_pos	
	
	if first_position_change:
		var game = get_parent().get_parent().get_parent()
		
		
		if game.name == "GameManager":
			game.has_moved[get_child_index()] = true
				
		first_position_change = false
		
	
	last_move_success = true	
	
	if get_tile_id(global_position) == 3:
		return await move(dir)
		
	return true

func get_child_index():
	var parent_node = get_parent()
	for i in range(parent_node.get_child_count()):
		if parent_node.get_child(i) == self:
			return i
			
