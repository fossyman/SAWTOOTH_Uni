extends Node
class_name InventoryManager
@export var ItemDatabase:DatabaseResource

var CurrentWeapon:WeaponResource

var CurrentItems:Array[ItemResource]

# Called when the node enters the scene tree for the first time.
func _ready():
	CurrentWeapon = ItemDatabase.Content[0]
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
