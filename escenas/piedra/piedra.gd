extends Area2D
@export var velocidad: float = 400.0
@export var sprite: AnimatedSprite2D
var direccion = Vector2(0,0)
func _ready() -> void:
	body_entered.connect(_on_body_entered)
func lanzar(new_dir: Vector2) -> void:
	direccion=new_dir.normalized()
	sprite.play("girar")
func _physics_process(delta: float) -> void:
	position += direccion * velocidad * delta
func _on_body_entered(body: Node2D) -> void:
	animar("explotar")
	velocidad=0
	await get_tree().create_timer(0.2).timeout
	queue_free()
func animar(animacion:String):
	sprite.play(animacion)
