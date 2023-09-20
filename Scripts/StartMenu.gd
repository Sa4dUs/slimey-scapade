extends Node2D

var moves = [0, 0, 0, 0]

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	var playSpot = $"Level/Spots/PlaySpot"
	var quitSpot = $"Level/Spots/QuitSpot"
	
	if playSpot.occupied:
		get_tree().change_scene_to_file("res://Scenes/LevelManager.tscn")
		
	if quitSpot.occupied:
		get_tree().quit()
