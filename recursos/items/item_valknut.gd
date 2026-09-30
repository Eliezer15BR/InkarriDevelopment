extends ItemResource
class_name ItemValknut


func aplicar(player: CharacterBody2D) -> void:
	var estadisticas_positivas: Array[String] = [
		"vida_maxima",
		"dano",
		"velocidad_movimiento",
		"velocidad_ataque",
		"defensa",
		"fortuna"
	]

	estadisticas_positivas.shuffle()

	# +3 a tres estadísticas distintas
	for i in range(3):
		_modificar_estadistica(player, estadisticas_positivas[i], true)

	# Elegimos una estadística distinta para el -2
	var estadisticas_negativas := estadisticas_positivas.duplicate()

	for i in range(3):
		estadisticas_negativas.erase(estadisticas_positivas[i])

	if estadisticas_negativas.size() > 0:
		estadisticas_negativas.shuffle()
		_modificar_estadistica(player, estadisticas_negativas[0], false)

	_actualizar_player(player)


func _modificar_estadistica(
	player: CharacterBody2D,
	estadistica: String,
	positivo: bool
) -> void:

	match estadistica:
		"vida_maxima":
			player.vida_maxima += 15.0 if positivo else -10.0

		"dano":
			player.dano += 3.0 if positivo else -2.0

		"velocidad_movimiento":
			player.velocidad_movimiento += 0.3 if positivo else -0.2

		"velocidad_ataque":
			player.velocidad_ataque += 0.3 if positivo else -0.2

		"defensa":
			player.defensa += 3.0 if positivo else -2.0

		"fortuna":
			player.fortuna += 5.0 if positivo else -5.0


func _actualizar_player(player: CharacterBody2D) -> void:
	player._velocidad = (
		player.velocidad_movimiento
		* player.PIXELS_PER_MOVEMENT
	)
	if player.velocidad_ataque > 0:
		player.tiempo_entre_disparos = 1.0 / player.velocidad_ataque
	player.vida_actual = min(
		player.vida_actual,
		player.vida_maxima
	)
	player.vida_cambiada.emit(
		player.vida_actual,
		player.vida_maxima
	)
	player.estadisticas_cambiadas.emit()
