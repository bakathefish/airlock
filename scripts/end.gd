extends Control


func _ready() -> void:
	$Label.text = "Airlock open. You made it in %d:%02d!" % [int(Global.last_time / 60), int(Global.last_time) % 60]


func _on_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/main.tscn")
