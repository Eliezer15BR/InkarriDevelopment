extends RecompensaResource
class_name RecompensaMoneda
@export var cantidad: int = 1
func aplicar(player: CharacterBody2D) -> void:
	for i in range(cantidad):
		player.agregar_moneda()
