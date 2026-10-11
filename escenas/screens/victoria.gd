extends Control
@export var boton_menu=Button
func _ready()->void:
	process_mode=Node.PROCESS_MODE_ALWAYS
	visible=false
	boton_menu.pressed.connect(_on_menu_pressed)

func mostrar_victoria()->void: visible=true

func _on_menu_pressed()->void:
	get_tree().paused=false
	get_tree().change_scene_to_file("res://escenas/screens/menu.tscn")
