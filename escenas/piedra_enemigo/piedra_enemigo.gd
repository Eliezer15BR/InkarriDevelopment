extends Area2D
@export var velocidad: float = 400.0
@export var sprite: AnimatedSprite2D
var direccion = Vector2(0,0)
var dano: float=0.0
var impacto: bool =false
var animacion_explosion:StringName=&"explotar"
func _ready() -> void:
	body_entered.connect(_on_body_entered)
func lanzar(new_dir: Vector2,nuevo_dano:float,
animacion_vuelo=&"default",n_animacion_explosion=&"explotar") -> void:
	sprite.play(animacion_vuelo)
	dano=nuevo_dano
	animacion_explosion=n_animacion_explosion
	direccion=new_dir.normalized()
func _physics_process(delta: float) -> void:
	position += direccion * velocidad * delta
func _on_body_entered(body: Node2D) -> void:
	if impacto: return
	impacto=true
	if body.is_in_group("player"): body.recibir_dano(dano)
	animar(animacion_explosion)
	velocidad=0
	await get_tree().create_timer(0.2).timeout
	queue_free()
func animar(animacion:String):
	sprite.play(animacion)
