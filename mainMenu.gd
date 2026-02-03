extends Control

func _on_start_pressed() -> void:
	get_tree().change_scene_to_file("res://GameScene.tscn")



func _on_jumpscare_pressed() -> void:
	set_buttons_disabled(true)
	$"../billy".visible = true;
	var chance = randi_range(1, 10)
	if chance == 1:
		$"../billy".modulate = Color.RED 
		$"../billyIsHere".pitch_scale = 0.8 
	else:
		$"../billyIsHere".pitch_scale = 1.0
	
	$"../billyIsHere".play()
	await get_tree().create_timer(5.0).timeout
	$"../billy".visible = false
	set_buttons_disabled(false)

func _on_quit_pressed() -> void:
	get_tree().quit()
	
func set_buttons_disabled(is_disabled: bool) -> void:
	# Отримуємо всі вузли в групі "buttons" або просто шукаємо всі Button вузли в сцені
	# Найшвидший спосіб для невеликого меню:
	for node in get_tree().get_nodes_in_group("menu_buttons"):
		if node is Button:
			node.disabled = is_disabled
