extends CharacterBody3D
class_name BaseEnemy

const SPEED = 5.0

@export var NavAgent:NavigationAgent3D

enum TARGETSTATES{WANDERING,CHASING}
var CurrentState:TARGETSTATES = TARGETSTATES.WANDERING

func _process(delta):

	var CurrentPosition:Vector3 = global_transform.origin
	var NextLocation:Vector3 = NavAgent.get_next_path_position()
	var NewVelocity:Vector3 = (NextLocation - CurrentPosition).normalized() * SPEED
	
	NavAgent.velocity = NewVelocity
	
	match CurrentState:
		TARGETSTATES.WANDERING:
			
			pass
		TARGETSTATES.CHASING:
			pass


func _TargetReached():
	print("TARGET REACHED")
	match CurrentState:
		TARGETSTATES.WANDERING:
			rotate_y(deg_to_rad(90))
			pass
		TARGETSTATES.CHASING:
			pass
	pass # Replace with function body.


func _VelocityComputed(safe_velocity):
	velocity = velocity.move_toward(safe_velocity, 0.25)
	move_and_slide()
	pass # Replace with function body.

func SetTarget(newtarget:Vector3):
	if newtarget == null:
		return
		
	NavAgent.target_position = newtarget

func _AITimeout():
	CanSeePlayer()
	match CurrentState:
		TARGETSTATES.WANDERING:
			var space = get_world_3d().direct_space_state
			var Wallquery = PhysicsRayQueryParameters3D.create(global_position,global_position - transform.basis.z * 999)
			var Wallcollision = space.intersect_ray(Wallquery)
			if Wallcollision:
				var Floorquery = PhysicsRayQueryParameters3D.create(global_position,global_position - transform.basis.z * 999)
				var FloorCollision = space.intersect_ray(Floorquery)
				if FloorCollision:
					var NewPos = FloorCollision.values()[0];
					SetTarget(NewPos)
		TARGETSTATES.CHASING:
			SetTarget(Globals.Player.global_position)
			pass
	pass # Replace with function body.

func CanSeePlayer():
	var PlayerDot = global_transform.basis.z.dot(Globals.Player.global_transform.origin)
	if global_position.distance_to(Globals.Player.global_position) <= 100.0:
		var space = get_world_3d().direct_space_state
		var Playerquery = PhysicsRayQueryParameters3D.create(global_position, Globals.Player.global_position)
		
		var Collision = space.intersect_ray(Playerquery)
		if Collision:
			if Collision.values()[4] == Globals.Player:
				CurrentState = TARGETSTATES.CHASING
		pass

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
