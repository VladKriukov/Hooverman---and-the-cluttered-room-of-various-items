extends Area

onready var remote_transform = $"../"
onready var book_shelf = $"../../../"

var _body

#func _process(delta: float) -> void:
#	if occupied:
#		self.monitoring = false
#	else:
#		self.monitoring = true

func _on_Area_body_entered(body: RigidBody) -> void:
	if body and body.is_in_group(book_shelf.collectingGroup) and _body == null:# and !occupied:
		#occupied = true
		body.mode = RigidBody.MODE_STATIC
		remote_transform.remote_path = body.get_path()
		book_shelf._on_CollectionArea_body_entered(body)
		_body = body
		if body.is_in_group("Collectable"):
			body.remove_from_group("Collectable")
		print(remote_transform.name + " has the book: " + body.name)

func _on_Area_body_exited(body: RigidBody) -> void:
	if body and _body == body:
#		remote_transform.remote_path = ""
#		body.mode = RigidBody.MODE_RIGID
#		book_shelf._on_CollectionArea_body_exited(body)
#		print(remote_transform.name + " has lost the book")
#		#occupied = false
		_body = null
