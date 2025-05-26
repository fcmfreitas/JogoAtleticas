extends Area2D

@onready var preAtack = $AnimatedSprite2D
@onready var sprite = $Sprite2D
@export var damage := 30
@export var direction := Vector2.UP  # Move para cima
@export var speed := 800
var can_move := false

func _process(delta):
	#print("print")
	if can_move:
		position += direction * speed * delta
	
	
func _ready() -> void:
	#print("fffff")
	preAtack.play("PreAtack")
	await preAtack.animation_finished
	preAtack.queue_free()
	can_move = true

func _on_body_entered(body):
	if body.has_method("take_damage"):
		body.take_damage(damage)
	queue_free()
