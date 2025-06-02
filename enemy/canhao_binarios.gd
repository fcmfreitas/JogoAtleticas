extends Marker2D

@export var binarios: PackedScene

func _ready() -> void:
	spawn_binarios()

func spawn_binarios() -> void:
	# Cria um loop assíncrono infinito (ou você pode colocar uma condição)
	spawn_loop()

func spawn_loop() -> void:

	var novo_binario = binarios.instantiate()
	get_parent().add_child(novo_binario)
	novo_binario.position = global_position 
	await get_tree().create_timer(2).timeout
	spawn_loop()  # chama novamente (recursivo)
