extends CharacterBody3D
class_name PlayerManager

const SPEED = 5.0
const JUMP_VELOCITY = 4.5

var RayOrigin
var RayEnd

@export var MeshParent:Node3D
@export var AttackOrigin:Node3D

var DesiredLookRotation:Vector3
# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

var CanAttack:bool = true


func _process(delta):
	print(CanAttack)
	if Input.is_action_pressed("attack") and CanAttack:
		if is_instance_valid(Globals.Inventory.CurrentWeapon):
			CanAttack = false
			AttackManagement()
	
	
	
	MeshParent.rotation.y = lerp_angle(MeshParent.rotation.y,atan2(-DesiredLookRotation.x,-DesiredLookRotation.z),25*delta)
	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

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

	move_and_slide()
	
func _physics_process(delta):
	CalculateLookDirection()
	
func CalculateLookDirection():
	var SpaceState = get_world_3d().direct_space_state
	var MousePos = get_viewport().get_mouse_position()
	RayOrigin = Globals.MainCamera.project_ray_origin(MousePos)
	RayEnd = RayOrigin + Globals.MainCamera.project_ray_normal(MousePos) * 2000
	
	var query = PhysicsRayQueryParameters3D.create(RayOrigin, RayEnd)
	var Intersection = SpaceState.intersect_ray(query)
	
	if !Intersection.is_empty():
		DesiredLookRotation = to_local(Intersection.position)


func AttackManagement():
	CanAttack = false
	
	for i in Globals.Inventory.CurrentWeapon.RayCount:
		var space_state = get_world_3d().direct_space_state
		var query = PhysicsRayQueryParameters3D.create(AttackOrigin.global_position, (MeshParent.global_transform.basis.z).normalized() * -999)
		query.collide_with_areas = true
		query.exclude = [self]
		var result = space_state.intersect_ray(query)
		if result.values()[4] is COMP_Hurtbox:
			(result.values()[4] as COMP_Hurtbox).HealthComponent.Damage(Globals.Inventory.CurrentWeapon.Damage)
		
	await get_tree().create_timer(Globals.Inventory.CurrentWeapon.AttackSpeed).timeout
	CanAttack = true
