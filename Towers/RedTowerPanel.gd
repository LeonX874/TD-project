extends Panel

@onready var tower = preload("res://Towers/RedBullet.tscn")

const DIRT_TILE := Vector2i(4, 5)
const DELETE_X := 2944
const TOWER_COST := 10
const PREVIEW_SCALE := Vector2(0.32, 0.32)

var preview: Node2D = null
var original_scale := Vector2.ONE


func _on_gui_input(event):
	# --- Mouse pressed: start dragging a preview tower ---
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		if Game.Gold >= TOWER_COST and preview == null:
			preview = tower.instantiate()
			original_scale = preview.scale
			add_child(preview)
			preview.global_position = event.global_position
			preview.scale = PREVIEW_SCALE
			preview.process_mode = Node.PROCESS_MODE_DISABLED

	# --- Mouse moving while left button is held: drag the preview ---
	elif event is InputEventMouseMotion and (event.button_mask & MOUSE_BUTTON_MASK_LEFT):
		if preview == null:
			return
		preview.global_position = event.global_position
		var area = preview.get_node("Area")
		area.modulate = Color.GREEN if _is_valid_spot() else Color.WHITE

	# --- Mouse released: place the tower or cancel ---
	elif event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and not event.pressed:
		if preview == null:
			return

		var over_delete_zone: bool = event.global_position.x >= DELETE_X
		var can_place: bool = not over_delete_zone and Game.Gold >= TOWER_COST and _is_valid_spot()

		if can_place:
			var towers_node = get_tree().get_root().get_node("Main/Towers")
			remove_child(preview)
			towers_node.add_child(preview)
			preview.global_position = event.global_position
			preview.scale = original_scale
			preview.process_mode = Node.PROCESS_MODE_INHERIT
			preview.get_node("Area").hide()
			Game.Gold -= TOWER_COST
		else:
			preview.queue_free()

		preview = null


func _is_valid_spot() -> bool:
	if preview == null:
		return false

	var map = get_tree().get_root().get_node("Main/TileMap")
	var tile = map.local_to_map(get_global_mouse_position())
	var tile_coords = map.get_cell_atlas_coords(0, tile, false)

	if tile_coords != DIRT_TILE:
		return false

	var targets = preview.get_node("TowerDetector").get_overlapping_bodies()
	return targets.size() < 2
