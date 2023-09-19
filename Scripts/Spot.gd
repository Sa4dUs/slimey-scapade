extends Area2D

var occupied = false

func _on_body_entered(body):
	if body.is_in_group("Coin"):
		$"SFX/OccupySound".play()
		await get_tree().create_timer(0.2).timeout 
		occupied = true


func _on_body_exited(body):
	if body.is_in_group("Coin"):
		occupied = false
