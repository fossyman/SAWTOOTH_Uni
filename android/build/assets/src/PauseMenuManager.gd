extends Control

@export var NewsText:RichTextLabel

var IsActive:bool = false
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("pause"):
		IsActive = !IsActive
		visible = IsActive
		get_tree().paused = IsActive
		
	if IsActive:
		MoveNewsText()
	pass


func MoveNewsText():
	NewsText.position.x += -5
	if NewsText.position.x < -NewsText.get_content_width():
		NewsText.position.x = get_viewport_rect().size.x
