extends Camera2D

func _ready() -> void:
	# Cria um ColorRect que cobre a tela
	var filter = ColorRect.new()
	filter.color = Color(0.1, 0.1, 0.1, 0.2)  # tom escuro com transparência
	
	# Faz o ColorRect ocupar toda a viewport
	filter.size_flags_horizontal = Control.SIZE_FLAGS_EXPAND_FILL
	filter.size_flags_vertical = Control.SIZE_FLAGS_EXPAND_FILL
	
	# Para ele sempre cobrir a tela, é melhor que esteja num CanvasLayer
	var canvas_layer = CanvasLayer.new()
	canvas_layer.layer = 100  # garantir que fique por cima
	canvas_layer.add_child(filter)
	
	# Adiciona o CanvasLayer à árvore da cena
	get_tree().current_scene.add_child(canvas_layer)
