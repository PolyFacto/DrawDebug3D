class_name PrimitiveBoxLineData extends PrimitiveData

var from: Vector3
var to: Vector3
var thickness: float
var fill: bool

func _init(from: Vector3 = Vector3.ZERO, to: Vector3 = Vector3.UP, thickness: float = 0.05, fill: bool = false, color: Color = Color.RED, lifetime: float = 3.0) -> void:
	super._init(color, lifetime)
	
	self.from = from
	self.to = to
	self.thickness = thickness
	self.fill = fill
