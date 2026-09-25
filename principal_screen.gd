extends Node2D
@export var niveles: Array[PackedScene]
@export var room_container: Node2D;
@export var player: CharacterBody2D;
var _nivel_actual: int=1
var _nodo_nivel:Node=null

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	crear_nivel(_nivel_actual)

func crear_nivel(nivel: int):
	if _nodo_nivel!=null:
		_nodo_nivel.queue_free()
	_nodo_nivel=niveles[nivel-1].instantiate()
	_nivel_actual=nivel
	room_container.add_child(_nodo_nivel)
	var spawn:Marker2D=_nodo_nivel.get_node_or_null("PlayerSpawn")
	if spawn!=null: player.global_position=spawn.global_position
	if _nodo_nivel.has_signal("portal_elegido"):
			_nodo_nivel.connect("portal_elegido",_avanzar_sala)
	var portal=_nodo_nivel.get_node_or_null("Portal")
	if portal!=null: portal.transporte.connect(_transportar)

func _avanzar_sala()->void:
	var siguiente_nivel:=_nivel_actual+1
	if siguiente_nivel>niveles.size():
		print("Final")
		return
	crear_nivel(siguiente_nivel)

func _transportar(nivel: int):
	crear_nivel(nivel)
	
