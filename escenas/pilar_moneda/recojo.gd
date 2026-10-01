extends Area2D

@export var recompensa: RecompensaResource
@export var visual_contenido: PackedScene
@export var grupo_eleccion:String =""
@export var indicador:Label
@export var sound: AudioStreamPlayer2D
signal recompensa_elegida
signal mostrar_info(recompensa: RecompensaResource)
signal ocultar_info
var consumido: bool = false
var visual_instanciado: Node2D = null

func _ready() -> void:
	if visual_contenido != null:
		visual_instanciado = visual_contenido.instantiate()
		add_child(visual_instanciado)
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)
	if grupo_eleccion!="": add_to_group(grupo_eleccion)

func _on_body_entered(body: Node2D) -> void:
	if consumido: return
	if body.is_in_group("player"): 
		body.registrar_interactuable(self)
		if indicador!=null: indicador.visible=true
		mostrar_info.emit(recompensa)

func _on_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"): 
		body.quitar_interactuable(self)
		if indicador!=null: indicador.visible=false
		ocultar_info.emit()

func interactuar(player: CharacterBody2D) -> void:
	if consumido: return
	if recompensa == null:
		push_error("El pedestal no tiene una recompensa asignada.")
		return
	consumido = true
	print("obvio bro")
	player.quitar_interactuable(self)
	recompensa.aplicar(player)
	sound.play()
	recompensa_elegida.emit()
	if grupo_eleccion!="":
		var pedestales:=get_tree().get_nodes_in_group(grupo_eleccion)
		for pedestal in pedestales:
			if is_instance_valid(pedestal): pedestal.desactivar_pedestal()
	else: desactivar_pedestal()

func desactivar_pedestal() -> void:
	consumido=true
	var pedestal_raiz:=get_parent()
	if pedestal_raiz!=null: pedestal_raiz.queue_free()
	else: queue_free()
