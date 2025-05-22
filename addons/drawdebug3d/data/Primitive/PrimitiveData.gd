class_name PrimitiveData extends RefCounted

var color: Color
var lifetime: float

func _init(color: Color = Color.RED, lifetime: float = 3.0) -> void:
	self.color = color
	self.lifetime = lifetime
