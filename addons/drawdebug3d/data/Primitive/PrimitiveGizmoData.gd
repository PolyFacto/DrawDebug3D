class_name PrimitiveGizmoData extends PrimitiveData

var position: Vector3
var rotation: Vector3
var length: Vector3

func _init(position: Vector3 = Vector3.ZERO, rotation: Vector3 = Vector3.ZERO, length: Vector3 = Vector3.ONE, lifetime: float = 3.0) -> void:
	super._init(Color.TRANSPARENT, lifetime)
	
	self.position = position
	self.rotation = rotation
	self.length = length
