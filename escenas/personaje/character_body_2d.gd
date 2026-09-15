extends CharacterBody2D
@export var piedra_objeto: PackedScene
@export var sprite2d1: AnimatedSprite2D
@export var sprite2d2: AnimatedSprite2D
@export var markerL: Marker2D
@export var markerR: Marker2D
@export var tiempo_entre_disparos: float = 0.2
var cooldown_disparo: float = 0.0
var _velocidad:float=100.0
func _ready() -> void:
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
	move_and_slide()
		
func lanzar_objeto(x_dir,y_dir, dir):
	var piedra = piedra_objeto.instantiate()
	get_tree().current_scene.add_child(piedra)
	if !dir: piedra.global_position=markerL.global_position
	else: piedra.global_position=markerR.global_position
	var new_dir:Vector2=Vector2(x_dir,y_dir)
	piedra.lanzar(new_dir)

func animar(accion: String):
	sprite2d1.play(accion)
	sprite2d2.play(accion)
