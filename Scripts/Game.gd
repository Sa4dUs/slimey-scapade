extends Node2D

var game_end = false
var moves = 0
var has_moved = [false, false, false, false]

var number_of_levels = 5 

var current_level = 1
var current_bonus_level = 1

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
		if current_level <= number_of_levels:
			$SceneManager.load_level_by_id(current_level)
			$UIManager.set_level(current_level)
			moves = 0
			
		else:
			$SceneManager.load_bonus_level_by_id(current_bonus_level)
			$UIManager.set_bonus_level(current_bonus_level)
			
			current_bonus_level += 1
			moves = 0
			
func restart_level():
	moves = 0
	
	if current_level <= number_of_levels:
		$SceneManager.load_level_by_id(current_level)
	else:
		$SceneManager.load_bonus_level_by_id(current_bonus_level - 1)
	

func _unhandled_input(event):
	if event.is_action_pressed("reset"):
		restart_level()	
		
func _input(event):
	if Input.is_key_pressed(KEY_ESCAPE):
		get_tree().change_scene_to_file("res://Scenes/StartMenu.tscn")
	
func multiple_changes(a, b):
	for i in range(a.size()):
		if abs(a[i] - b[i]) > 1:
			return true
	return false
	
func logical_moves():
	for i in range(has_moved.size()):
		if has_moved[i]:
			moves += 1
			has_moved.fill(false)
			return
