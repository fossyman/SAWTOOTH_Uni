extends Node

@export var MapContainer:Node3D
@export var Openers: Array[PackedScene]
@export var Closers: Array[PackedScene]
@export var Rooms: Array[PackedScene]
# Called when the node enters the scene tree for the first time.
func _ready():
	GenerateMap(5)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func GenerateMap(RoomCount:int,IncludeBossArea:bool = false):
	var CurrentPos = MapContainer.global_position
	for i in RoomCount:
		match i:
			0:
				var rng = randi_range(0,Openers.size()-1)
				var Spawned = Openers[rng].instantiate()
				MapContainer.add_child(Spawned)
				Spawned.global_position = MapContainer.position
				pass
			RoomCount:
				var rng = randi_range(0,Openers.size()-1)
				var Spawned = Closers[rng].instantiate()
				MapContainer.add_child(Spawned)
				Spawned.global_position = MapContainer.position
				pass
			_:
				var rng:RandomNumberGenerator = RandomNumberGenerator.new()
				var Val = rng.randi_range(0,3)
				match Val:
					0:
						CurrentPos += Vector3.FORWARD
					1:
						CurrentPos += Vector3.LEFT
					2:
						CurrentPos += Vector3.DOWN
					3:
						CurrentPos += Vector3.RIGHT
						
				var Spawned = Rooms[rng.randi_range(0,Rooms.size()-1)].instantiate()
				MapContainer.add_child(Spawned)
				Spawned.global_position = CurrentPos
				pass
	pass
