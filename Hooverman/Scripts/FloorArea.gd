extends Area

onready var gamePlay = $"../../GamePlay"

func _on_FloorArea_body_entered(body: Node) -> void:
	if !body.is_in_group("Collectable"):
		body.add_to_group("IsOnFloor")
		gamePlay._items_on_ground_update(get_tree().get_nodes_in_group("IsOnFloor").size())
