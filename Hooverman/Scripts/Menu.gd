extends Control

export var game_lose_text: String
export var game_win_text: String

onready var menu = $Menu
onready var game_play = $GamePlay
onready var game = $"../"
onready var game_over = $GameOver
onready var game_over_text = $GameOver/EndText

func _on_TextureButton_pressed() -> void:
	game._start_game()
	
func _start_game():
	menu.visible = false
	game_play.visible = true

func _game_over():
	game_over.visible = true
	game_play.visible = false

func _game_lost():
	_game_over()
	game_over_text.text = game_lose_text

func _game_won():
	_game_over()
	game_over_text.text = game_win_text
