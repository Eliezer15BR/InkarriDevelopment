extends Node2D

@export var room_container: Node2D
@export var player: CharacterBody2D

# Salas fijas
@export var start_room: PackedScene
@export var boss_room: PackedScene

@export var combat_room: PackedScene
@export var skeleton_room: PackedScene
@export var plant_room: PackedScene
@export var item_room: PackedScene

var _nodo_nivel: Node = null
var _numero_sala: int = 1


func _ready() -> void:
	randomize()
	cargar_sala(start_room)


func cargar_sala(escena: PackedScene) -> void:
	if escena == null:
		push_error("Se intentó cargar una sala vacía.")
		return
	if _nodo_nivel != null: _nodo_nivel.queue_free()
	_nodo_nivel = escena.instantiate()
	room_container.add_child(_nodo_nivel)
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
