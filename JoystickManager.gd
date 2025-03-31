# Created with help from Youtuber Venex Source: https://www.youtube.com/watch?v=j6H6Enuvb7s
extends TouchScreenButton
class_name Joystick

@export var Radius:float
@export var Knob:Node2D
@onready var StickCenter:Vector2 = texture_normal.get_size() / 2
var Pressed:bool = false
# Called when the node enters the scene tree for the first time.
func _ready():
	set_process(false)
	Knob.position = StickCenter
	pass # Replace with function body.

func _process(delta):
	Knob.global_position = get_global_mouse_position()
	Knob.position = StickCenter + (Knob.position - StickCenter).limit_length(Radius)

func _pressed():
	set_process(true)
	Pressed = true
	pass # Replace with function body.


func _on_released():
	set_process(false)
	Pressed = false
	Knob.position = StickCenter
	pass # Replace with function body.

func GetJoystickDirection() -> Vector2:
	var dir = Knob.position - StickCenter
	return dir.normalized()
	pass
	
func SetJoystickDirection(dir:Vector2):
	dir = dir.normalized()
	Knob.position = StickCenter + (dir * Radius)
	pass
