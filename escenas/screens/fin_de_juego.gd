extends Control

signal reiniciar_partida

@export var boton_menu: Button
@export var boton_reiniciar: Button
@export var sound:AudioStreamPlayer2D
func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	boton_menu.pressed.connect(_on_menu_pressed)
	boton_reiniciar.pressed.connect(_on_reiniciar_pressed)
	sound.stop()

func reproducir_audio() -> void:
	sound.play()

func _on_reiniciar_pressed() -> void:
	sound.stop()
	reiniciar_partida.emit()


func _on_menu_pressed() -> void:
	sound.stop()
	get_tree().paused = false
	get_tree().change_scene_to_file(
		"res://escenas/screens/menu.tscn"
	)
