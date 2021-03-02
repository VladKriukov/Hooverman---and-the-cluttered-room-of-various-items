extends Spatial

export var inGame: bool
export var time: float
var gameOver: bool
var timer
onready var game_ui = $UI

onready var win_sound = $WinSound
onready var lose_sound = $LoseSound

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("ui_accept"):
		if gameOver == true:
			restart_game()
		else:
			_start_game()
	if Input.is_action_just_pressed("ui_cancel"):
		get_tree().quit()

func _start_game():
	inGame = true
	game_ui._start_game()
	#Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)

func _game_finished():
	inGame = false
	gameOver = true
	game_ui._game_lost()
	lose_sound.play()
	mini_timer("restart_game", 4)
	#Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func _player_finished():
	mini_timer("_check_win", 2)

func mini_timer(timeout_event, time):
	inGame = false
	timer = Timer.new()
	add_child(timer)
	timer.wait_time = time
	timer.start()
	timer.connect("timeout", self, timeout_event)

func _check_win():
	if timer != null:
		timer.queue_free()
	if get_tree().get_nodes_in_group("IsOnFloor").size() == 0:
		gameOver = true
		print("WIN!!!!!!!!!!!!!!!!!!!!!!!!!!!!")
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		game_ui._game_won()
		win_sound.play()
		mini_timer("restart_game", 4)
	else:
		print("Not quite :( got a little work to do")
		inGame = true

func restart_game():
	get_tree().reload_current_scene()
