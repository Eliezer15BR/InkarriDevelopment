extends Node2D
@export var animacion:AnimatedSprite2D

func _ready() -> void:
	animacion.play("default")
