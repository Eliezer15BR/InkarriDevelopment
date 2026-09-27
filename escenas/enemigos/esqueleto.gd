extends EnemyBase
enum LadoObjetivo{
	IZQ, DER
}
@export var navigation_agent: NavigationAgent2D
@export var area_dano: Area2D
@export var animacion: AnimatedSprite2D
@export var lado_objetivo:LadoObjetivo = LadoObjetivo.IZQ
var player: CharacterBody2D = null
var objetivo: Marker2D=null
func _ready():
	super._ready()
	player = get_tree().get_first_node_in_group("player")
	if player==null: return
	if lado_objetivo==LadoObjetivo.IZQ: objetivo=player.get_node("EnemyTargetL")
	else: objetivo=player.get_node("EnemyTargetR")
	await get_tree().physics_frame

func _physics_process(_delta: float) -> void:
	procesar_dano()
	if objetivo==null or not is_instance_valid(objetivo): return
	var mapa:=navigation_agent.get_navigation_map()
	var destino_valido:=NavigationServer2D.map_get_closest_point(
		mapa, objetivo.global_position
	)
	if navigation_agent.target_position.distance_to(destino_valido)>8.0:
		navigation_agent.target_position=destino_valido
	if navigation_agent.is_navigation_finished():
		velocity = Vector2(0, 0)
		return
	var sig_punto: Vector2 = navigation_agent.get_next_path_position()
	var direccion: Vector2 = global_position.direction_to(sig_punto)
	if direccion.x < 0: animacion.flip_h=true
	else: animacion.flip_h=false
	if direccion.y < 0: animacion.play("go_up")
	else: animacion.play("default")
	velocity = direccion * velocidad_real
	move_and_slide()

func procesar_dano() -> void:
	for body in area_dano.get_overlapping_bodies():
		if body.is_in_group("player"):
			body.recibir_dano(dano)
