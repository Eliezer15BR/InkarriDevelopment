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
	var barra := ProgressBar.new()

	barra.custom_minimum_size = Vector2(190, 20)
	barra.min_value = 0
	barra.max_value = enemigo.vida_maxima
	barra.value = enemigo.vida_actual

	barras.add_child(barra)

	enemigo.vida_cambiada.connect(
		_on_vida_enemigo_cambiada.bind(barra)
	)

	enemigo.murio.connect(
		_on_enemigo_murio.bind(barra)
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
	barra: ProgressBar
) -> void:

	if is_instance_valid(barra):
		barra.queue_free()


func _on_nodo_agregado(nodo: Node) -> void:
	if sala_actual == null:
		return

	if nodo is EnemyBase and sala_actual.is_ancestor_of(nodo):
		agregar_enemigo(nodo)


func limpiar() -> void:
	for hijo in barras.get_children():
		hijo.queue_free()
