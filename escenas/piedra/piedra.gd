extends Area2D
@export var velocidad: float = 400.0
@export var sprite: AnimatedSprite2D
@export var sound: AudioStreamPlayer2D
var direccion = Vector2(0,0)
var dano: float=0.0
var impacto: bool =false
func _ready() -> void:
	add_to_group("proyectiles")
	body_entered.connect(_on_body_entered)
func lanzar(new_dir: Vector2,nuevo_dano:float) -> void:
	dano=nuevo_dano
	direccion=new_dir.normalized()
	sprite.play("girar")
func _physics_process(delta: float) -> void:
	position += direccion * velocidad * delta
func _on_body_entered(body: Node2D) -> void:
	if impacto: return
	impacto=true
	if body.has_method("recibir_dano"): 
		sound.play()
		body.recibir_dano(dano)
	animar("explotar")
	velocidad=0
	await get_tree().create_timer(0.2).timeout
	queue_free()
func animar(animacion:String):
	sprite.play(animacion)
