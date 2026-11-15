extends Button


func _on_pressed() -> void:
	Game.Gold = 20
	Game.Health = 10
	FadeTransition.change_scene("res://main.tscn")
