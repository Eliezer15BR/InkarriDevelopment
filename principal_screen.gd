extends Node2D

@export var room_container: Node2D
@export var player: CharacterBody2D
@export var start_room: PackedScene
@export var boss_room: PackedScene
@export var combat_room: PackedScene
@export var skeleton_room: PackedScene
@export var plant_room: PackedScene
@export var item_room: PackedScene
@export var hud_enemigos: Control
@export var hud_info_interaccion: Control
@export var pantalla_fin_juego: Control

var _nodo_nivel: Node = null
var _numero_sala: int = 1


func _ready() -> void:
	randomize()
	if not player.murio.is_connected(_on_player_murio):
		player.murio.connect(_on_player_murio)
	pantalla_fin_juego.visible=false
	if pantalla_fin_juego.has_signal("reiniciar_partida"):
		pantalla_fin_juego.reiniciar_partida.connect(_on_reiniciar_partida)
	cargar_sala(start_room)

func _on_reiniciar_partida():
	get_tree().paused=false
	pantalla_fin_juego.visible=false
	iniciar_run()

func cargar_sala(escena: PackedScene) -> void:
	if escena == null:
		push_error("Se intentó cargar una sala vacía.")
		return
	limpiar_proyectiles()
	if _nodo_nivel != null: _nodo_nivel.queue_free()
	_nodo_nivel = escena.instantiate()
	room_container.add_child(_nodo_nivel)
	conectar_interactuables_info(_nodo_nivel)
	if hud_enemigos!=null: hud_enemigos.cargar_sala(_nodo_nivel)
	var spawn: Marker2D = _nodo_nivel.get_node_or_null("PlayerSpawn")
	if spawn != null:
		player.global_position = spawn.global_position
	if _nodo_nivel.has_signal("portal_elegido"):
		_nodo_nivel.portal_elegido.connect(_avanzar_sala)
	var portal = _nodo_nivel.get_node_or_null("Portal")
	if portal != null:
		portal.transporte.connect(_on_portal_inicio)

func _avanzar_sala() -> void:
	_numero_sala += 1
	if _numero_sala >= 7:
		cargar_sala(boss_room)
		return
	cargar_sala(elegir_sala_aleatoria())

func elegir_sala_aleatoria() -> PackedScene:
	var tirada := randf_range(0.0, 40.0)
	if tirada < 30.0: return elegir_combate_aleatorio()
	return item_room

func elegir_combate_aleatorio() -> PackedScene:
	var combates: Array[PackedScene] = [
		combat_room,
		skeleton_room,
		plant_room
	]
	return combates.pick_random()


func _on_portal_inicio(_nivel: int) -> void:
	_numero_sala = 2
	cargar_sala(elegir_sala_aleatoria())

func _on_player_murio() -> void: 
	pantalla_fin_juego.visible=true
	get_tree().paused=true

func limpiar_proyectiles() -> void:
	for proyectil in get_tree().get_nodes_in_group("proyectiles"):
		if is_instance_valid(proyectil): proyectil.queue_free()

func iniciar_run() -> void:
	_numero_sala = 1
	player.monedas = 0
	player.monedas_sign.emit(player.monedas)
	player.objeto_interactuable = null
	player.invulnerable = false
	player.cooldown_disparo = 0.0
	player.aplicar_build(player.build)
	cargar_sala(start_room)

func conectar_interactuables_info(nodo: Node) -> void:
	for hijo in nodo.get_children():
		if hijo.has_signal("mostrar_info"): hijo.mostrar_info.connect(_on_mostrar_info)
		if hijo.has_signal("ocultar_info"): hijo.ocultar_info.connect(_on_ocultar_info)
		conectar_interactuables_info(hijo)

func _on_mostrar_info(recompensa: RecompensaResource) -> void:
	if hud_info_interaccion != null:
		hud_info_interaccion.mostrar_recompensa(recompensa)


func _on_ocultar_info() -> void:
	if hud_info_interaccion != null:
		hud_info_interaccion.ocultar()
