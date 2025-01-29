extends CharacterBody3D
class_name BaseEnemy

const SPEED = 5.0

@export var NavAgent:NavigationAgent3D

func _process(delta):

	var CurrentPosition:Vector3 = global_transform.origin
	var NextLocation:Vector3 = NavAgent.get_next_path_position()
	var NewVelocity:Vector3 = (NextLocation - CurrentPosition).normalized() * SPEED
	
	NavAgent.velocity = NewVelocity


func _TargetReached():
	pass # Replace with function body.


func _VelocityComputed(safe_velocity):
	velocity = velocity.move_toward(safe_velocity, 0.25)
	move_and_slide()
	pass # Replace with function body.

func SetTarget(newtarget:Node3D):
	if newtarget == null:
		return
		
	NavAgent.target_position = newtarget.global_position

func _AITimeout():
	SetTarget(Globals.Player)
	pass # Replace with function body.


func _Damaged():
	print("ARGHHH!")
	pass # Replace with function body.


func _Death():
	print("EUGH")
	queue_free()
	pass # Replace with function body.


func _Healed():
	print(" '' - 0:15 ")
	pass # Replace with function body.
