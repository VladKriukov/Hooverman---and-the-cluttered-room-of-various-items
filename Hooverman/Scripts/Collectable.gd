extends RigidBody

export var scale_size: float = 0.5
var followSpeed = 5
var t = 0
onready var collision_shape = $CollisionShape

func move_towards(delta, vacuumNozzle: Transform):
	$".".global_transform = get_global_transform().interpolate_with(vacuumNozzle, delta * followSpeed)

func remove_collision():
	collision_shape.disabled = true

func reset_collision():
	collision_shape.disabled = false

func _physics_process(delta: float) -> void:
	if global_transform.origin.y < -10:
		global_transform.origin.y = 3
