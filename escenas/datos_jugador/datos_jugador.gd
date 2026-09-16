extends Control
@export var label_monedas:Label
@export var player: CharacterBody2D
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player.monedas_sign.connect(actualizar_monedas)
	actualizar_monedas(player.monedas)


func actualizar_monedas(cantidad:int)-> void:
	label_monedas.text=" x "+str(cantidad)
