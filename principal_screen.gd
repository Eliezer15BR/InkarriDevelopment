extends Node2D
@export var niveles: Array[PackedScene]
var _nivel_actual: int=1
var _nodo_nivel:Node=null

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	crear_nivel(_nivel_actual)

func crear_nivel(nivel: int):
	if _nodo_nivel!=null:
		remove_child(_nodo_nivel)
	_nodo_nivel=niveles[nivel-1].instantiate()
	_nivel_actual=nivel
	add_child(_nodo_nivel)
	if _nodo_nivel.has_node("Portal"):
		var portal=_nodo_nivel.get_node("Portal")
		portal.transporte.connect(_transportar)

func _transportar(nivel: int):
	crear_nivel(nivel)
	
