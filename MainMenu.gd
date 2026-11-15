extends Node2D

@onready var sfx = $Click_sfx
@onready var settings = $Settings_sfx

func Start() -> void:
	sfx.play()
	FadeTransition.change_scene("res://main.tscn")

func Options() -> void:
	settings.play()
	FadeTransition.change_scene("")

func Quit() -> void:
	sfx.play()
	get_tree().quit();
