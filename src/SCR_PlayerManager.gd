extends CharacterBody3D
class_name PlayerManager

@export var SPEED = 5.0
const JUMP_VELOCITY = 4.5

var RayOrigin
var RayEnd

@export var MeshParent:Node3D
@export var AttackOrigin:Node3D

@export var DebugLineMesh:MeshInstance3D
@export var DebugLineMat:StandardMaterial3D

@export var MeshAnimationTree:AnimationTree

@export var GunAnimationTree:AnimationTree

var MovementVector:Vector2
var DesiredMovementVector:Vector2

var DesiredLookRotation:Vector3
# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

var CanAttack:bool = true

var CachedRaycaseQuery:PhysicsRayQueryParameters3D

func _ready():
	CachedRaycaseQuery = PhysicsRayQueryParameters3D.create(Vector3.ZERO, Vector3.ZERO,8388608)
	CachedRaycaseQuery.collide_with_areas = true
func _process(delta):
	var direction:Vector3 = CalculateVelocity(delta)

	move_and_slide()
	
	MovementRotationCalculator(direction,delta)
	
	
	
func _physics_process(delta):
	CalculateLookDirection()

func CalculateVelocity(delta:float):
	if Input.is_action_pressed("attack") and CanAttack:
		if is_instance_valid(Globals.Inventory.CurrentWeapon):
			CanAttack = false
			AttackManagement()
	
	if !is_on_floor():
		velocity.y += -gravity * delta
	
	MeshParent.rotation.y = lerp_angle(MeshParent.rotation.y,atan2(-DesiredLookRotation.x,-DesiredLookRotation.z),25*delta)

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir = Input.get_vector("move_left", "move_right", "move_forward", "move_back")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)
		
	return direction

func MovementRotationCalculator(direction:Vector3,delta):
	var Forward = -MeshParent.global_transform.basis.z
	var Sides = -MeshParent.global_transform.basis.x
	var FB = Forward.dot(direction)
	var LR = Sides.dot(direction)
	if direction:
		DesiredMovementVector = Vector2(-LR,FB)
		pass
	else:
		DesiredMovementVector = Vector2.ZERO
		pass
	MovementVector = lerp(MovementVector,DesiredMovementVector,15*delta)
	MeshAnimationTree["parameters/MovementBlend/blend_position"] = MovementVector

func CalculateLookDirection():
	var SpaceState = get_world_3d().direct_space_state
	var MousePos = get_viewport().get_mouse_position()
	RayOrigin = Globals.MainCamera.project_ray_origin(MousePos)
	RayEnd = RayOrigin + Globals.MainCamera.project_ray_normal(MousePos) * 2000

	CachedRaycaseQuery.from = RayOrigin
	CachedRaycaseQuery.to = RayEnd
	
	var Intersection = SpaceState.intersect_ray(CachedRaycaseQuery)
	
	if !Intersection.is_empty():
		DesiredLookRotation = to_local(Intersection.position)
	
	

func AttackManagement():
	CanAttack = false
	MeshAnimationTree["parameters/Attack/request"] = AnimationNodeOneShot.ONE_SHOT_REQUEST_ABORT
	MeshAnimationTree["parameters/Attack/request"] = AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE
	GunAnimationTree["parameters/Attack/request"] = AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE
	for i in Globals.Inventory.CurrentWeapon.RayCount:
		var space_state = get_world_3d().direct_space_state
		var query = PhysicsRayQueryParameters3D.create(AttackOrigin.global_position, (MeshParent.global_transform.basis.z) * -999)
		query.collide_with_areas = true
		query.exclude = [self]
		var result = space_state.intersect_ray(query)
		if !result.is_empty():
			if result.values()[4] is COMP_Hurtbox:
				(result.values()[4] as COMP_Hurtbox).HealthComponent.Damage(Globals.Inventory.CurrentWeapon.Damage)
				
	await get_tree().create_timer(Globals.Inventory.CurrentWeapon.AttackSpeed).timeout
	MeshAnimationTree["parameters/Attack/request"] = AnimationNodeOneShot.ONE_SHOT_REQUEST_ABORT
	GunAnimationTree["parameters/Attack/request"] = AnimationNodeOneShot.ONE_SHOT_REQUEST_ABORT
	CanAttack = true
