extends Area2D

func _ready() -> void:
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)


func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		body.registrar_interactuable(self)


func _on_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		body.quitar_interactuable(self)


func interactuar(player: CharacterBody2D) -> void:
	player.agregar_moneda()
	queue_free()
