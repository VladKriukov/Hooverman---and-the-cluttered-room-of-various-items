extends Control

export var inGame: bool = true

var initialItemsOnGorund = []
var itemsOnGroundCount = 0 setget _items_on_ground_update

var time: float

onready var game = $"../../"
onready var time_text = $Time
onready var leftToCOllect = $LeftToCollect

func _ready() -> void:
	time = game.time
	initialItemsOnGorund = get_tree().get_nodes_in_group("IsOnFloor")
	self._items_on_ground_update(initialItemsOnGorund.size())

func _process(delta: float) -> void:
	if game.inGame:
		time -= delta
		_format_text()
		if time <= 0:
			print("Player loses :(")
			game._game_finished()
			time = 0
			_format_text()

func _items_on_ground_update(value):
	itemsOnGroundCount = value
	leftToCOllect.text = ("Left to collect: " + str(itemsOnGroundCount))
	if itemsOnGroundCount == 0 and time > 0:
		print("Player collected everything... Checking")
		game._player_finished()

func _get_items_on_ground():
	return itemsOnGroundCount

func _format_text():
	var minutes : String = str(int(time / 60.0))
	var seconds : String = str(int(fmod(time, 60)))
	var step_ms = stepify(fmod(time, 1000), 0.01)
	var i_ms : int = (step_ms - floor(step_ms)) * 100
	var milliseconds : String = str(i_ms)
	time_text.text = "Time: %s:%s.%s" % [minutes, seconds, milliseconds]
