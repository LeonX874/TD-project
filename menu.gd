extends Button


func _process(delta: float) -> void:
	get_tree().change_scene_to_file("res://MainMenu.tscn")
