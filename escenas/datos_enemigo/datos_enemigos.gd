extends Control

@export var barras: VBoxContainer

var sala_actual: Node = null


func _ready() -> void:
	get_tree().node_added.connect(_on_nodo_agregado)


func cargar_sala(sala: Node) -> void:
	sala_actual = sala
	limpiar()

	_buscar_enemigos(sala)


func _buscar_enemigos(nodo: Node) -> void:
	for hijo in nodo.get_children():

		if hijo is EnemyBase:
			agregar_enemigo(hijo)

		_buscar_enemigos(hijo)

func agregar_enemigo(enemigo: EnemyBase) -> void:
	var fila := HBoxContainer.new()
	fila.custom_minimum_size = Vector2(230, 35)

	# -------------------------
	# ICONO DEL ENEMIGO
	# -------------------------
	var icono := TextureRect.new()

	icono.custom_minimum_size = Vector2(35, 35)
	icono.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	icono.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED

	var sprite := buscar_sprite(enemigo)

	if sprite != null and sprite.sprite_frames != null:
		icono.texture = sprite.sprite_frames.get_frame_texture(
			sprite.animation,
			0
		)

	fila.add_child(icono)

	# -------------------------
	# BARRA DE VIDA
	# -------------------------
	var barra := ProgressBar.new()

	barra.custom_minimum_size = Vector2(150, 25)

	barra.min_value = 0
	barra.max_value = enemigo.vida_maxima
	barra.value = enemigo.vida_actual

	barra.show_percentage = false

	# Color de fondo
	var fondo := StyleBoxFlat.new()
	fondo.bg_color = Color(0.15, 0.05, 0.05, 0.9)

	barra.add_theme_stylebox_override(
		"background",
		fondo
	)

	# Color rojo distinto para cada enemigo
	var relleno := StyleBoxFlat.new()

	var indice := barras.get_child_count()

	var tonos_rojos: Array[Color] = [
		Color(0.693, 0.004, 0.986, 1.0),
		Color(0.025, 0.386, 0.774, 1.0),
		Color(0.0, 0.647, 0.578, 1.0),
		Color(0.423, 0.514, 0.887, 1.0),
		Color(0.761, 0.8, 0.055, 1.0)
	]

	relleno.bg_color = tonos_rojos[
		indice % tonos_rojos.size()
	]

	barra.add_theme_stylebox_override(
		"fill",
		relleno
	)

	fila.add_child(barra)

	# Añadimos toda la fila al HUD
	barras.add_child(fila)

	# Actualizar vida
	enemigo.vida_cambiada.connect(
		_on_vida_enemigo_cambiada.bind(barra)
	)

	# Eliminar fila cuando muera
	enemigo.murio.connect(
		_on_enemigo_murio.bind(fila)
	)


func _on_vida_enemigo_cambiada(
	vida_actual: float,
	vida_maxima: float,
	barra: ProgressBar
) -> void:

	if not is_instance_valid(barra):
		return

	barra.max_value = vida_maxima
	barra.value = vida_actual


func _on_enemigo_murio(
	_enemigo: EnemyBase,
	fila: HBoxContainer
) -> void:
	if is_instance_valid(fila): fila.queue_free()


func _on_nodo_agregado(nodo: Node) -> void:
	if sala_actual == null:
		return

	if nodo is EnemyBase and sala_actual.is_ancestor_of(nodo):
		agregar_enemigo(nodo)


func limpiar() -> void:
	for hijo in barras.get_children():
		hijo.queue_free()

func buscar_sprite(nodo: Node) -> AnimatedSprite2D:
	if nodo is AnimatedSprite2D:
		return nodo

	for hijo in nodo.get_children():
		var resultado := buscar_sprite(hijo)

		if resultado != null:
			return resultado

	return null
