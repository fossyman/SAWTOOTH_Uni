extends Area3D
class_name Interactable

signal _Interact
@export var CanInteract:bool = true
@export var OnTouch:bool = false
# Called when the node enters the scene tree for the first time.
func _ready():

	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func Interact():
	if CanInteract:
		_Interact.emit()
	pass
