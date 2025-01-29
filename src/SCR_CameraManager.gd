extends Node3D

@export var TargetNode:Node3D
@export var BaseTargetNode:Node3D
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	global_position = global_position.lerp(TargetNode.global_position,15*delta)
	pass
