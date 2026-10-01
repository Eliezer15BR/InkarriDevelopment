extends Control

@export var boton_continuar: Button
@export var boton_menu: Button
@export var pantalla_fin_juego: Control
@export var boton_controles: Button
@export var pantalla_controles: Control
@export var hud_jugador: CanvasItem
@export var hud_enemigos: CanvasItem
@export var hud_info: CanvasItem

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	visible = false
	boton_controles.pressed.connect(_on_controles_pressed)
	boton_continuar.pressed.connect(_on_continuar_pressed)
	boton_menu.pressed.connect(_on_menu_pressed)

func _on_controles_pressed() -> void:
	visible = false
	pantalla_controles.desde_pausa = true
	pantalla_controles.visible = true

func _unhandled_input(event: InputEvent) -> void:
	if not event.is_action_pressed("pausa"): return
	if pantalla_fin_juego != null and pantalla_fin_juego.visible: return
	if visible: continuar_partida()
	else: pausar_partida()

func pausar_partida() -> void:
	visible = true
	if hud_jugador != null: hud_jugador.visible = false
	if hud_enemigos != null:hud_enemigos.visible = false
	if hud_info != null:hud_info.visible = false
	get_tree().paused = true

func continuar_partida() -> void:
	get_tree().paused = false
	visible = false
	if hud_jugador != null: hud_jugador.visible = true
	if hud_enemigos != null: hud_enemigos.visible = true
	if hud_info != null: hud_info.visible = true

func _on_continuar_pressed() -> void:
	continuar_partida()

func _on_menu_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file(
		"res://escenas/screens/menu.tscn"
	)
