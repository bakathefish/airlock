extends Node2D

var time_passed = 0.0
var start_hint = ""


func _ready() -> void:
	start_hint = $CanvasLayer/HintLabel.text
	# make 2 or 3 of the first cells duds (random every time)
	var early_cells = [$OxygenCell, $OxygenCell5, $OxygenCell2, $OxygenCell3, $OxygenCell4]
	early_cells.shuffle()
	var duds = randi_range(2, 3)
	for i in duds:
		early_cells[i].dud = true


func _process(delta: float) -> void:
	time_passed += delta
	$CanvasLayer/OxygenLabel.text = "Cells: %d/10" % $Player.oxygen
	$CanvasLayer/TimeLabel.text = "Time: %d:%02d" % [int(time_passed / 60), int(time_passed) % 60]
	$CanvasLayer/AirBar.value = $Player.air

	# flash red when air is low
	if $Player.air < 30:
		if int(time_passed * 4) % 2 == 0:
			$CanvasLayer/AirBar.modulate = Color(1, 0.3, 0.3)
		else:
			$CanvasLayer/AirBar.modulate = Color(1, 1, 1)
	else:
		$CanvasLayer/AirBar.modulate = Color(1, 1, 1)


# show a message for 2 sec then put the normal hint back
func show_hint(text: String) -> void:
	$CanvasLayer/HintLabel.text = text
	await get_tree().create_timer(2.0).timeout
	if $CanvasLayer/HintLabel.text == text:
		$CanvasLayer/HintLabel.text = start_hint
