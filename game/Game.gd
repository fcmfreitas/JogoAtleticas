extends Node2D

@export var player: CharacterBody2D
@export var camera: Camera2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	get_tree().call_group("Player","print_position")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if player.position.y > 1500: 
		get_tree().change_scene_to_file("res://game/GameOver.tscn")
	if player.position.x > 2500:
		camera.zoom = camera.zoom.lerp(Vector2(0.7, 0.7), 0.05)
	
	pass
