class_name PrimitiveArrowData extends PrimitiveData

var position: Vector3
var direction: Vector3
var scale: float
var length: float

func _init(position: Vector3 = Vector3.ZERO, direction: Vector3 = Vector3.BACK, scale: float = 1.0, length: float = 1.0, color: Color = Color.RED, lifetime: float = 3.0) -> void:
	super._init(color, lifetime)
	
	self.position = position
	self.direction = direction
	self.scale = scale
	self.length = length
