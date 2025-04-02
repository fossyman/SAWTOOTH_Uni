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

@export var MinigunGeo:MeshInstance3D
@export var MinigunGeoMesh:ImmediateMesh
@export var GunTraceParticle:GPUParticles3D
@export var ShellParticle:GPUParticles3D
@export var BulletsParticle:GPUParticles3D
@export var InteractArea:Area3D
@export var AttackSounds:Array[AudioStream]

var MovementVector:Vector2
var DesiredMovementVector:Vector2

var DesiredLookRotation:Vector3
# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

var CanAttack:bool = true

var CachedRaycaseQuery:PhysicsRayQueryParameters3D


@export var HealthComponent:COMP_Health

@export var InteractableArea:Interactable

func _ready():
	CachedRaycaseQuery = PhysicsRayQueryParameters3D.create(Vector3.ZERO, Vector3.ZERO,8388608)
	CachedRaycaseQuery.collide_with_areas = true
	
	MinigunGeoMesh = (MinigunGeo.mesh as ImmediateMesh)

	HealthComponent.Death.connect(Death)
	
func _process(delta):
	if Input.is_action_just_pressed("interact"):
		if InteractableArea:
			print(InteractableArea.name)
			InteractableArea.Interact()
	if !HealthComponent.IsDead:
		var direction:Vector3 = CalculateVelocity(delta)
		MovementRotationCalculator(direction,delta)
		if (Input.is_action_pressed("attack") and Globals.CurrentHardware != Globals.PLAYEDHARDWARE.mobile || HUDManager.instance.AttackingJoystick.GetJoystickDirection()  and Globals.CurrentHardware == Globals.PLAYEDHARDWARE.mobile ) and CanAttack:
			if is_instance_valid(Globals.Inventory.CurrentWeapon):
				CanAttack = false
				AttackManagement()
		move_and_slide()
	
	
	
func _physics_process(delta):
	if !HealthComponent.IsDead:
		CalculateLookDirection()

func CalculateVelocity(delta:float):
	if !is_on_floor():
		velocity.y += -gravity * delta
	
	MeshParent.rotation.y = atan2(-DesiredLookRotation.x,-DesiredLookRotation.z)

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir
	if Globals.CurrentHardware == Globals.PLAYEDHARDWARE.mobile:
		input_dir = HUDManager.instance.MovingJoystick.GetJoystickDirection()
	else:
		input_dir = Input.get_vector("move_left", "move_right", "move_forward", "move_back")
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
	if Globals.CurrentHardware != Globals.PLAYEDHARDWARE.mobile && is_instance_valid(Globals.MainCamera):
		var SpaceState = get_world_3d().direct_space_state
		var MousePos = get_viewport().get_mouse_position()
		RayOrigin = Globals.MainCamera.project_ray_origin(MousePos)
		RayEnd = RayOrigin + Globals.MainCamera.project_ray_normal(MousePos) * 2000

		CachedRaycaseQuery.from = RayOrigin
		CachedRaycaseQuery.to = RayEnd
		
		var Intersection = SpaceState.intersect_ray(CachedRaycaseQuery)
		
		if !Intersection.is_empty():
			DesiredLookRotation = to_local(Intersection.position)
	else:
		var AttackDir:Vector2 = HUDManager.instance.AttackingJoystick.GetJoystickDirection()
		var MoveDir:Vector2 = HUDManager.instance.MovingJoystick.GetJoystickDirection()
		if AttackDir:
			DesiredLookRotation = Vector3(AttackDir.x,0,AttackDir.y)
		elif MoveDir:
			DesiredLookRotation = Vector3(MoveDir.x,0,MoveDir.y)
	

func AttackManagement():
	CanAttack = false
	MeshAnimationTree["parameters/Attack/request"] = AnimationNodeOneShot.ONE_SHOT_REQUEST_ABORT
	MeshAnimationTree["parameters/Attack/request"] = AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE
	GunAnimationTree["parameters/Attack/request"] = AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE
	for i in Globals.Inventory.CurrentWeapon.RayCount:
		var space_state = get_world_3d().direct_space_state
		var query = PhysicsRayQueryParameters3D.create(AttackOrigin.global_position, (AttackOrigin.global_transform.basis.z) * -999)
		query.collide_with_areas = true
		query.exclude = [self]
		var result = space_state.intersect_ray(query)
		if !result.is_empty():
			if result.values()[4] is COMP_Hurtbox:
				(result.values()[4] as COMP_Hurtbox).HealthComponent.Damage(Globals.Inventory.CurrentWeapon.Damage)
			DebugLineMesh.global_position = result.values()[0]
	Globals.SFXPlayer.PlaySFX(AttackSounds.pick_random())
	ShellParticle.emitting = true
	GunTraceParticle.emitting = true
	BulletsParticle.emitting = true
	GunTraceParticle.rotation_degrees.x = randf_range(-15.0,15.0)
	GunTraceParticle.rotation_degrees.y = randf_range(-15.0,15.0)
	await get_tree().create_timer(Globals.Inventory.CurrentWeapon.AttackSpeed).timeout
	MeshAnimationTree["parameters/Attack/request"] = AnimationNodeOneShot.ONE_SHOT_REQUEST_ABORT
	GunAnimationTree["parameters/Attack/request"] = AnimationNodeOneShot.ONE_SHOT_REQUEST_ABORT
	CanAttack = true
	GunTraceParticle.emitting = false;
	ShellParticle.emitting = false
	BulletsParticle.emitting = false

func Damage(Amt:int):
	if !HealthComponent.IsDead:
		HealthComponent.Damage(Amt)
		HUDManager.instance.Healthbar.value = HealthComponent.CurrentHealth
		
func Heal(Amt:int):
	if !HealthComponent.IsDead:
		HealthComponent.Heal(Amt)
		HUDManager.instance.Healthbar.value = HealthComponent.CurrentHealth


func Death():
	MeshAnimationTree["parameters/Death/request"] = AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE
	await get_tree().create_timer(0.5).timeout
	HUDManager.instance.DeathScreen.visible = true
	MeshAnimationTree.active = false
	get_tree().paused = true
	pass
	
func Respawn():
	HUDManager.instance.DeathScreen.visible = false
	HUDManager.instance.DeathCrack.visible = false
	HealthComponent.IsDead = false
	MeshAnimationTree["parameters/Death/request"] = AnimationNodeOneShot.ONE_SHOT_REQUEST_ABORT
	HealthComponent.Heal(100)
	MeshAnimationTree.active = true
	HUDManager.instance.Healthbar.value = HealthComponent.CurrentHealth
	HUDManager.instance.Healthbar.tint_progress = Color.WHITE


func _interact_area_entered(area):
	print(area.name)
	if area is Interactable:
		print("area.name")
		InteractableArea = area as Interactable
		if InteractableArea.OnTouch:
			InteractableArea.Interact()
	pass # Replace with function body.


func _interact_area_exited(area):
	InteractableArea = null
	pass # Replace with function body.
