extends Spatial

export var min_number_of_balls: int
export var max_number_of_balls: int
export var min_number_of_books: int
export var max_number_of_books: int
export var min_number_of_teddy_bears: int
export var max_number_of_teddy_bears: int
export var mess_extents: Vector3 = Vector3(5, 0, 5)
export var y_offset: float = 1

var ball
var ball_extra
var book
var teddy_bear

var instanced_node

var rng = RandomNumberGenerator.new()
var rnd

func _ready() -> void:
	ball = preload("res://Prefabs/Ball.tscn")#.instance()
	ball_extra = preload("res://Prefabs/BallExtra.tscn")#.instance()
	book = preload("res://Prefabs/Book.tscn")#.instance()
	teddy_bear = preload("res://Prefabs/TeddyBear.tscn")#.instance()
	rng.randomize()
	print("Finished preloading")
	rnd = rng.randi_range(min_number_of_balls, max_number_of_balls)
	for i in range(rnd):
		rnd = rng.randi_range(0, 3)
		if rnd == 0:
			instanced_node = ball.instance()
		else:
			instanced_node = ball_extra.instance()
		_randomise_position()
		add_child(instanced_node)
	
	rnd = rng.randi_range(min_number_of_books, max_number_of_books)
	for i in range(rnd):
		instanced_node = book.instance()
		_randomise_position()
		add_child(instanced_node)
	
	rnd = rng.randi_range(min_number_of_teddy_bears, max_number_of_teddy_bears)
	for i in range(rnd):
		instanced_node = teddy_bear.instance()
		_randomise_position()
		add_child(instanced_node)

func _randomise_position():
	var randomised_position = Vector3(rng.randf_range(-mess_extents.x, mess_extents.x), rng.randf_range(-mess_extents.y, mess_extents.y) + y_offset, rng.randf_range(-mess_extents.z, mess_extents.z))
	instanced_node.global_transform.origin = randomised_position
