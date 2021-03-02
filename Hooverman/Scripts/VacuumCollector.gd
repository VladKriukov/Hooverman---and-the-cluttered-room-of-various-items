extends Area

export var vacuumStrength: float
export var shootStrength: float
export var upwardsModifier: float
var itemsCollecting = []
var storedItems = []
var itemIndex: int = 0
var collectingIndex: int
var itemPosition: Vector3
var direction: Vector3
var distance
onready var vacuumArea = $"../VacuumArea"
onready var storage = $"../Storage2" # $"../../CameraRig/Camera/Storage"
onready var vacuumParticles = $"../VacuumParticles"
var canShoot = true
var timer
onready var game = $"../../../"
var _scale_size: float

onready var collectingSound = $"../Collect"
onready var collectedSound = $"../Collected"
onready var shootSound = $"../Shoot"

func _enter_tree() -> void:
	itemsCollecting.resize(100)
	storedItems.resize(5)

func _physics_process(delta: float) -> void:
	if game.inGame:
		if Input.is_action_pressed("collect"):
			_collect(delta)
			collectingSound.playing = true
			collectingSound.play()
		if Input.is_action_just_released("collect"):
			_let_go()
			collectingSound.playing = false
		if Input.is_action_pressed("shoot") and canShoot == true and storedItems[0] != null:
			_shoot()
			shootSound.play()
	else:
		_let_go()

func _collect(delta):
	vacuumArea.monitoring = true
	vacuumParticles.emitting = true
	for i in itemIndex:
		if storedItems[i]:
			storedItems[i].mode = RigidBody.MODE_STATIC
	for i in collectingIndex:
		if itemsCollecting[i]:
			itemsCollecting[i].move_towards(delta, global_transform)

func _let_go():
	vacuumArea.monitoring = false
	vacuumParticles.emitting = false
	for i in collectingIndex:
		if itemsCollecting[i]:
			itemsCollecting[i].add_central_force(-get_global_transform().basis.z * shootStrength / 2)
	itemsCollecting.clear()
	itemsCollecting.resize(100)
	collectingIndex = 0

func _shoot():
	canShoot = false
	timer = Timer.new()
	add_child(timer)
	timer.wait_time = 0.2
	timer.start()
	timer.connect("timeout", self, "_on_finished_timer")
	storage.get_child(itemIndex - 1).remote_path = ""
	_scale_size = storedItems[itemIndex - 1].scale_size
	storedItems[itemIndex - 1].mode = RigidBody.MODE_RIGID
	storedItems[itemIndex - 1].global_transform.origin = global_transform.origin
	storedItems[itemIndex - 1].global_scale(Vector3(1 / _scale_size, 1 / _scale_size, 1 / _scale_size))
	direction = -get_global_transform().basis.z
	direction.y = upwardsModifier
	storedItems[itemIndex - 1].reset_collision()
	print(direction)
	storedItems[itemIndex - 1].add_central_force(direction * shootStrength)
	storedItems[itemIndex - 1] = null
	itemIndex = itemIndex - 1
	print (itemIndex)

func _on_finished_timer():
	canShoot = true
	timer.queue_free()
	print("timer ended")

func _on_CollectionNozzle_body_entered(body: RigidBody) -> void:
	if Input.is_action_pressed("collect") and body != null and body.is_in_group("Collectable"):
		if itemIndex < storedItems.size():
			storedItems[itemIndex] = body
			_scale_size = storedItems[itemIndex].scale_size
			itemsCollecting[collectingIndex] = null
			body.mode = RigidBody.MODE_STATIC
			storage.get_child(itemIndex).remote_path = storedItems[itemIndex].get_path()
			storedItems[itemIndex].global_scale(Vector3(_scale_size, _scale_size, _scale_size))
			itemIndex = itemIndex + 1
			body.remove_collision()
			collectedSound.play()

func _on_VacuumArea_body_entered(body: Node) -> void:
	if body.has_method("move_towards") and body.is_in_group("Collectable"):
		itemsCollecting[collectingIndex] = body
		collectingIndex = clamp(collectingIndex + 1, 0, 1000)

func _on_VacuumArea_body_exited(body: Node) -> void:
	itemsCollecting[collectingIndex] = null
	collectingIndex = clamp(collectingIndex - 1, 0, 1000)
