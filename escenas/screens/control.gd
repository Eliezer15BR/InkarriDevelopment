extends Control
@export var boton_volver: Button

func _ready() -> void:
	boton_volver.pressed.connect(_on_volver_pressed)

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("pausa"):
		volver()

func _on_volver_pressed() -> void: volver()

func volver() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file(
		"res://escenas/screens/menu.tscn"
	)
