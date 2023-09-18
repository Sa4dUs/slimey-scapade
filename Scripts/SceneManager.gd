extends Node2D

signal level_cleared

func next_level():
	emit_signal("level_cleared")

func load_level_by_id(id):
	var root = get_tree().get_current_scene()
	
	var node = root.get_node("Level")
	
	if node:
		root.remove_child(node)
		
	var next_scene = load("res://Levels/Level%s.tscn"%(str(id)))
	
	if next_scene:
		root.add_child(next_scene.instantiate())
	else:
		get_tree().change_scene_to_file("res://Scenes/GameOver.tscn")
		
