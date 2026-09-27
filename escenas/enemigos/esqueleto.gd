extends EnemyBase
@export var navigation_agent: NavigationAgent2D
@export var area_dano: Area2D
@export var animacion: AnimatedSprite2D
var player: CharacterBody2D = null
func _ready():
	super._ready()
	navigation_agent.radius = 16.0
	navigation_agent.avoidance_enabled = true
	player = get_tree().get_first_node_in_group("player")
	await get_tree().physics_frame

func _physics_process(_delta: float) -> void:
	procesar_dano()
	if player == null or not is_instance_valid(player): return
	navigation_agent.target_position = player.global_position
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
