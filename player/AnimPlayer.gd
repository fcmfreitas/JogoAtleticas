extends CharacterBody2D

@export var speed := 320.0
@export var jump_speed := -1000.0
@export var gravity := 2500.0
@export var espada : PackedScene
@onready var sprite = $PlayerSprite
@onready var health := 100
#@export var bullet : PackedScene
var is_attacking = false

func animate_side():
	atack_finished()
	if is_attacking:
		return
	elif Input.is_action_just_pressed("click"):
		sprite.play("atack")
		is_attacking = true
	elif Input.is_action_just_pressed("click") && !is_on_floor():
		sprite.play("atack")
		is_attacking = true
	elif !is_on_floor():
		sprite.play("jump")
		if velocity.x < 0:
			sprite.flip_h = true
		elif velocity.x > 0:
			sprite.flip_h = false
	elif velocity.x == 0:
		sprite.play("idle")
	elif velocity.x > 0:
		sprite.play("running")
		sprite.flip_h = false
	elif velocity.x < 0:
		sprite.play("running")
		sprite.flip_h = true
	else:
		sprite.stop()
		
func atack_finished():
	if sprite.animation == "atack" and !sprite.is_playing():
		is_attacking = false

func get_side_input():
	velocity.x = 0
	var vel := Input.get_axis("left", "right")
	var jump := Input.is_action_just_pressed('ui_select')
	
	if Input.is_action_just_pressed("click"):
		var e = espada.instantiate()  # CORRETO
		var mouse_pos = get_global_mouse_position()
		
		
		if mouse_pos.x < global_position.x:
			sprite.flip_h = true
			e.position = global_position + Vector2(-143, -100)
		else:
			sprite.flip_h = false
			e.position = global_position + Vector2(0, -100)
		
		var direction = (mouse_pos - e.position).normalized()
		e.direction = direction
		
		get_parent().add_child(e)
	
	if is_on_floor() and jump:
		velocity.y = jump_speed
		get_tree().call_group("HUD", "update_score")
	velocity.x = vel * speed
	

func move_side(delta):
	velocity.y += gravity * delta
	get_side_input()
	animate_side()
	move_and_slide()

func print_position():
	print(position)

func get_8way_input():
	var input_direction = Input.get_vector("left", "right", "up", "down")
	velocity = input_direction * speed
	
func animate():
	if velocity.x > 0:
		sprite.play("right")
	elif velocity.x < 0:
		sprite.play("left")
	elif velocity.y > 0:
		sprite.play("jump")
	elif velocity.y < 0:
		sprite.play("jump")
	else:
		sprite.stop()

func take_damage(amount):
	health -= amount
	print("Vida restante: ", health)
	if health <= 0:
		die()

func move_8way(delta): 
	get_8way_input()
	animate()
	var collision_info = move_and_collide(velocity * delta)
	if collision_info:
		velocity = velocity.bounce(collision_info.get_normal())
		move_and_collide(velocity * delta * 10)
	#move_and_slide()

func _physics_process(delta):
	# move_8way(delta)
	move_side(delta)

func die():
	get_tree().change_scene_to_file("res://game/GameOver.tscn")
