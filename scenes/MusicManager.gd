extends AudioStreamPlayer
class_name MusicManager

@export var CurrentSong:AudioStream
@export var SongLoop:AudioStream

func ChangeSong(_NewSong:AudioStream,_SongLoop:AudioStream,FadeIn:bool = false):
	CurrentSong = _NewSong
	SongLoop = _SongLoop
	stream = CurrentSong
	play()
	
	
func ChangeFinishedSong():
	if SongLoop:
		if stream != SongLoop:
			stream = SongLoop
		play()
	pass
