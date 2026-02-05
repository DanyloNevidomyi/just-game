extends CanvasLayer

@onready var label = $Panel/AchivementName
@onready var texture_rect = $Panel/TextureRect 

func display(title: String, icon: Texture2D, icon_color: Color):
	label.text = title
	texture_rect.texture = icon
	texture_rect.modulate = icon_color 
	
	$AnimationPlayer.play("achivement")
	await $AnimationPlayer.animation_finished
	queue_free()
