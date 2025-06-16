extends CharacterBody2D

@export var gravity := 2500.0
@onready var sprite = $RobotSprite
@onready var marker = $Marker2D
@onready var marker2 = $Marker2D2
@export var player_path : NodePath
@export var projetil : PackedScene
var health := 75
var player : Node2D

var shoot_timer : Timer

func _ready():
	if player_path:
		player = get_node(player_path)

	# Cria e configura o Timer
	shoot_timer = Timer.new()
	shoot_timer.wait_time = 2.0
	shoot_timer.one_shot = false
	shoot_timer.autostart = true
	add_child(shoot_timer)
	shoot_timer.connect("timeout", Callable(self, "shoot"))

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

func shoot():
	if projetil:
		var p = projetil.instantiate()
		
		var dist = abs(player.global_position.x - global_position.x)
		if dist > 800:
			return
		
		if player.global_position.x < global_position.x + 40:
			p.position = marker2.global_position
			p.direction = Vector2.LEFT
		else:
			p.position = marker.global_position
			p.direction = Vector2.RIGHT
		
		get_parent().add_child(p)

func take_damage(amount):
	var dist = abs(player.global_position.x - global_position.x)
	if dist > 800:
		return
	
	health -= amount
	piscar()
	print("Vida restante: ", health)
	if health <= 0:
		die()

func piscar() -> void:
	sprite.modulate = Color(1, 0, 0)  # começa vermelho
	var tween = get_tree().create_tween()
	tween.tween_property(sprite, "modulate", Color(1, 1, 1), 0.4) 
	await tween.finished

func die():
	queue_free()
