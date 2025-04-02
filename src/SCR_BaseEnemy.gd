extends CharacterBody3D
class_name BaseEnemy

const SPEED = 5.0

@export var NavAgent:NavigationAgent3D
@export var CharacterMesh:Node3D
@export var AnimTree:AnimationTree

@export var WallHit:Node3D
@export var FloorHit:Node3D

@onready var NavMap:RID = NavAgent.get_navigation_map()

@export var AITimer:Timer

@export var AttackTimer:Timer
var CanAttack = true

@export var AttackDamage:int

enum TARGETSTATES{WANDERING,CHASING}
var CurrentState:TARGETSTATES = TARGETSTATES.WANDERING
var Target:Node3D

var NextPositionCalculated:bool = false

func _ready():
	AttackTimer.connect("timeout",SetCanAttack)
	await get_tree().create_timer(1.0).timeout
	InitAI()

func _process(delta):

	var CurrentPosition:Vector3 = global_transform.origin
	var NextLocation:Vector3 = NavAgent.get_next_path_position()
	var NewVelocity:Vector3 = (NextLocation - CurrentPosition).normalized() * SPEED
	NavAgent.velocity = NewVelocity
	
	match CurrentState:
		TARGETSTATES.CHASING:
			var dir = -global_position.direction_to(NavAgent.get_next_path_position())
			global_rotation.y = lerp_angle(global_rotation.y,atan2(dir.x,dir.z),5*delta)


func _TargetReached():
	match CurrentState:
		TARGETSTATES.WANDERING:
			rotate_y(deg_to_rad(90))
			NextPositionCalculated = false
			pass
		TARGETSTATES.CHASING:
			Attack()
			pass
	pass # Replace with function body.


func _VelocityComputed(safe_velocity):
	velocity = velocity.move_toward(safe_velocity,0.5)
	AnimTree["parameters/Movement/blend_position"] = Vector2(velocity.x,velocity.z)
	move_and_slide()
	pass # Replace with function body.

func SetTargetPosition(newtarget:Vector3):
	if newtarget == null:
		return
	NavAgent.target_position = NavigationServer3D.map_get_closest_point(NavMap,newtarget)
	
func SetTarget(newtarget:Node3D):
	if newtarget == null:
		return
	Target = newtarget
	NavAgent.target_position = NavigationServer3D.map_get_closest_point(NavMap,Target.position)

func _AITimeout():
	match CurrentState:
		TARGETSTATES.WANDERING:
			if NextPositionCalculated == false:
				var space = get_world_3d().direct_space_state
				var Wallquery = PhysicsRayQueryParameters3D.create(WallHit.global_position,-global_transform.basis.z * 999)
				var Wallcollision = space.intersect_ray(Wallquery)
				if Wallcollision:
					var NewPos = Wallcollision.values()[0];
					SetTargetPosition(NewPos)
					var Floorquery = PhysicsRayQueryParameters3D.create(Wallcollision.values()[0],Wallcollision.values()[0] + (Vector3.DOWN * 999))
					var FloorCollision = space.intersect_ray(Floorquery)
					if FloorCollision:
						FloorHit.global_position = FloorCollision.values()[0]
						NewPos = FloorCollision.values()[0];
						NextPositionCalculated = true
		TARGETSTATES.CHASING:
			SetTarget(Globals.Player)
	CanSeePlayer()
	pass # Replace with function body.

func CanSeePlayer():
	var PlayerDot = global_transform.basis.z.dot(Globals.Player.global_transform.origin)
	if global_position.distance_to(Globals.Player.global_position) <= 25.0:
		var space = get_world_3d().direct_space_state
		var Playerquery = PhysicsRayQueryParameters3D.create(WallHit.global_position, Globals.Player.global_position)
		
		var Collision = space.intersect_ray(Playerquery)
		if Collision:
			if Collision.values()[4] == Globals.Player:
				CurrentState = TARGETSTATES.CHASING
				print(str(name) + " CAN SEE PLAYER")
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
	
	
func InitAI():
	AITimer.start()
	pass
	
func Attack():
	if CanAttack:
		if global_position.distance_to(Globals.Player.global_position) < 2:
			CanAttack=false
			AnimTree["parameters/Attack/request"] = AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE
			AttackTimer.start()
			Globals.Player.Damage(AttackDamage)
		
func SetCanAttack():
	CanAttack = true
