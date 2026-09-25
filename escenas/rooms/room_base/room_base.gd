extends Node2D
class_name RoomBase
signal sala_resuelta
var resuelta:bool=false
func resolver_sala()->void:
	if resuelta: return
	resuelta=true
	sala_resuelta.emit()
