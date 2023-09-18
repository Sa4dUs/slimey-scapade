extends CharacterBody2D

var tween: Tween

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
		if event.is_action_pressed(dir):
			$Player.texture = load(sprites[dir])
			
			if await move(dir):
				$"SFX/MoveSound".play()				
				
				var game = get_parent().get_parent()
				game.moves += 1
			else:
				$"SFX/CollideSound".play()
				
func get_tile_id(pos):
	var tilemap = $"../TileMap"
	
	if !tilemap:
		return
	
	var tilemap_pos = tilemap.local_to_map(pos)

	var id = tilemap.get_cell_source_id(0, tilemap_pos)
	return id
	
func slime_tile(pos):
	
	var tilemap = $"../TileMap"
	
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
		if collider.is_in_group("Box"):
			if collider.move(dir):
				# shitty bug solving
				await get_tree().create_timer(0.01).timeout
				return await execute_move(dir, true)	

func execute_move(dir, box = false):
	slime_tile(global_position)
	
	tween = create_tween()
	
	var vector_pos = inputs[dir] * grid_size
	
	position += vector_pos		
	
	if get_tile_id(global_position) == 3:
		return await move(dir)
		
	return true
