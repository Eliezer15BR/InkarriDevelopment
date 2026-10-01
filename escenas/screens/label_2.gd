extends Label


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var version=ProjectSettings.get_setting("application/config/version")
	self.text="Version "+version
