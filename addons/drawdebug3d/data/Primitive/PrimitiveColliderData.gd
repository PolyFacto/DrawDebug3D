class_name PrimitiveColliderData extends PrimitiveData

var collision_shape: CollisionShape3D
var position: Vector3
var rotation: Vector3
var fill: bool

func _init(collision_shape: CollisionShape3D = null, position: Vector3 = Vector3.ZERO, rotation: Vector3 = Vector3.ZERO, fill: bool = false, color: Color = Color.RED, lifetime: float = 3.0) -> void:
	super._init(color, lifetime)
	
	self.collision_shape = collision_shape
	self.position = position
	self.rotation = rotation
	self.fill = fill
