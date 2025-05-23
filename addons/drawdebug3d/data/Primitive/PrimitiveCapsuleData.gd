class_name PrimitiveCapsuleData extends PrimitiveData

var position: Vector3
var rotation: Vector3
var radius: float
var height: float
var segments: int
var rings: int

func _init(position: Vector3 = Vector3.ZERO, rotation: Vector3 = Vector3.BACK, radius: float = 1.0, height: float = 1.0, segments: int = 16, rings: int = 8, color: Color = Color.RED, lifetime: float = 3.0) -> void:
	super._init(color, lifetime)
	
	self.position = position
	self.rotation = rotation
	self.radius = radius
	self.height = height
	self.segments = segments
	self.rings = rings
