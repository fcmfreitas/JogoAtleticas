extends Area2D

@onready var sprite = $Sprite2D
@export var damage := 25
@export var direction := Vector2.RIGHT
@export var speed := 1000

func _process(delta):
	
	if(direction.x < 0):
		sprite.flip_h = true
		rotation -= deg_to_rad(360) * delta
	else:
		sprite.flip_h = false
		rotation += deg_to_rad(360) * delta
	
	position += direction * speed * delta

func _on_body_entered(body):
	if body.has_method("take_damage"):
		body.take_damage(damage)
	queue_free()
