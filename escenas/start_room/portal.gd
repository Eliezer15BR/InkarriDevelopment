extends Area2D

signal transporte(nivel:int)
@export var nivel_destino: int = 2
var jugador_cerca := false

func _ready() -> void:
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)

func _process(delta: float) -> void:
	if jugador_cerca and Input.is_action_just_pressed("interactuar"):
		transporte.emit(nivel_destino)

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		jugador_cerca = true

func _on_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		jugador_cerca = false
