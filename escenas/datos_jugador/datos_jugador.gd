extends Control
@export var label_monedas: Label
@export var barra_vida: ProgressBar
@export var label_vida: Label
@export var player: CharacterBody2D

func _ready() -> void:
	player.monedas_sign.connect(actualizar_monedas)
	player.vida_cambiada.connect(actualizar_vida)
	actualizar_monedas(player.monedas)

func actualizar_monedas(cantidad: int) -> void:
	label_monedas.text = " x " + str(cantidad)

func actualizar_vida(vida_actual: float, vida_maxima: float) -> void:
	barra_vida.max_value = vida_maxima
	barra_vida.value = vida_actual
	label_vida.text = str(roundi(vida_actual)) + " / " + str(roundi(vida_maxima))
