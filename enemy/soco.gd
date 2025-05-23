extends Area2D

@onready var sprite = $Sprite2D
@export var damage := 25
@export var direction := Vector2.DOWN
@export var speed := 800

func _on_body_entered(body: Node2D) -> void:
	if body.has_method("take_damage"):
		body.take_damage(damage)
	queue_free()

func _on_ready() -> void:
	pass # Replace with function body.
