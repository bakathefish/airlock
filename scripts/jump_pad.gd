extends Area2D

const LAUNCH_VELOCITY = -420.0


func _on_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		body.velocity.y = LAUNCH_VELOCITY
		body.jumps_left = 1
		$BounceSound.play()
		# Squash the spring for a moment so the bounce reads.
		$Sprite2D.frame = 107
		await get_tree().create_timer(0.15).timeout
		$Sprite2D.frame = 108
