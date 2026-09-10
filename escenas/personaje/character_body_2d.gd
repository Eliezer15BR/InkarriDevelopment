extends CharacterBody2D
@export var sprite2d: Sprite2D
var _velocidad:float=100.0
func _physics_process(delta: float) -> void:
	var left=Input.is_action_pressed("ui_left")
	var right=Input.is_action_pressed("ui_right")
	var up=Input.is_action_pressed("ui_up")
	var down=Input.is_action_pressed("ui_down")
	if left:
		velocity.x=-_velocidad
		sprite2d.flip_h=true
	elif right:
		velocity.x=_velocidad
		sprite2d.flip_h=false	
	if up: velocity.y=-_velocidad
	if down: velocity.y=_velocidad
	if !left and !right: velocity.x=0
	if !up and !down: velocity.y=0
	move_and_slide()
		
