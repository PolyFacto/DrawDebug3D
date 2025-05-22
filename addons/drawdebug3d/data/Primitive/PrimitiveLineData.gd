class_name PrimitiveLineData extends PrimitiveData

var from: Vector3
var to: Vector3

func _init(from: Vector3 = Vector3.ZERO, to: Vector3 = Vector3.UP, color: Color = Color.RED, lifetime: float = 3.0) -> void:
	super._init(color, lifetime)
	
	self.from = from
	self.to = to
