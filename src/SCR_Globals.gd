extends Node

var MainNode:Node
var RootContainer:Node
var CurrentRoot:Node
var CurrentRootidx:int = 0
var GameplayRoot:PackedScene
var MainMenuRoot:PackedScene
var MusicPlayer:MusicManager
var SFXPlayer:SFXManager
var AudioBus:AudioBusLayout

var MainCamera:Camera3D

var Player:PlayerManager
var Inventory:InventoryManager

var OutlineMat:ShaderMaterial

var delta:float

enum PLAYEDHARDWARE{mobile,desktop,console}
var CurrentHardware:PLAYEDHARDWARE = PLAYEDHARDWARE.desktop

var RARITY_COMMON_COLOR:Color = Color.WHITE
var RARITY_UNCOMMON_COLOR:Color = Color.GREEN
var RARITY_RARE_COLOR:Color = Color.BLUE
var RARITY_EPIC_COLOR:Color = Color.PURPLE
var RARITY_LEGENDARY_COLOR:Color = Color.ORANGE

var RARITY_COMMON_MAXPERCENT:int = 50
var RARITY_UNCOMMON_MAXPERCENT:int = 70
var RARITY_RARE_MAXPERCENT:int = 80
var RARITY_EPIC_MAXPERCENT:int = 90
var RARITY_LEGENDARY_MAXPERCENT:int = 95

# Called when the node enters the scene tree for the first time.
func _ready():
	process_mode = Node.PROCESS_MODE_ALWAYS
	GameplayRoot = ResourceLoader.load("res://scenes/ROOT_gameplay.tscn")
	MainMenuRoot = ResourceLoader.load("res://scenes/ROOT_MainMenu.tscn")
	SetNodes()
	pass # Replace with function body.
	
func SetNodes():
	MainNode = get_tree().root.find_child("main",true,false)
	RootContainer = MainNode.get_child(0)
	CurrentRoot = RootContainer.get_child(0)
	MainCamera = CurrentRoot.get_node("%MainCamera") as Camera3D
	if CurrentRootidx == 1:
		Player = CurrentRoot.get_node("%Player") as PlayerManager
		Inventory = CurrentRoot.get_node("%Inventory") as InventoryManager
	OutlineMat = ResourceLoader.load("res://assets/Materials/MAT_Outline.tres")
	MusicPlayer = MainNode.get_node("%MUSICPLAYER") as MusicManager
	AudioBus = ResourceLoader.load("res://default_bus_layout.tres")
	SFXPlayer = MainNode.get_node("%SFXMANAGER") as SFXManager
func _process(_delta):
	delta = _delta
	
func ChangeRoot(_NewRoot:PackedScene):
	get_tree().paused = true
	CurrentRootidx = 1
	CurrentRoot.queue_free()
	var NewRoot = _NewRoot.instantiate()
	RootContainer.add_child(NewRoot)
	CurrentRoot = NewRoot
	Player = CurrentRoot.get_node("%Player") as PlayerManager
	Inventory = CurrentRoot.get_node("%Inventory") as InventoryManager
	await get_tree().create_timer(0.1,true).timeout
	SetNodes()
	get_tree().paused = false
	pass


func CalculateRarity(value:int) -> int:
	if value <= RARITY_COMMON_MAXPERCENT:
		return 0
	elif value > RARITY_COMMON_MAXPERCENT && value <= RARITY_UNCOMMON_MAXPERCENT:
		return 1
	elif value > RARITY_UNCOMMON_MAXPERCENT && value <= RARITY_RARE_MAXPERCENT:
		return 2
	elif value > RARITY_RARE_MAXPERCENT && value <= RARITY_EPIC_MAXPERCENT:
		return 3
	elif value > RARITY_EPIC_MAXPERCENT:
		return 4
	else:
		print("error calculating rarity")
		return 0
	pass


func GetRarityColour(value:int) -> Color:
	match value:
		0:
			return RARITY_COMMON_COLOR
			print("RETURNING COMMON")
		1:
			return RARITY_UNCOMMON_COLOR
			print("RETURNING UNCOMMON")
		2:
			return RARITY_RARE_COLOR
			print("RETURNING RARE")
		3:
			return RARITY_EPIC_COLOR
			print("RETURNING EPIC")
		4:
			return RARITY_LEGENDARY_COLOR
			print("RETURNING LEGENDARY")
		_:
			return RARITY_COMMON_COLOR
			print("RETURNING COMMON")
	pass
