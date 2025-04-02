extends Control

@export var NewsText:RichTextLabel

var IsActive:bool = false

var OptionsMenuOpen:bool

@export var OptionsMenu:OptionsMenuManager
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("pause"):
		Pause()
	if IsActive:
		MoveNewsText()
	pass
	
func Pause():
	IsActive = !IsActive
	visible = IsActive
	get_tree().paused = IsActive
	OptionsMenuOpen = false
	ToggleCheck()
	
func Quit():
	get_tree().quit()
	
func ToggleOptionsMenu():
	OptionsMenuOpen = !OptionsMenuOpen
	OptionsMenu.visible = OptionsMenuOpen
	
func ToggleCheck():
	AudioServer.set_bus_effect_enabled(1,0,IsActive)
	AudioServer.set_bus_effect_enabled(1,1,IsActive)


func MoveNewsText():
	NewsText.position.x += -500 * Globals.delta
	if NewsText.position.x < -NewsText.get_content_width():
		NewsText.position.x = get_viewport_rect().size.x
