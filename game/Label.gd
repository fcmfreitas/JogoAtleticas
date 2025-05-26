extends CanvasLayer  # ou Node, dependendo do tipo de HUD

@onready var barra_vida := $TextureRect/TextureProgressBar

func update_life_bar(vida_atual: int) -> void:
	barra_vida.max_value = 100
	barra_vida.value = vida_atual
