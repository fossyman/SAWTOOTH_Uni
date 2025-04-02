extends Control
class_name OptionsMenuManager

@export var SFXSlider:HSlider
@export var MusicSlider:HSlider

# Called when the node enters the scene tree for the first time.
func _ready():
	SFXSlider.value = AudioServer.get_bus_volume_db(2)
	MusicSlider.value = AudioServer.get_bus_volume_db(1)
	pass # Replace with function body.

func SFXSliderChanged(value:float):
	ChangeAudioSetting(2,value)
	pass
	
func MusicSliderChanged(value:float):
	ChangeAudioSetting(1,value)
	pass

func ChangeAudioSetting(bus:int,volume:float):
	AudioServer.set_bus_volume_db(bus,volume)
	pass
