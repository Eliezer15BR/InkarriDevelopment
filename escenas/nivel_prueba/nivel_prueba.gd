extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var version=ProjectSettings.get_setting("application/config/version")
	print("Version %s" % version)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
