extends Control
class_name WORLDGUI
@export var PlacementNode:Node3D

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var pos = Globals.MainCamera.unproject_position(PlacementNode.global_position)
	global_position = pos
	pass
