extends Node2D

@onready var bg = $bg

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	bg.play()
