extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_game_scene_pressed() -> void:
	get_tree().change_scene_to_file("res://scene/GameScene.tscn")


func _on_main_world_scene_pressed() -> void:
	get_tree().change_scene_to_file("res://scene/new3d/main_game_world.tscn")

func _on_level_1_pressed() -> void:
	get_tree().change_scene_to_file("res://scene/level_1.tscn")


func _on_level_1_redone_pressed() -> void:
	get_tree().change_scene_to_file("res://level_1_redone.tscn")


func _on_main_menu_pressed() -> void:
	get_tree().change_scene_to_file("res://scene/mainMenu.tscn")
