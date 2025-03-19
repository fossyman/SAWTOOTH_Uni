extends Control
class_name HUDManager
static var instance:HUDManager

@export var FadeRect:ColorRect
var FadeTween:Tween

@export var Healthbar:TextureProgressBar

@export var HealthColours:GradientTexture1D

func _enter_tree():
	if !instance:
		instance = self
	else:
		queue_free()

# Called when the node enters the scene tree for the first time.
func _ready():
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
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
