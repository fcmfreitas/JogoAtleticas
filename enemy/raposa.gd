extends CharacterBody2D

@export var player: CharacterBody2D
@export var binarios: PackedScene
@onready var raposa = $AnimatedSprite2D
var health := 1000
var dist_player
enum StateMachine { waitingPlayer, idle, ataque, die }
var state = StateMachine.waitingPlayer

func _ready() -> void:
	pass

func _enter_state(new_state: StateMachine) -> void:
	if state != new_state:
		state = new_state

func spawn_codigos():
	for i in range(5):
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
			if abs(global_position.x - player.global_position.x) < 550:
				_enter_state(StateMachine.ataque)
			
		StateMachine.ataque:
			atack1()
			
		StateMachine.idle:
			_idle_wait()

# Aguarda 3 segundos e troca para ataque novamente
func _idle_wait() -> void:
	set_process(false)  # Evita múltiplas chamadas durante o "await"
	await get_tree().create_timer(3.0).timeout
	_enter_state(StateMachine.ataque)
	set_process(true)

func atack1() -> void:
	set_process(false)
	print("Iniciando ataque!")
	raposa.play("Atack1")
	spawn_codigos()
	await raposa.animation_finished
	raposa.play("default")
	_enter_state(StateMachine.idle)
	set_process(true)

func take_damage(amount):
	health -= amount
	print("Vida restante: ", health)
	if health <= 0:
		die()
		
func die():
	queue_free()
