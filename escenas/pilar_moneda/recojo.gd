extends Area2D

@export var recompensa: RecompensaResource
@export var visual_contenido: PackedScene

var consumido: bool = false
var visual_instanciado: Node2D = null

func _ready() -> void:
	if visual_contenido != null:
		visual_instanciado = visual_contenido.instantiate()
		add_child(visual_instanciado)
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)

func _on_body_entered(body: Node2D) -> void:
	if consumido: return
	if body.is_in_group("player"): body.registrar_interactuable(self)


func _on_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"): body.quitar_interactuable(self)

func interactuar(player: CharacterBody2D) -> void:
	if consumido: return
	if recompensa == null:
		push_error("El pedestal no tiene una recompensa asignada.")
		return
	consumido = true
	player.quitar_interactuable(self)
	recompensa.aplicar(player)
	queue_free()
