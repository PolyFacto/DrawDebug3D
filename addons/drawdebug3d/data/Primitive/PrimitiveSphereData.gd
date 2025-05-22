class_name PrimitiveSphereData extends PrimitiveData

var position: Vector3
var rotation: Vector3
var scale: Vector3
var segments: int
var rings: int

func _init(position: Vector3 = Vector3.ZERO, rotation: Vector3 = Vector3.ZERO, scale: Vector3 = Vector3.ONE, segments: int = 16, rings: int = 8, color: Color = Color.RED, lifetime: float = 3.0) -> void:
	super._init(color, lifetime)
	
	self.position = position
	self.rotation = rotation
	self.scale = scale
	self.segments = segments
	self.rings = rings
