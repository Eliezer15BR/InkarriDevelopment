extends RecompensaResource
class_name ItemResource

@export var nombre_item: String
@export var tier: int = 1
@export_multiline var descripcion: String

@export var multiplicador_defensa: float = 1.0
@export var fortuna_extra: float = 0.0


func aplicar(player: CharacterBody2D) -> void:
	player.defensa = max(player.defensa * 1.5, player.defensa + 3.0)
	player.fortuna += fortuna_extra
	player.estadisticas_cambiadas.emit()
