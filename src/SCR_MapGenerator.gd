extends Node

@export var MapContainer:Node3D
@export var Openers: Array[PackedScene]
@export var Closers: Array[PackedScene]
@export var Rooms: Array[PackedScene]
@export var HallwayFloors:Array[Node3D]
var Directions:Array[Vector3] = [Vector3.FORWARD,Vector3.LEFT,Vector3.BACK,Vector3.RIGHT]
# Called when the node enters the scene tree for the first time.
func _ready():
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("ui_accept"):
		GenerateMap(20,5,100)
	pass


func GenerateMap(HallwayCount:int,RoomCount:int,MaxDistanceFromCenter:int,IncludeBossArea:bool = false):
	for i in MapContainer.get_child_count():
		MapContainer.get_child(i).queue_free()
	var CurrentPos = MapContainer.global_position
	var TravelCount:int
	var LastHallwayDir:Vector3 = Vector3.ZERO
	var ChosenPositions:Array[Vector3]
	for i in HallwayCount:
		match i:

			_:
				var rng:RandomNumberGenerator = RandomNumberGenerator.new()
				var Val = rng.randi_range(0,3)
				while Directions[Val] == LastHallwayDir ||Directions[Val] == -LastHallwayDir:
					Val = rng.randi_range(0,3)
				if Directions[Val] != LastHallwayDir:
					var Len = randi_range(3,5)
					for x in Len:
						var Pos:Vector3 = CurrentPos + (Directions[Val]) * 3
						print(Pos.distance_to(MapContainer.global_position) )
						if Pos.distance_to(MapContainer.global_position) >= roundi(MaxDistanceFromCenter):
							GenerateMap(HallwayCount,RoomCount,MaxDistanceFromCenter)
						LastHallwayDir = Directions[Val]
						CurrentPos = Pos
						ChosenPositions.append(CurrentPos)
					pass
				pass
	var ye = remove_duplicates(ChosenPositions)
	ChosenPositions.clear()
	ChosenPositions.append_array(ye)
	for i in ye.size():
		var Spawned = Rooms[0].instantiate()
		MapContainer.add_child(Spawned)
		Spawned.global_position = Vector3(roundi(ChosenPositions[i].x),roundi(ChosenPositions[i].y),roundi(ChosenPositions[i].z))
		
func SpawnWalls():
	
	pass
	
func remove_duplicates(vector3_array) -> Array[Vector3]:
	var unique_vectors = {}
	var result:Array[Vector3] = []
	for vector in vector3_array:
		if not unique_vectors.has(vector):
			unique_vectors[vector] = true
			result.append(vector)
	
	return result
