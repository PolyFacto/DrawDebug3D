class_name PrimitiveLinesData extends PrimitiveData

var positions: Array[Vector3]

func _init(positions: Array[Vector3] = [], color: Color = Color.RED, lifetime: float = 3.0) -> void:
	super._init(color, lifetime)
	
	self.positions = positions
