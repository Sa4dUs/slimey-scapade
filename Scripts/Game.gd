extends Node2D

var game_end = false
var moves = 0

var current_level = 1

func _ready():
	$SceneManager.load_level_by_id(current_level)

func _process(_delta):
	$UIManager.set_moves(moves)
	
	if !$"Level/Spots":
		return 
	
	var spots = $"Level/Spots".get_child_count()
	for i in $"Level/Spots".get_children():
		if i.occupied:
			spots -= 1
			
	if spots == 0:
		current_level += 1
		$SceneManager.load_level_by_id(current_level)
		$UIManager.set_level(current_level)
		moves = 0
			
func restart_level():
	moves = 0
	$SceneManager.load_level_by_id(current_level)

func _unhandled_input(event):
	if event.is_action_pressed("reset"):
		restart_level()	
		
func _input(event):
	if Input.is_key_pressed(KEY_ESCAPE):
		get_tree().change_scene_to_file("res://Scenes/StartMenu.tscn")

func _on_accept_dialog_confirmed():
	get_parent().next_level()
