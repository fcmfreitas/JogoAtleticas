extends Node2D

@export var player: CharacterBody2D
@export var raposa: CharacterBody2D
@export var camera: Camera2D

var camera_locked_on_raposa := false
var offset_y := 270 
var offset_x := 170
var camera_tween: Tween = null

func _process(delta: float) -> void:
	if not (player and raposa and camera):
		return

	var distancia = player.global_position.distance_to(raposa.global_position)

	# Quando jogador se aproxima, inicia foco na raposa
	if distancia < 1170 and not camera_locked_on_raposa:
		camera_locked_on_raposa = true

		# Transição suave de zoom e posição
		camera_tween = get_tree().create_tween()
		camera_tween.tween_property(camera, "zoom", Vector2(0.7, 0.7), 1.0)
		camera_tween.tween_property(camera, "global_position", raposa.global_position + Vector2(offset_x, offset_y), 1.0)

	# Após travar a câmera na raposa, continua seguindo ela
	if camera_locked_on_raposa and not (camera_tween and camera_tween.is_running()):
		camera.global_position = raposa.global_position + Vector2(offset_x, offset_y)
