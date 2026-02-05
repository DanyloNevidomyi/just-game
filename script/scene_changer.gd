extends CanvasLayer

# Використовуємо get_node_or_null, щоб уникнути критичної помилки при запуску
func fade_to_scene(path: String, speed: float = 2.0):
	var rect = get_node_or_null("ColorRect")
	
	if not rect:
		printerr("ПОМИЛКА: ColorRect не знайдено в SceneChanger! Перевір структуру сцени.")
		get_tree().change_scene_to_file(path) # Перемикаємо без анімації, щоб гра не застрягла
		return

	var tween = create_tween()
	# Робимо ColorRect видимим (alpha від 0 до 1)
	tween.tween_property(rect, "modulate:a", 1.0, speed)
	
	tween.finished.connect(func():
		get_tree().change_scene_to_file(path)
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		# Після завантаження нової сцени плавно прибираємо чорний екран
		var tween_in = create_tween()
		tween_in.tween_property(rect, "modulate:a", 0.0, speed)
	)
