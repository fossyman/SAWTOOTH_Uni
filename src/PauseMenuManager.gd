extends Control

@export var NewsText:RichTextLabel

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	MoveNewsText()
	pass


func MoveNewsText():
	NewsText.position.x += -5
	if NewsText.position.x < -NewsText.get_content_width():
		NewsText.position.x = get_viewport_rect().size.x
