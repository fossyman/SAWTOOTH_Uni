extends Node

var MainNode:Node
var RootContainer:Node
var CurrentRoot:Node

var MainCamera:Camera3D

var Player:PlayerManager
var Inventory:InventoryManager

var delta

# Called when the node enters the scene tree for the first time.
func _ready():
	MainNode = get_tree().root.find_child("main",true,false)
	RootContainer = MainNode.get_child(0)
	CurrentRoot = RootContainer.get_child(0)
	MainCamera = CurrentRoot.get_node("%MainCamera") as Camera3D
	Player = CurrentRoot.get_node("%Player") as PlayerManager
	Inventory = CurrentRoot.get_node("%Inventory") as InventoryManager
	pass # Replace with function body.

func _process(delta):
	delta = delta
