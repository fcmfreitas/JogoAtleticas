extends CharacterBody2D

@export var gravity := 2500.0
@export var max_health := 100
@onready var sprite = $RobotSprite
@onready var projetil = $Projetil
@export var player_path : NodePath
var health := max_health
var player : Node2D

func _ready():
	if player_path:
		player = get_node(player_path)

func _physics_process(delta):

	if !is_on_floor():
		velocity.y += gravity * delta
	else:
		velocity.y = 0

	# Flip sprite baseado na posição do jogador
	if player:
		if player.global_position.x < global_position.x + 40:
			sprite.flip_h = true
		else:
			sprite.flip_h = false

	move_and_slide()

func take_damage(amount):
	health -= amount
	print("Vida restante: ", health)
	if health <= 0:
		die()

func die():
	queue_free()
