extends Area2D

@onready var sprite = $Sprite2D
@export var damage := 100
@export var direction := Vector2.UP  # Move para cima
@export var speed := 800

func _process(delta):
	#print("print")
	position += direction * speed * delta
	
	
func _ready() -> void:
	#print("fffff")
	set_process(true)


func _on_body_entered(body):
	if body.has_method("take_damage"):
		body.take_damage(damage)
	queue_free()
