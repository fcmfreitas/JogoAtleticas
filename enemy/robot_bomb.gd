extends CharacterBody2D

@onready var sprite = $AnimatedSprite2D
@export var player_path : NodePath
@export var gravity := 2500.0
var health := 50
var explosion_range := 350
var damage := 50 

const SPEED = 370.0

var player: Node2D
var is_exploding := false

func _ready():
	if player_path:
		player = get_node(player_path)

func _physics_process(delta: float) -> void:
	if not player or is_exploding or global_position.distance_to(player.global_position) > 1000:
		return

	if global_position.distance_to(player.global_position) < 200:
		_explode()
	else:
		var direction = (player.global_position - global_position).normalized()
		velocity.x = direction.x * SPEED
		sprite.play("running")
		
		if direction.x != 0:
			sprite.flip_h = direction.x < 0

		if not is_on_floor():
			velocity.y += gravity * delta
		else:
			velocity.y = 0

		move_and_slide()

func _explode():
	if is_exploding:
		return  

	is_exploding = true
	velocity = Vector2.ZERO
	sprite.play("idle")

	# Anima a progressão de cor piscando até vermelho total
	var tween = get_tree().create_tween()
	tween.set_loops(3)  # piscadas
	tween.tween_property(sprite, "modulate", Color(1, 0.5, 0.5), 0.1)
	tween.tween_property(sprite, "modulate", Color(1, 1, 1), 0.1)
	tween.tween_property(sprite, "modulate", Color(1, 0.3, 0.3), 0.1)
	tween.tween_property(sprite, "modulate", Color(1, 1, 1), 0.1)
	tween.tween_property(sprite, "modulate", Color(1, 0, 0), 0.1)

	await tween.finished

	await get_tree().create_timer(0.2).timeout  # breve pausa antes de explodir

	if player and global_position.distance_to(player.global_position) <= explosion_range:
		if player.has_method("take_damage"):
			player.take_damage(damage)

	print("Explodiu!")
	die()

func take_damage(amount):
	health -= amount
	piscar()
	print("Vida restante: ", health)
	if health <= 0:
		die()

func piscar() -> void:
	sprite.modulate = Color(1, 0, 0)
	var tween = get_tree().create_tween()
	tween.tween_property(sprite, "modulate", Color(1, 1, 1), 0.4)
	await tween.finished

func die():
	queue_free()
