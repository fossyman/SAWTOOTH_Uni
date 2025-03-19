extends Node

@export var MapContainer:Node3D
@export var MapTransformer:Node3D
@export var MapFiles:Array[PackedScene]
@export var ChallengeMapFiles:Array[PackedScene]
@export var IntroStairs:PackedScene
@export var OutroStairs:PackedScene
@export var NavRegion:NavigationRegion3D

var IntroTransitioner:Node3D
var SpawnPoint:Node3D

@export var EnemyScenes:Array[PackedScene]

@export var EnemyContainer:Node3D

var Directions:Array[Vector3] = [Vector3.FORWARD,Vector3.LEFT,Vector3.BACK,Vector3.RIGHT]

enum FLOORSTYLES{NORMAL=0,CHALLENGE=1}

# Called when the node enters the scene tree for the first time.
func _ready():
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("ui_accept"):
		GenerateMap(FLOORSTYLES.NORMAL,3,5)
		HUDManager.instance.FadeIn(1)
	pass


func GenerateMap(Floortype:FLOORSTYLES = FLOORSTYLES.NORMAL, MinimumRoomCount:int = 3,Maximum:int = 5):
	
	for i in MapContainer.get_children().size():
				MapContainer.get_child(i).queue_free()
				
	for i in EnemyContainer.get_children().size():
		EnemyContainer.get_child(i).queue_free()
				
	match Floortype:
		FLOORSTYLES.NORMAL:
			var MapInstance:PackedScene = MapFiles.pick_random() as PackedScene
			var RoomCount:int = 0
			var chance:int = 1

			
			var SpawnedMap = MapInstance.instantiate()
			MapContainer.add_child(SpawnedMap)
			var ValidRooms:Array[Node3D]
			
			for i in SpawnedMap.get_child_count():
				if SpawnedMap.get_child(i).is_in_group("room"):
					ValidRooms.append(SpawnedMap.get_child(i))
					
			print("VALID ROOMS: " + str(ValidRooms.size()))
			for i in ValidRooms.size():
				if RoomCount >= Maximum:
					print("STOPPING HERE")
					break
				else:
					randomize()
					chance = randi_range(0,100)
					print("CHANCE: " + str(chance) + " FOR ROOM: " + str(i))
					if chance < 50:
						print("REMOVING " + str(i))
						ValidRooms[i].get_child(0).reparent(MapContainer)
						ValidRooms[i].queue_free()
						ValidRooms.remove_at(i)
					RoomCount+=1
			for i in ValidRooms.size():
				print("REMOVING WALL")
				ValidRooms[i].get_child(0).queue_free()
			
			for i in ValidRooms.size():
				var Spawners = ValidRooms[i].find_child("SPAWNERS")
				if is_instance_valid(Spawners):
					for x in Spawners.get_child_count():
						var RandomEnemy = randi_range(0,EnemyScenes.size()-1)
						var Enemy = EnemyScenes[RandomEnemy].instantiate()
						EnemyContainer.add_child(Enemy)
						Enemy.global_transform = Spawners.get_child(x).global_transform
				pass
			
			for i in SpawnedMap.find_child("TRANSITIONERS",true,false).get_child_count():
				match i:
					0:
						var Transitioner:Node3D = IntroStairs.instantiate()
						MapContainer.add_child(Transitioner)
						Transitioner.transform = SpawnedMap.find_child("TRANSITIONERS",true,false).get_child(i).transform
						IntroTransitioner = Transitioner
						SpawnPoint = IntroTransitioner.get_node('%SPAWNPOINT')
						pass
					_:
						var Transitioner:Node3D = OutroStairs.instantiate()
						MapContainer.add_child(Transitioner)
						Transitioner.transform = SpawnedMap.find_child("TRANSITIONERS",true,false).get_child(i).transform
						pass
				
			pass
			
			
			
			var PossibleRotations = [0,90,180,270]
			MapTransformer.rotation_degrees.y = PossibleRotations.pick_random()
			
			NavRegion.bake_navigation_mesh()
			
		FLOORSTYLES.CHALLENGE:
			print("HELOOOOOOOOOOO")
			var MapInstance:PackedScene = ChallengeMapFiles.pick_random() as PackedScene
			var SpawnedMap = MapInstance.instantiate()
			MapContainer.add_child(SpawnedMap)
			
			for i in SpawnedMap.find_child("TRANSITIONERS",true,false).get_child_count():
				match i:
					0:
						var Transitioner:Node3D = IntroStairs.instantiate()
						MapContainer.add_child(Transitioner)
						Transitioner.transform = SpawnedMap.find_child("TRANSITIONERS",true,false).get_child(i).transform
						pass
					_:
						var Transitioner:Node3D = OutroStairs.instantiate()
						MapContainer.add_child(Transitioner)
						Transitioner.transform = SpawnedMap.find_child("TRANSITIONERS",true,false).get_child(i).transform
						pass
				
			pass
			
			pass
		_:
			print("HELOOOOOOOOOOO")
			
	Globals.Player.global_position = SpawnPoint.global_position
	
	
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
