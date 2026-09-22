extends CharacterBody2D
@export var piedra_objeto: PackedScene
@export var sprite2d1: AnimatedSprite2D
@export var sprite2d2: AnimatedSprite2D
@export var markerL: Marker2D
@export var markerR: Marker2D
@export var build: BuildResource
@export var tiempo_invulnerabilidad: float = 5.0
signal vida_cambiada(vida_actual: float, vida_maxima: float)
signal murio
var invulnerable: bool = false
var tiempo_entre_disparos: float= 1.0
signal monedas_sign(cantidad:int)
var cooldown_disparo: float = 0.0
var _velocidad:float=0.0
var objeto_interactuable:Node=null;
var monedas:int=0
const PIXELS_PER_MOVEMENT: float = 25.0
var vida_maxima:float
var vida_actual:float
var dano:float
var velocidad_movimiento: float
var velocidad_ataque: float
var defensa: float
var fortuna: float
func _ready() -> void:
	aplicar_build(build)
	animar('idle')
func _physics_process(delta: float) -> void:
	var left=Input.is_action_pressed("izq")
	var right=Input.is_action_pressed("der")
	var up=Input.is_action_pressed("arriba")
	var down=Input.is_action_pressed("abajo")
	var leftDis=int(Input.is_action_pressed("ui_left")) *-1
	var rightDis=int(Input.is_action_pressed("ui_right"))
	var upDis=int(Input.is_action_pressed("ui_up"))*-1
	var downDis=int(Input.is_action_pressed("ui_down"))
	if left:
		velocity.x=-_velocidad
		sprite2d1.flip_h=false
		sprite2d2.flip_h=false
	elif right:
		velocity.x=_velocidad
		sprite2d1.flip_h=true
		sprite2d2.flip_h=true
	if up: 
		velocity.y=-_velocidad
		animar("go_up")
	elif down: 
		velocity.y=_velocidad
		animar("idle")
	elif abs(velocity.x)>0: animar("go_x")
	if !left and !right: velocity.x=0
	if !up and !down: velocity.y=0
	if cooldown_disparo > 0:
		cooldown_disparo -= delta
	if ((leftDis+rightDis)!=0 or (upDis+downDis)!=0) and cooldown_disparo <= 0:
		lanzar_objeto(leftDis+rightDis,upDis+downDis,sprite2d1.flip_h)
		cooldown_disparo = tiempo_entre_disparos
	if Input.is_action_just_pressed("interactuar"):
		if objeto_interactuable!=null and is_instance_valid(objeto_interactuable):
			objeto_interactuable.interactuar(self)
			objeto_interactuable=null
		
	move_and_slide()
		
func lanzar_objeto(x_dir,y_dir, dir):
	var piedra = piedra_objeto.instantiate()
	get_tree().current_scene.add_child(piedra)
	if !dir: piedra.global_position=markerL.global_position
	else: piedra.global_position=markerR.global_position
	var new_dir:Vector2=Vector2(x_dir,y_dir)
	piedra.lanzar(new_dir,dano)

func animar(accion: String):
	sprite2d1.play(accion)
	sprite2d2.play(accion)

func agregar_moneda()->void:
	monedas+=1
	monedas_sign.emit(monedas)

func registrar_interactuable(objeto: Node)-> void: objeto_interactuable=objeto
func quitar_interactuable(objeto: Node)->void:
	if objeto_interactuable==objeto: objeto_interactuable=null
	
func aplicar_build(nueva_build: BuildResource)->void:
	if nueva_build==null:
		push_error("El Player no tiene build")
		return
	vida_maxima=nueva_build.vida
	vida_actual=vida_maxima
	dano=nueva_build.dano
	velocidad_movimiento=nueva_build.velocidad_movimiento
	velocidad_ataque=nueva_build.velocidad_ataque
	defensa=nueva_build.defensa
	fortuna=nueva_build.fortuna
	_velocidad=velocidad_movimiento*PIXELS_PER_MOVEMENT
	if velocidad_ataque > 0:
		tiempo_entre_disparos=1.0/velocidad_ataque
	vida_cambiada.emit(vida_actual,vida_maxima)
	
func recibir_dano(cantidad:float) -> void:
	if invulnerable or vida_actual<=0:
		return
	var multiplicador_defensa: float=1.0-(defensa/100.0)
	var dano_final: float=cantidad*multiplicador_defensa
	dano_final=max(dano_final,0)
	if dano_final<=0: return
	vida_actual=max(vida_actual-dano_final,0.0)
	vida_cambiada.emit(vida_actual,vida_maxima)
	if vida_actual<=0: 
		morir()
		return
	activar_invulnerabilidad()
func curar(cantidad: float) -> void:
	if vida_actual<=0: return
	vida_actual=min(vida_actual+cantidad,vida_maxima)
	vida_cambiada.emit(vida_actual,vida_maxima)
func morir()->void:
	murio.emit()

func activar_invulnerabilidad()->void:
	invulnerable=true
	var tiempo_final:int=Time.get_ticks_msec()+int(tiempo_invulnerabilidad*1000.0)
	while Time.get_ticks_msec()<tiempo_final:
		sprite2d1.visible=false
		sprite2d2.visible=false
		await get_tree().create_timer(0.1).timeout
		sprite2d1.visible=true
		sprite2d2.visible=true
		await get_tree().create_timer(0.1).timeout
	sprite2d1.visible=true
	sprite2d2.visible=true
	invulnerable=false
		
	
