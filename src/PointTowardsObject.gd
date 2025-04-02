extends MeshInstance3D

var Target:Node3D

# Called when the node enters the scene tree for the first time.
func _ready():
	Target = Globals.Player
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if is_instance_valid(Target):
		look_at(Target.global_position)
	pass
