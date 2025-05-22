class_name PrimitiveCircleData extends PrimitiveData

var position: Vector3
var rotation: Vector3
var radius: float
var segments: int

func _init(position: Vector3 = Vector3.ZERO, rotation: Vector3 = Vector3.ZERO, segments: int = 16, radius: float = 0.5, color: Color = Color.RED, lifetime: float = 3.0) -> void:
	super._init(color, lifetime)
	
	self.position = position
	self.rotation = rotation
	self.radius = radius
	self.segments = segments
