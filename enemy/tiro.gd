extends Area2D

@onready var sprite = $Sprite2D
@export var damage := 5
@export var direction := Vector2.LEFT
@export var speed := 900


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if(direction.x < 0):
		sprite.flip_h = true
	else:
		sprite.flip_h = false
	
	position += direction * speed * delta


func _on_body_entered(body: Node2D) -> void:
	if body.has_method("take_damage"):
		body.take_damage(damage)
	queue_free()
