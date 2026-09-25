extends Area2D

signal transporte(nivel:int)
@export var nivel_destino: int = 2

func _ready() -> void:
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		body.registrar_interactuable(self)

func _on_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		body.quitar_interactuable(self)
		
func interactuar(_player: CharacterBody2D)->void:
	transporte.emit(nivel_destino)

func set_activo(valor:bool)->void:
	visible=valor
	monitoring=valor
