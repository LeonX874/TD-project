extends CharacterBody2D

var target: Vector2
var Speed = 1000
var pathName = ""
var bulletDamage


func _physics_process(delta):
	var pathSpawnerNode = get_tree().get_root().get_node_or_null("Main/PathSpawner")
	if pathSpawnerNode == null:
		queue_free()
		return

	var found_target := false

	for path in pathSpawnerNode.get_children():
		if path.name == pathName:
			# Make sure the whole chain exists before reading the position
			if path.get_child_count() > 0:
				var follow = path.get_child(0)
				if follow.get_child_count() > 0:
					target = follow.get_child(0).global_position
					found_target = true
			break

	# Enemy is gone (killed or reached the end), so remove the bullet
	if not found_target:
		queue_free()
		return

	velocity = global_position.direction_to(target) * Speed
	look_at(target)
	move_and_slide()


func _on_collision_body_entered(body):
	if "Solider A" in body.name:
		body.Health -= bulletDamage
		queue_free()
