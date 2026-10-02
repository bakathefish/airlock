extends Area2D

# how much air a good cell gives back
const AIR_REFILL = 40.0
# dud stuff
const DUD_AIR_LOSS = 10.0
const DUD_STUN = 0.7

# main.gd turns some of the early cells into duds
var dud = false


func _on_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		body.oxygen += 1
		if dud:
			body.air -= DUD_AIR_LOSS
			body.stunned = DUD_STUN
			$CollectSound.pitch_scale = 0.5
			get_parent().show_hint("That cell was a dud! It zapped you and leaked your air.")
		else:
			body.air = min(body.air + AIR_REFILL, body.MAX_AIR)
		$CollectSound.play()
		hide()
		$CollisionShape2D.set_deferred("disabled", true)
		await $CollectSound.finished
		queue_free()
