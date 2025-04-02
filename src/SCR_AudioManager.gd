extends Node
class_name SFXManager
var SFXPlayers:Array[AudioStreamPlayer]

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func PlaySFX(_NEWSFX:AudioStream):
	if SFXPlayers.size() < 0:
		for i in SFXPlayers.size():
			if !SFXPlayers[i].playing:
				SFXPlayers[i].stream = _NEWSFX
				SFXPlayers[i].play()
	else:
		var stream = AudioStreamPlayer2D.new()
		add_child(stream)
		stream.stream = _NEWSFX
		stream.bus = &"SFX"
		stream.play()
