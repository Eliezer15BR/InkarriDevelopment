extends Control

@export var boton_jugar: Button
@export var boton_salir: Button
@export var boton_controles:Button

func _ready() -> void:
	boton_jugar.pressed.connect(_on_jugar_pressed)
	boton_salir.pressed.connect(_on_salir_pressed)
	boton_controles.pressed.connect(_on_controles_pressed)

func _on_controles_pressed() -> void:
	get_tree().change_scene_to_file(
		"res://escenas/screens/control.tscn"
	)

func _on_jugar_pressed() -> void:
	get_tree().change_scene_to_file(
		"res://escenas/principal_screen/principal_screen.tscn"
	)

func _on_salir_pressed() -> void:
	get_tree().quit()
