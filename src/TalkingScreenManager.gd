extends MeshInstance3D
class_name ScreenManager

@export var AngryOpenMouth:Texture2D
@export var AngryClosedMouth:Texture2D
@export var ScreenMat:Material
@export var SpriteChangeTimer:Timer
@export var RandomMessageTimer:Timer
@export var TextRevealer:Timer
@export var TextHider:Timer
@export var MessageText:RichTextLabel

var MouthOpen:bool = false

var IsTalking:bool = false

enum MOODS{sad,neutral,angry}
@export var CurrentMood:MOODS

@export_multiline var IntroMessages:Array[String]
@export_multiline var OutroMessages:Array[String]
@export_multiline var RandomMessages:Array[String]
@export var IntroMessageLengths:Array[int]
@export var RandomMessageLengths:Array[int]
@export var OutroMessageLengths:Array[int]
var TextIDX:int = -1

# Called when the node enters the scene tree for the first time.
func _ready(): 
	SpriteChangeTimer.timeout.connect(ChangeFace)
	RandomMessageTimer.timeout.connect(DisplayRandomMessage)
	TextRevealer.timeout.connect(RevealNextLetter)
	TextHider.timeout.connect(HideMessage)
	HideMessage()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	MessageText.visible_ratio = move_toward(MessageText.visible_ratio,1,1*delta)
	pass

func ChangeFace():
	if IsTalking:
		MouthOpen = !MouthOpen
	else:
		MouthOpen = false
		
	match CurrentMood:
		MOODS.sad:
			pass
		MOODS.neutral:
			pass
		MOODS.angry:
			if MouthOpen:
				ScreenMat["shader_parameter/pic"] = AngryOpenMouth
			else:
				ScreenMat["shader_parameter/pic"] = AngryClosedMouth
			pass

func DisplayRandomMessage():
	TextIDX+=1
	TextIDX = wrap(TextIDX,0,RandomMessages.size())
	MessageText.visible = true
	IsTalking = true
	var Message:String = RandomMessages[TextIDX]
	MessageText.text = Message
	MessageText.visible_ratio = 0
	TextRevealer.start()
	TextHider.start(5)
	
func DisplayIntroMessage():
	SwitchToFace()
	var IDX = randi_range(0,IntroMessages.size()-1)
	var Message:String = IntroMessages[IDX]
	MessageText.visible = true
	IsTalking = true
	MessageText.text = Message
	MessageText.visible_ratio = 0
	TextRevealer.stop()
	TextRevealer.start()
	RandomMessageTimer.start()
	TextHider.start(5)
	pass
func DisplayOutroMessage():
	var IDX = randi_range(0,OutroMessages.size()-1)
	var Message:String = OutroMessages[IDX]
	MessageText.visible = true
	IsTalking = true
	MessageText.text = Message
	MessageText.visible_ratio = 0
	TextRevealer.stop()
	RandomMessageTimer.stop()
	TextRevealer.start()
	TextHider.start(5)
	await get_tree().create_timer(5).timeout
	SwitchToWallpaper()
	pass

func HideMessage():
	MessageText.visible = false
	IsTalking = false

func RevealNextLetter():
	if (MessageText.visible_characters < RandomMessageLengths[TextIDX] - 1):
		MessageText.visible_characters += 1
	else:
		TextRevealer.stop()
		
func SwitchToFace():
	visible = false
	ScreenMat["shader_parameter/ShowWallpaper"] = false
	visible = true
	pass
	
func SwitchToWallpaper():
	visible = false
	ScreenMat["shader_parameter/ShowWallpaper"] = true
	visible = true
	pass


func Reset():
	SwitchToWallpaper()
	HideMessage()
	ChangeFace()
	RandomMessageTimer.stop()
	TextRevealer.stop()
	TextHider.stop()
	pass
