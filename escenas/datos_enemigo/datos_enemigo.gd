extends Control

@export var barra_vida: ProgressBar
@export var label_vida: Label
@export var label_nombre: Label

var enemigo_actual: EnemyBase = null


func mostrar_enemigo(enemigo: EnemyBase) -> void:
	if enemigo_actual != null:
		if enemigo_actual.vida_cambiada.is_connected(actualizar_vida):
			enemigo_actual.vida_cambiada.disconnect(actualizar_vida)

	enemigo_actual = enemigo

	if enemigo_actual == null:
		visible = false
		return

	visible = true

	if enemigo_actual.estadisticas != null:
		label_nombre.text = enemigo_actual.estadisticas.nombre
	else:
		label_nombre.text = "Enemigo"

	enemigo_actual.vida_cambiada.connect(actualizar_vida)

	actualizar_vida(
		enemigo_actual.vida_actual,
		enemigo_actual.vida_maxima
	)


func actualizar_vida(
	vida_actual: float,
	vida_maxima: float
) -> void:

	barra_vida.max_value = vida_maxima
	barra_vida.value = vida_actual

	label_vida.text = (
		str(roundi(vida_actual))
		+ " / "
		+ str(roundi(vida_maxima))
	)

	if vida_actual <= 0:
		visible = false
		enemigo_actual = null
