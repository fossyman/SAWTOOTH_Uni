extends Node3D

@export var HealAmount:int
@export var InteractComponent:Interactable
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _Heal():
	Globals.Player.Heal(HealAmount)
	queue_free()
