extends Button


func _on_pressed() -> void:
	Game.Gold = 20
	Game.Health = 10
	get_tree().change_scene_to_file("res://main.tscn")
