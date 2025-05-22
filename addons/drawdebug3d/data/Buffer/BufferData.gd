class_name BufferData

var uid: int
var object: Node
var available: bool:
	set(value):
		available = value
		if object:
			object.visible = false if available == true else true

func _init(uid: int, object: Node, available: bool) -> void:
	self.uid = uid
	self.object = object
	self.available = available
