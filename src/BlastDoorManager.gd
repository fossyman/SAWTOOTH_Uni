extends Node
class_name BlastDoorManager
@export var TopSection:Node3D
@export var BottomSection:Node3D
@export var Collision:CollisionShape3D

var DoorTween:Tween
# Called when the node enters the scene tree for the first time.
func _ready():
	OpenDoor()
	pass # Replace with function body.


func CloseDoor():
	call_deferred("EnableCollision")
	if DoorTween:
		DoorTween.kill()
	DoorTween = get_tree().create_tween()
	DoorTween.parallel().tween_property(TopSection,"position",Vector3.ZERO,1)
	DoorTween.parallel().tween_property(BottomSection,"position",Vector3.ZERO,1)
	pass
func OpenDoor():
	call_deferred("DisableCollision")
	if DoorTween:
		DoorTween.kill()
	DoorTween = get_tree().create_tween()
	DoorTween.parallel().tween_property(TopSection,"position",Vector3.UP * 3 ,1)
	DoorTween.parallel().tween_property(BottomSection,"position",Vector3.UP * -1.8 ,1)
	pass
	
func EnableCollision():
	Collision.disabled = false
	
func DisableCollision():
	Collision.disabled = true
