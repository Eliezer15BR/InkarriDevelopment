extends Control

@export var boton_volver: Button

var desde_pausa: bool = false


func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	boton_volver.pressed.connect(_on_volver_pressed)


func _unhandled_input(event: InputEvent) -> void:
	if not visible: return

	if event.is_action_pressed("pausa"):
		get_viewport().set_input_as_handled()
		volver()


func _on_volver_pressed() -> void:
	volver()


func volver() -> void:
	if desde_pausa:
		visible = false

		var menu_pausa := get_parent().get_node_or_null("MenuPausa")

		if menu_pausa != null:
			menu_pausa.visible = true

	else:
		get_tree().paused = false

		get_tree().change_scene_to_file(
			"res://escenas/screens/menu.tscn"
		)
