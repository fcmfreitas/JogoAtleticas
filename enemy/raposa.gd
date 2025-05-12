extends CharacterBody2D

@export var player: CharacterBody2D
@export var binarios: PackedScene
var health := 1000
var dist_player
enum StateMachine { idle, ataque, die }
var state = StateMachine.idle
var ataque_ativado := false  # garante que o ataque ocorra apenas uma vez

func _ready() -> void:
	pass

func _enter_state(new_state: StateMachine) -> void:
	if state != new_state:
		state = new_state

func spawn_codigos():
	for i in range(5):
		var instancia = binarios.instantiate()
		
		var pos_x = randf_range(2500, 5000)
		var pos_y = 450
		instancia.position = Vector2(pos_x, pos_y)
		

		get_parent().add_child(instancia)


func _process(delta: float) -> void:
	if state == StateMachine.die:
		return

	if global_position.distance_to(player.global_position) < 1000 and not ataque_ativado:
		if player.global_position.x >= 2700:
			_enter_state(StateMachine.ataque)

	match state:
		StateMachine.ataque:
			print("Iniciando ataque!")
			spawn_codigos()
			ataque_ativado = true  # impede futuras ativações
			_enter_state(StateMachine.idle)

		StateMachine.idle:
			_idle_wait()

# Aguarda 3 segundos e troca para ataque novamente
func _idle_wait() -> void:
	set_process(false)  # Evita múltiplas chamadas durante o "await"
	await get_tree().create_timer(3.0).timeout
	ataque_ativado = false  # permite novo ataque
	_enter_state(StateMachine.ataque)
	set_process(true)
