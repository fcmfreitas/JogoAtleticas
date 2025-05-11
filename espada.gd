extends Area2D

@onready var sprite = $Sprite2D
var direction := Vector2.RIGHT
var speed := 600

func _process(delta):
	sprite.flip_h = direction == Vector2.LEFT

	position += direction * speed * delta

func _on_body_entered(body):
	queue_free()
