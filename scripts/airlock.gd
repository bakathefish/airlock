extends Area2D

const CELLS_NEEDED = 10


func _on_body_entered(body: Node2D) -> void:
	if body.name != "Player":
		return
	if body.oxygen >= CELLS_NEEDED:
		body.set_physics_process(false)
		Global.last_time = get_parent().time_passed
		$OpenSound.play()
		await get_tree().create_timer(1.2).timeout
		get_tree().change_scene_to_file("res://scenes/end.tscn")
	else:
		# not enough cells, and you can't go back from here so restart
		var hint = get_parent().get_node("CanvasLayer/HintLabel")
		hint.text = "Airlock sealed. You left cells behind (%d/%d). Try again!" % [body.oxygen, CELLS_NEEDED]
		body.set_physics_process(false)
		body.velocity = Vector2.ZERO
		await get_tree().create_timer(2.0).timeout
		get_tree().reload_current_scene()
