extends Node3D


@export var ItemDrop:ItemResource
var ItemRarity:int = 1
@export var ChestMesh:MeshInstance3D
@export var ChestBeam:Sprite3D
@export var AnimPlayer:AnimationPlayer
@export var ChestMat:Material
@export var ItemEjectPoint:PathFollow3D
var IsOpen = false
# Called when the node enters the scene tree for the first time.
func _ready():
	DecideRarity()
	AnimPlayer.play("idle")
	pass # Replace with function body.



func Open():
	if !IsOpen:
		IsOpen = true
		AnimPlayer.play("Open")
		ChestBeam.visible = false
		print("OPENING")
		ItemEjectPoint.progress_ratio = 0.0
		for i in ItemEjectPoint.get_child(0).get_child_count():
			ItemEjectPoint.get_child(0).get_child(i).queue_free()
		var ItemMesh = ItemDrop.ItemRepresentation.instantiate()
		ItemEjectPoint.get_child(0).add_child(ItemMesh)
		var outline = Globals.OutlineMat.duplicate(true)
		var mat = (ItemMesh.get_child(0).get_child(0) as MeshInstance3D).get_active_material(0).duplicate(true)
		mat.next_pass = outline
		(ItemMesh.get_child(0).get_child(0) as MeshInstance3D).material_override = mat
		outline.set("shader_parameter/outline_color", Globals.GetRarityColour(ItemRarity) )
		ItemMesh.InteractComponent.CanInteract = false
		var T = get_tree().create_tween().set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_OUT_IN)
		T.tween_property(ItemEjectPoint,"progress_ratio",1.0,0.3)
		await T.finished
		ItemMesh.InteractComponent.CanInteract = true

func DecideRarity():
	var Rarity = randi_range(0,100)
	var Decision = Globals.CalculateRarity(Rarity)
	ItemRarity = Decision
	await get_tree().create_timer(1).timeout
	AdjustMaterial()
	
func AdjustMaterial():
	var UVValue = Vector3.ZERO
	print("CHOOSING " + str(ItemRarity))
	var newmat = ChestMat.duplicate()
	match ItemRarity:
		0:
			UVValue.y = -0.3
			ChestBeam.modulate = Globals.RARITY_COMMON_COLOR
		1:
			UVValue.y = -0.15
			ChestBeam.modulate = Globals.RARITY_UNCOMMON_COLOR
		2:
			UVValue.y = 0
			ChestBeam.modulate = Globals.RARITY_RARE_COLOR
		3:
			UVValue.y = 0.2
			ChestBeam.modulate = Globals.RARITY_EPIC_COLOR
		4:
			UVValue.y = 0.4
			ChestBeam.modulate = Globals.RARITY_LEGENDARY_COLOR
	ChestMesh.material_override = newmat
	ChestMesh.material_override["uv1_offset"] = UVValue
