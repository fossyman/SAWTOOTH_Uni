extends Node3D

@export var WarningLights:Array[WarningLight]
@export var OtherLights:Array[Light3D]

@export var BlastDoors:Array[BlastDoorManager]
@export var TVs:Array[TVManager]
@export var EnemySpawnTimer:Timer
@export var EnemyScene:PackedScene
@export var EnemyContainer:Node3D
@export var EnemySpawners:Array[Node3D]
var LightTween:Tween
@export var Song:AudioStream
@export var SongLoop:AudioStream
@export var ExitSong:AudioStream
@export var ExitSongLoop:AudioStream
@export var ChallengeActivator:Area3D

# Called when the node enters the scene tree for the first time.
func _ready():
	DeactivateLights()
	EnemySpawnTimer.timeout.connect(SpawnEnemy)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func ActivateChallenge():
	ChallengeActivator.queue_free()
	for i in BlastDoors.size():
		BlastDoors[i].CloseDoor()
	for i in TVs.size():
		TVs[i].Screen.DisplayIntroMessage()
		(Globals.MusicPlayer as MusicManager).ChangeSong(Song,SongLoop)
	await get_tree().create_timer(1).timeout
	ActivateLights()
	EnemySpawnTimer.start()
	
	await get_tree().create_timer(60).timeout
	FinishChallenge()
	pass
	
func FinishChallenge():
	DeactivateLights()
	for i in TVs.size():
		TVs[i].Screen.DisplayOutroMessage()
	for i in BlastDoors.size():
		BlastDoors[i].OpenDoor()
	(Globals.MusicPlayer as MusicManager).ChangeSong(ExitSong,ExitSongLoop)
	EnemySpawnTimer.stop()
	pass
	
func ActivateLights():
	for i in WarningLights.size():
		WarningLights[i].SetActive(true)
	for i in OtherLights.size():
		OtherLights[i].visible = true
	if LightTween:
		LightTween.kill()
	LightTween = get_tree().create_tween()
	LightTween.tween_property((Globals.CurrentRoot.get_child(0) as MapManager).DirectionalLight,"light_energy",0,0.5)
	
	pass
	
func DeactivateLights():
	for i in WarningLights.size():
		WarningLights[i].SetActive(false)
	for i in OtherLights.size():
		OtherLights[i].visible = false
	for i in BlastDoors.size():
		BlastDoors[i].OpenDoor()
	if LightTween:
		LightTween.kill()
	LightTween = get_tree().create_tween()
	LightTween.tween_property((Globals.CurrentRoot.get_child(0) as MapManager).DirectionalLight,"light_energy",1,0.5)
	pass


func RoomStartTriggerEntered(body):
	if body == Globals.Player:
		ActivateChallenge()
	pass # Replace with function body.
	
func SpawnEnemy():
	var Spawner = EnemySpawners.pick_random()
	var Enemy = EnemyScene.instantiate() as BaseEnemy
	EnemyContainer.add_child(Enemy)
	Enemy.global_transform = Spawner.global_transform
	Enemy.CurrentState = Enemy.TARGETSTATES.CHASING
