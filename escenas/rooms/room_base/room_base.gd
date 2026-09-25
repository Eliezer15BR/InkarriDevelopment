extends Node2D
class_name RoomBase
signal sala_resuelta
signal portal_elegido

@export var portales:Node2D
var resuelta:bool=false
func _ready()->void:
	for portal in portales.get_children():
		portal.set_activo(false)
		portal.transporte.connect(_on_portal_usado)

func resolver_sala()->void:
	if resuelta: return
	resuelta=true
	sala_resuelta.emit()
	for portal in portales.get_children(): portal.set_activo(true)
 
func _on_portal_usado(_nivel:int)->void:
	portal_elegido.emit()
