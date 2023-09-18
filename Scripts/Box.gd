extends CharacterBody2D

var grid_size = 16

var inputs = {
	"ui_up": Vector2.UP,
	"ui_down": Vector2.DOWN,
	"ui_left": Vector2.LEFT,
	"ui_right": Vector2.RIGHT
}
			
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
		execute_move(dir)
		return true

	return false
	
func get_tile_id(pos):
	var tilemap = $"../../TileMap"
	var tilemap_pos = tilemap.local_to_map(pos)

	var id = tilemap.get_cell_source_id(0, tilemap_pos)
	return id

func execute_move(dir):
	var vector_pos = inputs[dir] * grid_size	
	position += vector_pos
	if get_tile_id(global_position) == 3:
		move(dir)
		
	return 
