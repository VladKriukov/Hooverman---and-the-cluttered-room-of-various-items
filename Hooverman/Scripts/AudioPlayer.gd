extends AudioStreamPlayer3D

onready var collectableParent = $"../"

func _on_Area_body_entered(body: Node) -> void:
	_play_sound()

func _play_sound():
	self.playing = true
	self.play()
	$".".play()
	print("Playing sound")
