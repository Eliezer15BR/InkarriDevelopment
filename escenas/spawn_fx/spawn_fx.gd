extends Control

@export var boton_menu: Button
@export var boton_reiniciar: Button

signal reiniciar_partida


func _ready() -> void:
	boton_menu.pressed.connect(_on_menu_pressed)
	boton_reiniciar.pressed.connect(_on_reiniciar_pressed)


func _on_menu_pressed() -> void:
	get_tree().change_scene_to_file(
		"res://escenas/menu/menu.tscn"
	)


func _on_reiniciar_pressed() -> void:
	reiniciar_partida.emit()
