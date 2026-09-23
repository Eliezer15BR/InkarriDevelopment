extends EnemyBase

@export var proyectil: PackedScene
@export var boca: Marker2D
@export var area_dano: Area2D
@export var intervalo_disparo: float = 0.4
var player: CharacterBody2D = null
var cooldown_disparo: float = 0.0

func _ready() -> void:
	super._ready()
	player = get_tree().get_first_node_in_group("player")


func _physics_process(delta: float) -> void:
	procesar_dano()
	if player == null or not is_instance_valid(player): return
	cooldown_disparo -= delta
	if cooldown_disparo <= 0:
		disparar()
		cooldown_disparo = intervalo_disparo
		
func disparar() -> void:
	var nueva_piedra = proyectil.instantiate()
	get_tree().current_scene.add_child(nueva_piedra)
	nueva_piedra.global_position = boca.global_position
	var direccion: Vector2 = boca.global_position.direction_to(
		player.global_position
	)
	nueva_piedra.lanzar(direccion, dano)
	
func procesar_dano()->void:
	for body in area_dano.get_overlapping_bodies():
		if body.is_in_group("player"): body.recibir_dano(dano)
