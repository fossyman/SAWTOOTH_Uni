extends Node

@export var noise:NoiseTexture2D
var SamplePoint:Vector2
@export var ParentNode:Node3D
@export var Speed:float = 1.0
@export var Amp:float = 1.0
var BaseRot:Vector3
var T:float
# Called when the node enters the scene tree for the first time.
func _ready():
	BaseRot = ParentNode.rotation_degrees
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	T+= delta
	SamplePoint = Vector2(sin(T) * Amp,cos(T) * Amp)
	var _noiseX = noise.noise.get_noise_2d(SamplePoint.x,SamplePoint.y)
	var _noiseY = noise.noise.get_noise_2d(SamplePoint.y,SamplePoint.x)
	ParentNode.rotation_degrees.x = BaseRot.x + _noiseX
	ParentNode.rotation_degrees.y =  BaseRot.y + _noiseY
	pass
