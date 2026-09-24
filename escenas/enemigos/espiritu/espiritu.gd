extends EnemyBase
@export var proyectil: PackedScene
@export var mago_scene: PackedScene
@export var boca: Marker2D
@export var area_dano: Area2D
@export var puntos_teletransporte: Node2D
@export var intervalo_ciclo: float = 1.0
@export var retraso_segundo_mago: float = 0.3
@export var max_magos_invocados: int = 6
@export var distancia_invocacion: float = 50.0
@export var animacion_proyectil: StringName = &"default"
@export var animacion_explosion: StringName = &"explotar"


var player: CharacterBody2D = null
var tiempo_ciclo: float = 0.0
var ciclo_activo: bool = false
var puntos: Array[Marker2D] = []
var indice_punto_actual: int = -1
var magos_invocados: Array[EnemyBase] = []
var indice_invocacion: int = 0

func _physics_process(delta: float) -> void:
	procesar_dano()
	if player == null or not is_instance_valid(player):
		return
	tiempo_ciclo -= delta
	if tiempo_ciclo <= 0.0 and not ciclo_activo:
		tiempo_ciclo = intervalo_ciclo
		ejecutar_ciclo()

func ejecutar_ciclo() -> void:
	ciclo_activo = true
	teletransportar()
	disparar()
	await invocar_magos()
	ciclo_activo = false

func teletransportar() -> void:
	if puntos.is_empty(): return
	var nuevo_indice: int = randi_range(0, puntos.size() - 1)
	if puntos.size() > 1:
		while nuevo_indice == indice_punto_actual:
			nuevo_indice = randi_range(0, puntos.size() - 1)
	indice_punto_actual = nuevo_indice
	global_position = puntos[nuevo_indice].global_position
	
func _ready() -> void:
	super._ready()
	player = get_tree().get_first_node_in_group("player")
	cargar_puntos_teletransporte()
	tiempo_ciclo = intervalo_ciclo

func procesar_dano()->void:
	for body in area_dano.get_overlapping_bodies():
		if body.is_in_group("player"): body.recibir_dano(dano)

func disparar() -> void:
	if proyectil == null: return
	var nueva_piedra = proyectil.instantiate()
	get_parent().add_child(nueva_piedra)
	nueva_piedra.global_position = boca.global_position
	var direccion: Vector2 = boca.global_position.direction_to(
		player.global_position
	)
	nueva_piedra.lanzar(
		direccion,
		dano,
		animacion_proyectil,
		animacion_explosion
	)
	
func cargar_puntos_teletransporte() -> void:
	if puntos_teletransporte == null:
		push_error("Espiritu no tiene puntos de teletransporte")
		return
	for hijo in puntos_teletransporte.get_children():
		if hijo is Marker2D:
			puntos.append(hijo)
	if puntos.is_empty():
		push_error("No hay Marker2D de teletransporte")

func invocar_magos() -> void:
	limpiar_magos_invalidos()
	var cantidad: int = 1
	if vida_actual < vida_maxima * 0.5:
		cantidad = 2

	for i in range(cantidad):
		limpiar_magos_invalidos()
		if magos_invocados.size() >= max_magos_invocados:return
		invocar_un_mago()
		if i < cantidad - 1:
			await get_tree().create_timer(
				retraso_segundo_mago
			).timeout

func invocar_un_mago() -> void:
	if mago_scene == null: return
	var nuevo_mago = mago_scene.instantiate() as EnemyBase
	if nuevo_mago == null: return
	get_parent().add_child(nuevo_mago)
	var direcciones: Array[Vector2] = [
		Vector2.RIGHT,
		Vector2.LEFT,
		Vector2.UP,
		Vector2.DOWN
	]
	var direccion: Vector2 = direcciones[
		indice_invocacion % direcciones.size()
	]
	indice_invocacion += 1
	var posicion_deseada: Vector2 = (
		global_position
		+ direccion * distancia_invocacion
	)
	var mapa: RID = get_world_2d().navigation_map
	var posicion_valida: Vector2 = NavigationServer2D.map_get_closest_point(
		mapa,
		posicion_deseada
	)
	nuevo_mago.global_position = posicion_valida
	magos_invocados.append(nuevo_mago)
	nuevo_mago.murio.connect(_on_mago_murio)

func _on_mago_murio(mago: EnemyBase) -> void:
	magos_invocados.erase(mago)
	
func limpiar_magos_invalidos() -> void:
	for i in range(magos_invocados.size() - 1, -1, -1):
		if not is_instance_valid(magos_invocados[i]):
			magos_invocados.remove_at(i)
