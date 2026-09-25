extends CharacterBody2D
class_name  EnemyBase
signal vida_cambiada(vida_actual:float, vida_maxima:float)
signal murio(enemigo: EnemyBase)
@export var estadisticas: EnemyStatsResource
const SPAWN_FX=preload("res://escenas/spawn_fx/spawn_fx.tscn")
const PIXELS_PER_MOVEMENT: float=25.0
var vida_maxima:float
var vida_actual:float
var velocidad_movimiento: float
var defensa:float
var velocidad_real:float
var dano: float
var activo:bool=false
func _ready():
	aplicar_estadisticas()
	iniciar_aparicion()
	
func aplicar_estadisticas():
	if estadisticas==null:
		push_error("El enemigo no tiene stats")
		return
	vida_maxima=estadisticas.vida
	vida_actual=vida_maxima
	dano=estadisticas.dano
	velocidad_movimiento=estadisticas.velocidad_movimiento
	defensa=estadisticas.defensa
	velocidad_real=velocidad_movimiento*PIXELS_PER_MOVEMENT
	vida_cambiada.emit(vida_actual,vida_maxima)

func recibir_dano(cantidad:float):
	if vida_actual<=0: return
	var multiplicador_defensa: float=1.0-(defensa/100.0)
	var dano_final: float=cantidad*multiplicador_defensa
	if dano_final<=0: return
	vida_actual=max(vida_actual-dano_final,0)
	vida_cambiada.emit(vida_actual,vida_maxima)
	if vida_actual<=0: morir()

func morir():
	murio.emit(self)
	queue_free()

func iniciar_aparicion() -> void:
	activo = false
	set_physics_process(false)

	var efecto = SPAWN_FX.instantiate()
	get_parent().add_child(efecto)
	efecto.global_position = global_position

	await get_tree().create_timer(1.5).timeout

	efecto.queue_free()

	activo = true
	set_physics_process(true)
