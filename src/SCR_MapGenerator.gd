extends Node

@export var MapContainer:Node3D
@export var Openers: Array[PackedScene]
@export var Closers: Array[PackedScene]
@export var Hallways: Array[PackedScene]
@export var Corners:Array[PackedScene]
@export var Connectors:Array[PackedScene]
var Directions:Array[Vector3] = [Vector3.FORWARD,Vector3.LEFT,Vector3.BACK,Vector3.RIGHT]
# Called when the node enters the scene tree for the first time.
func _ready():
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("ui_accept"):
		GenerateMap(100,5,100)
	pass


func GenerateMap(HallwayCount:int,RoomCount:int,MaxDistanceFromCenter:int,IncludeBossArea:bool = false):
	var CurrentConnector:Node3D
	var NextChunkIndex = 0
	for i in MapContainer.get_child_count():
		MapContainer.get_child(i).queue_free()
	for i in HallwayCount:
		var SelectedChunk:PackedScene
		match NextChunkIndex:
			0:
				SelectedChunk = Hallways.pick_random()
				NextChunkIndex = 1
				pass
			1:
				SelectedChunk = Connectors.pick_random()
				NextChunkIndex = 0
				pass
		if is_instance_valid(CurrentConnector):
			var instance = SelectedChunk.instantiate() as COMP_MapChunk
			
			
			print( "SPAWNING: " + instance.name + " AT " + CurrentConnector.name + CurrentConnector.owner.name)
			
			MapContainer.add_child(instance)
			instance.global_transform = CurrentConnector.global_transform
			instance.Back.queue_free()
			CurrentConnector = find_children_in_group(instance,"Connector").pick_random()
			while CurrentConnector == instance.Back:
				CurrentConnector = find_children_in_group(instance,"Connector").pick_random()
			pass
		else:
			print("No Connectors")
			var instance = SelectedChunk.instantiate()
			var Connectors:Array[Node3D]
			var Selected:Node3D
			MapContainer.add_child(instance,true)
			print("SPAWNING ROOT " + instance.name)
			CurrentConnector = find_children_in_group(instance,"Connector").pick_random()
		await get_tree().create_timer(0.01).timeout
	pass
	
	
	
# FOUND HERE https://forum.godotengine.org/t/is-there-a-way-to-get-any-offspring-that-belongs-in-a-certain-group-directly/14265/4
static func find_children_in_group(parent: Node, group: String, recursive: bool = false):
	var output: Array[Node] = []
	for child in parent.get_children() :
		if child.is_in_group(group) :
			output.append(child)
	if recursive :
		for child in parent.get_children() :
			var recursive_output =  find_children_in_group(child, group, recursive)
			for recursive_child in recursive_output :
				output.append(recursive_child)
	return output
