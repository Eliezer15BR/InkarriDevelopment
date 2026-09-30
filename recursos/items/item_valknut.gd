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
		_modificar_estadistica(player, estadisticas_positivas[i], 3.0)

	# Elegimos una estadística distinta para el -2
	var estadisticas_negativas := estadisticas_positivas.duplicate()

	for i in range(3):
		estadisticas_negativas.erase(estadisticas_positivas[i])

	if estadisticas_negativas.size() > 0:
		estadisticas_negativas.shuffle()
		_modificar_estadistica(player, estadisticas_negativas[0], -2.0)

	_actualizar_player(player)


func _modificar_estadistica(
	player: CharacterBody2D,
	estadistica: String,
	cantidad: float
) -> void:

	match estadistica:
		"vida_maxima":
			player.vida_maxima += cantidad

		"dano":
			player.dano += cantidad

		"velocidad_movimiento":
			player.velocidad_movimiento += cantidad

		"velocidad_ataque":
			player.velocidad_ataque += cantidad

		"defensa":
			player.defensa += cantidad

		"fortuna":
			player.fortuna += cantidad


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
