extends EnemyBase

enum Estado {
	HUIR,
	ESPERAR,
	DISPARAR
}
@export var navigation_agent: NavigationAgent2D
@export var proyectil: PackedScene
@export var boca: Marker2D
@export var boca2: Marker2D
@export var area_dano: Area2D
@export var sprite:AnimatedSprite2D
@export var distancia_objetivo: float = 180.0
@export var multiplicador_huida: float = 1.5
@export var tiempo_espera: float = 1.1
var boca_actual:Marker2D=boca
var player: CharacterBody2D = null
var estado: Estado = Estado.HUIR
var tiempo_estado: float = 0.0


func _ready() -> void:
	super._ready()
	player = get_tree().get_first_node_in_group("player")
	await get_tree().physics_frame

func _physics_process(delta: float) -> void:
	procesar_dano_contacto()
	if player == null or not is_instance_valid(player):
		velocity = Vector2.ZERO
		return
	match estado:
		Estado.HUIR: 
			procesar_huida()
			sprite.play("default")
		Estado.ESPERAR: 
			procesar_espera(delta)
			sprite.play("idle")
		Estado.DISPARAR:
			disparar()
			cambiar_estado(Estado.HUIR)
	if velocity.x>=0:
		boca_actual=boca
		sprite.flip_h=false
	else:
		boca_actual=boca2
		sprite.flip_h=true
	move_and_slide()
	
func procesar_huida() -> void:
	var distancia_player: float = global_position.distance_to(
		player.global_position
	)
	if distancia_player >= distancia_objetivo:
		cambiar_estado(Estado.ESPERAR)
		return
	var direccion_huida: Vector2 = player.global_position.direction_to(
		global_position
	)
	var destino_deseado: Vector2 = global_position + (
		direccion_huida * distancia_objetivo
	)
	var mapa:RID=navigation_agent.get_navigation_map()
	var destino_valido:Vector2=NavigationServer2D.map_get_closest_point(
		mapa,destino_deseado
	)
	navigation_agent.target_position = destino_valido
	var siguiente_punto: Vector2 = navigation_agent.get_next_path_position()
	var direccion: Vector2 = global_position.direction_to(
		siguiente_punto
	)
	velocity = direccion * velocidad_real * multiplicador_huida
func procesar_espera(delta: float) -> void:
	velocity = Vector2.ZERO
	tiempo_estado -= delta
	if tiempo_estado <= 0: cambiar_estado(Estado.DISPARAR)

func cambiar_estado(nuevo_estado: Estado) -> void:
	estado = nuevo_estado
	match estado:
		Estado.HUIR:
			pass
		Estado.ESPERAR:
			velocity = Vector2.ZERO
			tiempo_estado = tiempo_espera
		Estado.DISPARAR:
			velocity = Vector2.ZERO
			
func disparar() -> void:
	var nueva_piedra = proyectil.instantiate()
	get_tree().current_scene.add_child(nueva_piedra)
	nueva_piedra.global_position = boca_actual.global_position
	var direccion: Vector2 = boca_actual.global_position.direction_to(
		player.global_position
	)
	nueva_piedra.lanzar(direccion, dano,"default2","explotar2")
	
func procesar_dano_contacto() -> void:
	for body in area_dano.get_overlapping_bodies():
		if body.is_in_group("player"): body.recibir_dano(dano)
