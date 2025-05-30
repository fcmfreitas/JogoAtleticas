extends CharacterBody2D

@export var player: CharacterBody2D
@export var binarios: PackedScene
@onready var raposa = $AnimatedSprite2D
@onready var anim_player = $AnimationPlayer

var health := 1000
var max_health := 1000
var fase := 1  # Começa na Fase 1
var dist_player
enum StateMachine { waitingPlayer, idle, ataque, ataque2, die }
var state = StateMachine.waitingPlayer

func _ready() -> void:
	$ParedeFinal2/CollisionShape2D.disabled = true
	raposa.play("default")
	pass

func _enter_state(new_state: StateMachine) -> void:
	if state != new_state:
		state = new_state

func spawn_codigos():
	var qtd_spawn = 4
	if fase == 2:
		qtd_spawn = 5  # Aumenta a quantidade na Fase 2
	elif fase == 3:
		qtd_spawn = 6  # Aumenta ainda mais na Fase 3
	
	for i in range(qtd_spawn):
		var instancia = binarios.instantiate()
		var pos_x = randf_range(player.position.x - 400, player.position.x + 400)
		var pos_y = 650
		instancia.position = Vector2(pos_x, pos_y)
		get_parent().add_child(instancia)

func _process(delta: float) -> void:
	if state == StateMachine.die:
		return
	
	match state:
		StateMachine.waitingPlayer:
			if abs(global_position.x - player.global_position.x) < 1170:
				$ParedeFinal2/CollisionShape2D.disabled = false
				_enter_state(StateMachine.ataque2)
		
		StateMachine.ataque2:
			atack2()
		
		StateMachine.ataque:
			atack1()
			
		StateMachine.idle:
			_idle_wait()

func _idle_wait() -> void:
	set_process(false)  
	
	# Tempo de espera diminui em fases mais avançadas
	var wait_time = 3.0
	if fase == 2:
		wait_time = 2.0
	elif fase == 3:
		wait_time = 1.0
	
	await get_tree().create_timer(wait_time).timeout
	
	var ataques = [StateMachine.ataque, StateMachine.ataque2]
	randomize()
	var proximo_ataque = ataques[randi() % ataques.size()]
	_enter_state(proximo_ataque)
	set_process(true)

func atack1() -> void:
	set_process(false)
	print("Iniciando ataque Fase ", fase)
	
	raposa.play("Atack1")
	spawn_codigos()
	
	# Aumenta a velocidade da animação nas fases avançadas
	raposa.speed_scale = 1.0 + 0.5 * (fase - 1)
	
	await raposa.animation_finished
	raposa.speed_scale = 1.0  # Reset após o ataque
	
	raposa.play("default")
	_enter_state(StateMachine.idle)
	set_process(true)

func atack2() -> void:
	set_process(false)
	print("Soco Fase ", fase)
	
	raposa.play("Atack2")
	anim_player.stop()
	anim_player.play("soco")
	
	await raposa.animation_finished
	await anim_player.animation_finished
	anim_player.seek(0.0, true)
	raposa.play("default")
	_enter_state(StateMachine.idle)
	set_process(true)
	
func update_fase():
		var vida_ratio = float(health) / float(max_health)
		if vida_ratio <= 0.5:
			if fase != 3:
				fase = 3
				print("Entrou na Fase 3!")
		elif vida_ratio <= 0.88:
			if fase != 2:
				fase = 2
				print("Entrou na Fase 2!")
		else:
			if fase != 1:
				fase = 1
				print("Voltou para Fase 1 (vida recuperada)")


func take_damage(amount):
	health -= amount
	piscar()
	print("Vida restante: ", health)
	update_fase()
	if health <= 0:
		die()

func piscar() -> void:
	raposa.modulate = Color(1, 0, 0)  # começa vermelho
	var tween = get_tree().create_tween()
	tween.tween_property(raposa, "modulate", Color(1, 1, 1), 0.4) 
	await tween.finished

func die():
	queue_free()
