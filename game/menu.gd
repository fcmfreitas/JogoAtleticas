extends Control

func _ready() -> void:
	$ColorRect/CenterContainer/HBoxContainer/Button.pressed.connect(_on_button_pressed)
	$ColorRect/CenterContainer/HBoxContainer/Button2.pressed.connect(_on_button2_pressed)
	$ColorRect/CenterContainer/HBoxContainer/Button3.pressed.connect(_on_button3_pressed)
	$ColorRect/CenterContainer/HBoxContainer/Button4.pressed.connect(_on_button4_pressed)

func _on_button_pressed() -> void:
	get_tree().change_scene_to_file("res://game/Main.tscn")

func _on_button2_pressed() -> void:
	get_window().set_size(Vector2i(1920, 1080))
	print("Resolução alterada para 1920x1080")

func _on_button3_pressed() -> void:
	get_window().set_size(Vector2i(854, 480))
	#get_viewport_transform()s
	#get_viewport().size(Vector2i(854, 480))
	DisplayServer.window_set_size(Vector2i(854,480))
	print("Resolução alterada para 854x480")

func _on_button4_pressed() -> void:
	get_tree().change_scene_to_file("res://game/Comandos.tscn")
