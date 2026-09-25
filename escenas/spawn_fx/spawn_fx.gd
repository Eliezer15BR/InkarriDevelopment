extends Node2D

@export var animacion: AnimatedSprite2D

func _ready() -> void:
	animacion.stop()

	for i in range(6):
		animacion.frame = i
		print("FRAME: ", i)
		await get_tree().create_timer(0.2).timeout
