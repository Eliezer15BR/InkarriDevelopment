extends Control

@export var label_monedas: Label
@export var barra_vida: ProgressBar

@export var label_build: Label
@export var label_dano: Label
@export var label_defensa: Label
@export var label_velocidad: Label
@export var label_ataque: Label
@export var label_fortuna: Label

@export var player: CharacterBody2D


func _ready() -> void:
	player.monedas_sign.connect(actualizar_monedas)
	player.vida_cambiada.connect(actualizar_vida)

	actualizar_monedas(player.monedas)
	actualizar_vida(player.vida_actual, player.vida_maxima)
	actualizar_estadisticas()


func actualizar_monedas(cantidad: int) -> void:
	label_monedas.text = " x " + str(cantidad)


func actualizar_vida(vida_actual: float, vida_maxima: float) -> void:
	barra_vida.max_value = vida_maxima
	barra_vida.value = vida_actual



func actualizar_estadisticas() -> void:
	if player.build != null:
		label_build.text = "Build: " + player.build.nombre
	else:
		label_build.text = "Build: -"

	label_dano.text = "Daño: " + str(snapped(player.dano, 0.1))
	label_defensa.text = "Defensa: " + str(snapped(player.defensa, 0.1))
	label_velocidad.text = (
		"Movimiento: "
		+ str(snapped(player.velocidad_movimiento, 0.1))
	)
	label_ataque.text = (
		"Ataque: "
		+ str(snapped(player.velocidad_ataque, 0.1))
	)
	label_fortuna.text = (
		"Fortuna: "
		+ str(snapped(player.fortuna, 0.1))
	)
