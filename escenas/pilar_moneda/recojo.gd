extends Area2D

var jugador_cerca: CharacterBody2D = null

func _ready() -> void:
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)


func _process(delta: float) -> void:
	if jugador_cerca != null and Input.is_action_just_pressed("interactuar"):
		recoger()


func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		jugador_cerca = body


func _on_body_exited(body: Node2D) -> void:
	if body == jugador_cerca:
		jugador_cerca = null


func recoger() -> void:
	jugador_cerca.agregar_moneda()
	queue_free()
