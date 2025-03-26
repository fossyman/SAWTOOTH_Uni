extends Node3D
class_name WarningLight

@export var IsActive:bool

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if IsActive:
		rotate_x(deg_to_rad(1))
	pass
	
func SetActive(value:bool):
	IsActive = value
	visible = IsActive
