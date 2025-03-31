extends Control
class_name HUDManager
static var instance:HUDManager

@export var FadeRect:ColorRect
var FadeTween:Tween

@export var Healthbar:TextureProgressBar

@export var HealthColours:GradientTexture1D

@export var DeathScreen:Control
@export var DeathCrack:Control

@export var MobileSpecificContainer:Control

@export var MovingJoystick:Joystick
@export var AttackingJoystick:Joystick

func _enter_tree():
	if !instance:
		instance = self
	else:
		queue_free()

# Called when the node enters the scene tree for the first time.
func _ready():
	#MobileSpecificContainer.visible = (Globals.CurrentHardware == Globals.PLAYEDHARDWARE.mobile)
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Globals.CurrentHardware == Globals.PLAYEDHARDWARE.desktop:
		var dir:Vector2 = Vector2(Input.get_action_strength("move_right") - Input.get_action_strength("move_left"),Input.get_action_strength("move_back") - Input.get_action_strength("move_forward"))
		dir = dir.normalized() * MovingJoystick.Radius
		MovingJoystick.SetJoystickDirection(dir)
	else:
		AttackingJoystick.SetJoystickDirection(Vector2.ZERO)
		
	if !Globals.Player.CanAttack:
		var AttackDir = Vector2(Globals.Player.DesiredLookRotation.x,Globals.Player.DesiredLookRotation.z)
		AttackingJoystick.SetJoystickDirection(AttackDir)
	else:
		AttackingJoystick.SetJoystickDirection(Vector2.ZERO)
	pass

func FadeIn(_t:float = 1.0):
	FadeRect.color.a = 1
	if FadeTween:
		FadeTween.stop()
	FadeTween = get_tree().create_tween().set_trans(Tween.TRANS_LINEAR)
	FadeTween.tween_property(FadeRect,"color:a",0,_t)
	pass
	
func FadeOut(_t:float = 1.0):
	FadeRect.color.a = 0
	if FadeTween:
		FadeTween.stop()
	FadeTween = get_tree().create_tween().set_trans(Tween.TRANS_LINEAR)
	FadeTween.tween_property(FadeRect,"color:a",255,_t)
	pass
