extends RecompensaResource
class_name RecompensaBuild
@export var build: BuildResource

func aplicar(player: CharacterBody2D) -> void:
	player.aplicar_build(build)
