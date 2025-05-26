extends CharacterBody2D

@export var speed := 320.0
@export var jump_speed := -1000.0
@export var gravity := 2500.0
@export var espada : PackedScene

@onready var sprite = $PlayerSprite
@onready var hud = get_node("/root/Main/HUD")
@onready var health := 100

var is_attacking = false
var is_no_sword = false

func _physics_process(delta):
	move_side(delta)

func move_side(delta):
	velocity.y += gravity * delta
	get_side_input()
	animate_side()
	move_and_slide()

func get_side_input():
	velocity.x = 0
	var vel := Input.get_axis("left", "right")
	var jump := Input.is_action_just_pressed("ui_select")

	if Input.is_action_just_pressed("click") and !is_attacking and !is_no_sword:
		attack()

	if is_on_floor() and jump:
		velocity.y = jump_speed
		get_tree().call_group("HUD", "update_score")

	velocity.x = vel * speed

func attack():
	is_attacking = true
	sprite.play("atack")

	await get_tree().create_timer(0.3).timeout  # tempo até lançar espada

	var e = espada.instantiate()
	var mouse_pos = get_global_mouse_position()

	if mouse_pos.x < global_position.x:
		sprite.flip_h = true
		e.position = global_position + Vector2(-143, -100)
	else:
		sprite.flip_h = false
		e.position = global_position + Vector2(0, -100)

	e.direction = (mouse_pos - e.position).normalized()
	get_parent().add_child(e)

	await get_tree().create_timer(0.3).timeout  # tempo restante da animação "atack"

	is_attacking = false
	is_no_sword = true

	await get_tree().create_timer(0.6).timeout  # tempo sem espada
	is_no_sword = false

func animate_side():
	if is_attacking:
		return  # não troca animação durante ataque

	var anim_prefix = ""
	if is_no_sword:
		anim_prefix = "_no_espada"


	if !is_on_floor():
		sprite.play("jump" + anim_prefix)
		sprite.flip_h = velocity.x < 0
	elif velocity.x == 0:
		sprite.play("idle" + anim_prefix)
	elif velocity.x > 0:
		sprite.play("running" + anim_prefix)
		sprite.flip_h = false
	elif velocity.x < 0:
		sprite.play("running" + anim_prefix)
		sprite.flip_h = true
	else:
		sprite.stop()

func take_damage(amount):
	health -= amount
	print("Vida restante: ", health)
	hud.update_life_bar(health)
	await piscar()
	if health <= 0:
		die()

func piscar() -> void:
	for i in range(3):
		sprite.visible = false
		await get_tree().create_timer(0.1).timeout
		sprite.visible = true
		await get_tree().create_timer(0.1).timeout

func die():
	get_tree().change_scene_to_file("res://game/GameOver.tscn")
