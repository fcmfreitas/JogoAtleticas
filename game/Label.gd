extends Label

@onready var barra_vida := $TextureProgressBar

func update_life_bar(vida_atual: int) -> void:
	barra_vida.max_value = 100
	barra_vida.value = vida_atual
