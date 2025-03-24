extends Node3D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func TransitionAreaEntered(body:Node3D):
	if body == Globals.Player:
		MapManager.instance.ProgressFloor()
