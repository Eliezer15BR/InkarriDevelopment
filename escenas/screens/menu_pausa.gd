extends Control

@export var boton_continuar: Button
@export var boton_menu: Button
@export var pantalla_fin_juego: Control

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	visible = false

	boton_continuar.pressed.connect(_on_continuar_pressed)
	boton_menu.pressed.connect(_on_menu_pressed)


func _unhandled_input(event: InputEvent) -> void:
	if not event.is_action_pressed("pausa"): return
	if pantalla_fin_juego != null and pantalla_fin_juego.visible: return
	if visible: continuar_partida()
	else: pausar_partida()

func pausar_partida() -> void:
	visible = true
	get_tree().paused = true

func continuar_partida() -> void:
	get_tree().paused = false
	visible = false

func _on_continuar_pressed() -> void:
	continuar_partida()

func _on_menu_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file(
		"res://escenas/screens/menu.tscn"
	)
