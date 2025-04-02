extends Node

@export var StartingMusic:AudioStream
@export var StartingMusicLoop:AudioStream

# Called when the node enters the scene tree for the first time.
func _ready():
	Globals.MusicPlayer.ChangeSong(StartingMusic,StartingMusicLoop)
	HUDManager.instance.FadeIn()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
