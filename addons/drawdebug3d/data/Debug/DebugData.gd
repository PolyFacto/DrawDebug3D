class_name DebugData

var uid: int
var mesh_instance: MeshInstance3D
var end_time: float

func _init(uid: int, mesh_instance: MeshInstance3D, lifetime: float) -> void:
	self.uid = uid
	self.mesh_instance = mesh_instance
	self.end_time = Time.get_ticks_msec() / 1000.0 + lifetime
