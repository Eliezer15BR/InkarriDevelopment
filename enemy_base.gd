extends CharacterBody2D
class_name  EnemyBase
signal vida_cambiada(vida_actual:float, vida_maxima:float)
signal murio(enemigo: EnemyBase)
@export var estadisticas: EnemyStatsResource
const PIXELS_PER_MOVEMENT: float=25.0
var vida_maxima:float
var vida_actual:float
var velocidad_movimiento: float
var defensa:float
var velocidad_real:float
var dano: float
func _ready():
	aplicar_estadisticas()
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
	vida_actual=max(vida_actual,0)
	vida_cambiada.emit(vida_actual,vida_maxima)
	if vida_actual<=0: morir()

func morir():
	murio.emit(self)
	queue_free()
