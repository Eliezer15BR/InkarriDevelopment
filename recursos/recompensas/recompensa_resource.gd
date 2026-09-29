extends Resource
class_name RecompensaResource


@export var nombre: String = "Recompensa"


func aplicar(_player: CharacterBody2D) -> void:
	push_warning("Esta recompensa no tiene una función aplicar() definida.")
