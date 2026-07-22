extends Control #comment 


func _on_start_pressed() -> void:
	get_tree().change_scene_to_file("res://scene/GameScene.tscn")



func _on_jumpscare_pressed() -> void:
	$"../billyIsHere".play()
	set_buttons_disabled(true)
	$"../VideoStreamPlayer".paused = true
	$"../billy2".visible = true;
	var chance = randi_range(1, 10)
	if chance == 1:
		$"../billy2".modulate = Color.RED 
		$"../billyIsHere".pitch_scale = 0.8 
		
		AchievementManager.unlock("jumpscare_red", "Billy is angry...")
	else:
		$"../billy2".modulate = Color.WHITE 
		$"../billyIsHere".pitch_scale = 1.0
		
		AchievementManager.unlock("jumpscare", "You saw Billy!!!")
	
	
	await get_tree().create_timer(5.0).timeout
	$"../billy2".visible = false
	set_buttons_disabled(false)
	$"../VideoStreamPlayer".paused = false

func _on_quit_pressed() -> void:
	#get_tree().quit()
	get_tree().change_scene_to_file("res://scene/devScenes/sceneManager.tscn")
	
func set_buttons_disabled(is_disabled: bool) -> void:
	for node in get_tree().get_nodes_in_group("menu_buttons"):
		if node is Button:
			node.disabled = is_disabled


func _on_h_slider_value_changed(value: float) -> void:
	
	$Label.text = "Volume: "+str($HSlider.value)
	var bus_index = AudioServer.get_bus_index("SFX")
	AudioServer.set_bus_volume_db(bus_index, linear_to_db(value))
	AudioServer.set_bus_mute(bus_index, value < 0.01)


func _on_start_2_pressed() -> void:
	get_tree().change_scene_to_file("res://scene/new3d/main_game_world.tscn")
