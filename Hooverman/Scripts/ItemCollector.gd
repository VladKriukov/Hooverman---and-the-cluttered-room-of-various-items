extends MeshInstance

export var collectingGroup: String
onready var collector
onready var gamePlay = get_node("../../UI/GamePlay")
onready var sound_player = $"AudioStreamPlayer3D"

func _on_CollectionArea_body_entered(body: Node) -> void:
	if body and body.is_in_group(collectingGroup):
		body.add_to_group("Collected")
		if body.is_in_group("IsOnFloor"):
			body.remove_from_group("IsOnFloor")
		gamePlay._items_on_ground_update(get_tree().get_nodes_in_group("IsOnFloor").size())
		sound_player.play()

func _on_CollectionArea_body_exited(body: Node) -> void:
	if body and body.is_in_group(collectingGroup):
		if body.is_in_group("Collected"):
			body.remove_from_group("Collected")
		body.add_to_group("IsOnFloor")
		gamePlay._items_on_ground_update(get_tree().get_nodes_in_group("IsOnFloor").size())
