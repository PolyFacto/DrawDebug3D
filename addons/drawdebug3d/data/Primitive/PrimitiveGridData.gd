class_name PrimitiveGridData extends PrimitiveData

var origin: Vector3
var rotation: Vector3
var width: int
var height: int
var cell_size: float

func _init(origin: Vector3 = Vector3.ZERO, rotation: Vector3 = Vector3.ZERO, width: int = 2, height: int = 2, cell_size: float = 1.0, color: Color = Color.RED, lifetime: float = 3.0) -> void:
	super._init(color, lifetime)
	
	self.origin = origin
	self.rotation = rotation
	self.width = width
	self.height = height
	self.cell_size = cell_size
