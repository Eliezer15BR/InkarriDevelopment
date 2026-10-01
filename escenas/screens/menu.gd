extends Control

@export var boton_jugar: Button
@export var boton_salir: Button


func _ready() -> void:
	boton_jugar.pressed.connect(_on_jugar_pressed)
	boton_salir.pressed.connect(_on_salir_pressed)

func _on_jugar_pressed() -> void:
	get_tree().change_scene_to_file(
		"res://escenas/principal_screen/principal_screen.tscn"
	)

func _on_salir_pressed() -> void:
	get_tree().quit()
