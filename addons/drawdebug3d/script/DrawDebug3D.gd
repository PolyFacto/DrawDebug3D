extends Node
## DrawDebug3D is a global singleton used to visualize 3D primitives in world space, only available in debug build.
## It is primarily used for visual debugging of gameplay logic.

var _debugs: Array[DebugData]
var _buffer: Buffer
var _debug_mode: bool

func _ready() -> void:
	_debug_mode = OS.is_debug_build()
	_init_process()
	_init_buffer()

func _init_process() -> void:
	if not _debug_mode:
		set_process(false)
		return
	set_process(true)

func _init_buffer() -> void:
	if not _debug_mode:
		return
	
	var buffer_size: int = ProjectSettings.get_setting("addons/DrawDebug/buffer_size")
	_buffer = Buffer.new("DD3D Buffer", buffer_size)
	add_child(_buffer)
	
	var instance_visibility_range: int = ProjectSettings.get_setting("addons/DrawDebug/instance_visibility_range")
	
	for i in range(_buffer.get_buffer_size()):
		var _mesh_instance: MeshInstance3D = MeshInstance3D.new()
		_mesh_instance.gi_mode = GeometryInstance3D.GI_MODE_DISABLED
		_mesh_instance.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF
		_mesh_instance.visibility_range_end = 0.0
		_mesh_instance.process_mode = Node.PROCESS_MODE_DISABLED
		_mesh_instance.visibility_range_end = instance_visibility_range
		_buffer.add_instance(i, _mesh_instance)

func _process(_delta: float) -> void:
	var _current_time: float = Time.get_ticks_msec() / 1000.0
	for debug in _debugs:
		if _current_time >= debug.end_time:
			_buffer.set_instance_available(debug.uid)
	
	_debugs = _debugs.filter(func(debug): return _current_time < debug.end_time)

func _set_mesh(mesh_instance: MeshInstance3D = null, mesh: Mesh = null, position: Vector3 = Vector3.ZERO, rotation: Vector3 = Vector3.ZERO, color: Color = Color.RED) -> MeshInstance3D:
	mesh_instance.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF
	mesh_instance.mesh = mesh
	mesh_instance.material_override = _set_material(color)
	mesh_instance.position = position
	mesh_instance.rotation = rotation
	return mesh_instance

func _set_material(color: Color = Color.TRANSPARENT) -> StandardMaterial3D:
	var _material: StandardMaterial3D = StandardMaterial3D.new()
	_material.vertex_color_use_as_albedo = true
	_material.no_depth_test = true
	_material.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	_material.transparency = BaseMaterial3D.TRANSPARENCY_DISABLED
	_material.cull_mode = BaseMaterial3D.CULL_DISABLED
	
	if color == Color.TRANSPARENT:
		return _material
		
	_material.albedo_color = color
	return _material

func _set_debug_data(uid: int, mesh: MeshInstance3D, lifetime: float) -> void:
	var _debug_data: DebugData = DebugData.new(uid, mesh, lifetime)
	_debugs.append(_debug_data)

func line(data: PrimitiveLineData) -> void:
	if not _debug_mode:
		return
	
	var _buffer_instance: BufferData = _buffer.get_instance()
	if not _buffer_instance: 
		printerr("No buffer instance available")
		return
	
	var _dir: Vector3 = data.to - data.from
	var _length: float = _dir.length()
	if _length == 0.0:
		return
	
	var _im: ImmediateMesh = ImmediateMesh.new()
	_im.surface_begin(Mesh.PRIMITIVE_LINES)
	_im.surface_add_vertex(data.from)
	_im.surface_add_vertex(data.to)
	_im.surface_set_color(data.color)
	_im.surface_end()
	
	var _mesh_instance: MeshInstance3D = _set_mesh(_buffer_instance.object, _im, Vector3.ZERO, Vector3.ZERO, data.color)
	_set_debug_data(_buffer_instance.uid, _mesh_instance, data.lifetime)

func box_line(data: PrimitiveBoxLineData) -> void:
	if not _debug_mode:
		return
		
	var _dir: Vector3 = data.to - data.from
	var _length: float = _dir.length()
	if _length == 0.0:
		return
	
	var _buffer_instance: BufferData = _buffer.get_instance()
	if not _buffer_instance: 
		printerr("No buffer instance available")
		return
	
	var _mid: Vector3 = data.from + _dir * 0.5
	
	var _basis := Basis()
	_basis = _basis.looking_at(_dir.normalized(), Vector3.UP)
	
	if data.fill:
		dot(PrimitiveDotData.new(_mid, _basis.get_euler(), Vector3(data.thickness, data.thickness, _length), data.color, data.lifetime))
	else:
		box(PrimitiveBoxData.new(_mid,_basis.get_euler(), Vector3(data.thickness, data.thickness, _length), data.color, data.lifetime))

func dot(data: PrimitiveDotData) -> void:
	if not _debug_mode:
		return
	
	var _buffer_instance: BufferData = _buffer.get_instance()
	if not _buffer_instance: 
		printerr("No buffer instance available")
		return
	
	var _box_mesh: BoxMesh = BoxMesh.new()
	_box_mesh.size = Vector3.ONE * data.scale
	
	var _mesh_instance: MeshInstance3D = _set_mesh(_buffer_instance.object, _box_mesh, data.position, data.rotation, data.color)
	_set_debug_data(_buffer_instance.uid, _mesh_instance, data.lifetime)

func box(data: PrimitiveBoxData) -> void:
	if not _debug_mode:
		return
	
	var _buffer_instance: BufferData = _buffer.get_instance()
	if not _buffer_instance: 
		printerr("No buffer instance available")
		return
	
	var _b_size: Vector3 = data.scale / 2.0
	var _vertex: Array[Vector3] = [
		Vector3(-_b_size.x, -_b_size.y, -_b_size.z),
		Vector3(+_b_size.x, -_b_size.y, -_b_size.z),
		Vector3(+_b_size.x, -_b_size.y, +_b_size.z),
		Vector3(-_b_size.x, -_b_size.y, +_b_size.z),
		Vector3(-_b_size.x, +_b_size.y, -_b_size.z),
		Vector3(+_b_size.x, +_b_size.y, -_b_size.z),
		Vector3(+_b_size.x, +_b_size.y, +_b_size.z),
		Vector3(-_b_size.x, +_b_size.y, +_b_size.z),
	]

	var _edges: Array[Array] = [
		[0, 1], [1, 2], [2, 3], [3, 0],
		[4, 5], [5, 6], [6, 7], [7, 4],
		[0, 4], [1, 5], [2, 6], [3, 7],
	]
	
	var _im: ImmediateMesh = ImmediateMesh.new()
	_im.surface_begin(Mesh.PRIMITIVE_LINES)
	for e in _edges:
		_im.surface_add_vertex(_vertex[e[0]])
		_im.surface_add_vertex(_vertex[e[1]])
	
	_im.surface_set_color(data.color)
	_im.surface_end()
	
	var _mesh_instance: MeshInstance3D = _set_mesh(_buffer_instance.object, _im, data.position, data.rotation, data.color)
	_set_debug_data(_buffer_instance.uid, _mesh_instance, data.lifetime)

func cylinder(data: PrimitiveCylinderData) -> void:
	if not _debug_mode:
		return
	
	var _buffer_instance: BufferData = _buffer.get_instance()
	if not _buffer_instance: 
		printerr("No buffer instance available")
		return
	
	var _im: ImmediateMesh = ImmediateMesh.new()
	_im.surface_begin(Mesh.PRIMITIVE_LINES)
	
	var half_height: float = data.height * 0.5
	var angle_step: float = TAU / data.segments
	var height_step: float = data.height / (data.rings - 1)
	
	var points := []
	for i in range(data.rings):
		var y: float = -half_height + i * height_step
		var ring: Array[Vector3] = []
		for j in range(data.segments + 1):
			var angle: float = j * angle_step
			var x: float = cos(angle) * data.radius
			var z: float = sin(angle) * data.radius
			ring.append(Vector3(x, y, z))
		points.append(ring)
	
	for ring in points:
		for j in range(data.segments):
			_im.surface_add_vertex(ring[j])
			_im.surface_add_vertex(ring[j + 1])
	
	for j in range(data.segments + 1):
		for i in range(data.rings - 1):
			_im.surface_add_vertex(points[i][j])
			_im.surface_add_vertex(points[i + 1][j])
	
	var top_center: Vector3 = Vector3(0, half_height, 0)
	var bottom_center: Vector3 = Vector3(0, -half_height, 0)
	for j in range(data.segments):
		_im.surface_add_vertex(top_center)
		_im.surface_add_vertex(points[data.rings - 1][j])
		
		_im.surface_add_vertex(bottom_center)
		_im.surface_add_vertex(points[0][j])
	
	_im.surface_set_color(data.color)
	_im.surface_end()
	
	var _mesh_instance: MeshInstance3D = _set_mesh(_buffer_instance.object, _im, data.position, data.rotation, data.color)
	_set_debug_data(_buffer_instance.uid, _mesh_instance, data.lifetime)

func circle(data: PrimitiveCircleData) -> void:
	if not _debug_mode:
		return
	
	var _buffer_instance: BufferData = _buffer.get_instance()
	if not _buffer_instance: 
		printerr("No buffer instance available")
		return
	
	var _angle_step: float = TAU / data.segments
	
	var _im: ImmediateMesh = ImmediateMesh.new()
	_im.surface_begin(Mesh.PRIMITIVE_LINES)

	for i in range(data.segments):
		var a: float = _angle_step * i
		var b: float = _angle_step * (i + 1)
		var p1: Vector3 = Vector3(cos(a), sin(a), 0.0) * data.radius
		var p2: Vector3 = Vector3(cos(b), sin(b), 0.0) * data.radius
		_im.surface_add_vertex(p1)
		_im.surface_add_vertex(p2)
		_im.surface_set_color(data.color)
	
	_im.surface_end()
	
	var _mesh_instance: MeshInstance3D = _set_mesh(_buffer_instance.object, _im, data.position, data.rotation, data.color)
	_set_debug_data(_buffer_instance.uid, _mesh_instance, data.lifetime)

func sphere(data: PrimitiveSphereData) -> void:
	if not _debug_mode:
		return
	
	var _buffer_instance: BufferData = _buffer.get_instance()
	if not _buffer_instance: 
		printerr("No buffer instance available")
		return
	
	var _im: ImmediateMesh = ImmediateMesh.new()
	_im.surface_begin(Mesh.PRIMITIVE_LINES)
	
	var _points := []
	for lat in range(data.rings + 1):
		var theta := PI * lat / data.rings  # 0 -> π
		var sin_theta := sin(theta)
		var cos_theta := cos(theta)
		
		var ring_points := []
		for lon in range(data.segments + 1):
			var phi := TAU * lon / data.segments  # 0 -> 2π
			var sin_phi := sin(phi)
			var cos_phi := cos(phi)
			
			var x := data.scale.x * sin_theta * cos_phi
			var y := data.scale.y * cos_theta
			var z := data.scale.z * sin_theta * sin_phi
			var _point: Vector3 = Vector3(x, y, z)
			ring_points.append(_point)
		_points.append(ring_points)
	
	for lat in range(data.rings + 1):
		for lon in range(data.segments):
			_im.surface_add_vertex(_points[lat][lon])
			_im.surface_add_vertex(_points[lat][lon + 1])
	
	for lat in range(data.rings):
		for lon in range(data.segments + 1):
			_im.surface_add_vertex(_points[lat][lon])
			_im.surface_add_vertex(_points[lat + 1][lon])
			
	_im.surface_set_color(data.color)
	_im.surface_end()
	
	var _mesh_instance: MeshInstance3D = _set_mesh(_buffer_instance.object, _im, data.position, data.rotation, data.color)
	_set_debug_data(_buffer_instance.uid, _mesh_instance, data.lifetime)

func gizmo(data: PrimitiveGizmoData) -> void:
	if not _debug_mode:
		return
	
	var _buffer_instance: BufferData = _buffer.get_instance()
	if not _buffer_instance: 
		printerr("No buffer instance available")
		return
	
	var _im: ImmediateMesh = ImmediateMesh.new()
	_im.surface_begin(Mesh.PRIMITIVE_LINES)
	
	# X
	_im.surface_set_color(Color.RED)
	_im.surface_add_vertex(Vector3.ZERO)
	_im.surface_add_vertex(Vector3.RIGHT * data.length.x)
	
	# Y
	_im.surface_set_color(Color.GREEN)
	_im.surface_add_vertex(Vector3.ZERO)
	_im.surface_add_vertex(Vector3.UP * data.length.y)
	
	# Z
	_im.surface_set_color(Color.BLUE)
	_im.surface_add_vertex(Vector3.ZERO)
	_im.surface_add_vertex(Vector3.BACK * data.length.z)
	
	_im.surface_end()
	
	var _mesh_instance: MeshInstance3D = _set_mesh(_buffer_instance.object, _im, data.position, Vector3.ZERO, data.color)
	_set_debug_data(_buffer_instance.uid, _mesh_instance, data.lifetime)

func arrow(data: PrimitiveArrowData) -> void:
	if not _debug_mode:
		return
	
	var _direction: Vector3 = data.direction.normalized()
	if _direction == Vector3.ZERO:
		return
	
	var _buffer_instance: BufferData = _buffer.get_instance()
	if not _buffer_instance: 
		printerr("No buffer instance available")
		return
	
	var _im: ImmediateMesh = ImmediateMesh.new()
	_im.surface_begin(Mesh.PRIMITIVE_LINES)
	
	var _scale: float = data.scale
	
	var head_length: float = _scale * 0.2
	var shaft_length: float = _scale * (data.length - head_length)
	var head_radius: float = _scale * 0.1
	var segments: int = 8
	
	var start: Vector3 = Vector3.ZERO
	var end: Vector3 = Vector3(0, 0, shaft_length)

	_im.surface_add_vertex(start)
	_im.surface_add_vertex(end)
	
	var tip: Vector3 = Vector3(0, 0, shaft_length + head_length) if data.length > 0 else Vector3(0, 0, shaft_length - head_length)
	var base_center: Vector3 = end
	for i in range(segments):
		var angle_a := i * TAU / segments
		var angle_b := (i + 1) * TAU / segments
		
		var a: Vector3 = Vector3(cos(angle_a) * head_radius, sin(angle_a) * head_radius, shaft_length)
		var b: Vector3 = Vector3(cos(angle_b) * head_radius, sin(angle_b) * head_radius, shaft_length)
		
		_im.surface_add_vertex(a)
		_im.surface_add_vertex(b)
		
		_im.surface_add_vertex(a)
		_im.surface_add_vertex(tip)
		
		_im.surface_add_vertex(base_center)
		_im.surface_add_vertex(a)
	
	_im.surface_set_color(data.color)
	_im.surface_end()
	
	var _basis: Basis = Basis.looking_at(-_direction, Vector3.UP)
	var _transform: Transform3D = Transform3D(_basis, data.position)
	
	var _mesh_instance: MeshInstance3D = _set_mesh(_buffer_instance.object, _im, _transform.origin, _transform.basis.get_euler(), data.color)
	_set_debug_data(_buffer_instance.uid, _mesh_instance, data.lifetime)

func collider(data: PrimitiveColliderData) -> void:
	if not _debug_mode:
		return
	
	if not data.collision_shape:
		return
	
	var _buffer_instance: BufferData = _buffer.get_instance()
	if not _buffer_instance: 
		printerr("No buffer instance available")
		return
	
	data.collision_shape.debug_fill = data.fill
	data.collision_shape.debug_color = data.color
	
	var _mesh_instance: MeshInstance3D = _set_mesh(_buffer_instance.object, data.collision_shape.shape.get_debug_mesh(), data.position, data.rotation, data.color)
	_set_debug_data(_buffer_instance.uid, _mesh_instance, data.lifetime)

func grid(data: PrimitiveGridData) -> void:
	if not _debug_mode:
		return
	
	var _buffer_instance: BufferData = _buffer.get_instance()
	if not _buffer_instance: 
		printerr("No buffer instance available")
		return
	
	var _im: ImmediateMesh = ImmediateMesh.new()
	_im.surface_begin(Mesh.PRIMITIVE_LINES)
	_im.surface_set_color(data.color)
	
	var total_width: float = data.width * data.cell_size
	var total_height: float = data.height * data.cell_size
	
	for x in range(data.width + 1):
		var x_pos: float = data.origin.x + x * data.cell_size
		_im.surface_add_vertex(Vector3(x_pos, data.origin.y, data.origin.z))
		_im.surface_add_vertex(Vector3(x_pos, data.origin.y, data.origin.z + total_height))
	
	for z in range(data.height + 1):
		var z_pos: float = data.origin.z + z * data.cell_size
		_im.surface_add_vertex(Vector3(data.origin.x, data.origin.y, z_pos))
		_im.surface_add_vertex(Vector3(data.origin.x + total_width, data.origin.y, z_pos))
	
	_im.surface_end()
	
	var _mesh_instance: MeshInstance3D = _set_mesh(_buffer_instance.object, _im, data.origin, data.rotation, data.color)
	_mesh_instance.visibility_range_end = 0.0
	_set_debug_data(_buffer_instance.uid, _mesh_instance, data.lifetime)

func cross(data: PrimitiveCrossData) -> void:
	if not _debug_mode:
		return
	
	var _buffer_instance: BufferData = _buffer.get_instance()
	if not _buffer_instance: 
		printerr("No buffer instance available")
		return
	
	var half_size := data.size * 0.5
	
	var vertices := [
		Vector3(-half_size, 0, 0),
		Vector3(half_size, 0, 0),
		Vector3(0, -half_size, 0),
		Vector3(0, half_size, 0),
		Vector3(0, 0, -half_size),
		Vector3(0, 0, half_size)
	]
	
	var _im: ImmediateMesh = ImmediateMesh.new()
	_im.surface_begin(Mesh.PRIMITIVE_LINES)
	
	_im.surface_add_vertex(vertices[0])
	_im.surface_add_vertex(vertices[1])
	
	_im.surface_add_vertex(vertices[2])
	_im.surface_add_vertex(vertices[3])
	
	_im.surface_add_vertex(vertices[4])
	_im.surface_add_vertex(vertices[5])
	
	_im.surface_set_color(data.color)
	_im.surface_end()
	
	var _mesh_instance: MeshInstance3D = _set_mesh(_buffer_instance.object, _im, data.position, data.rotation, data.color)
	_set_debug_data(_buffer_instance.uid, _mesh_instance, data.lifetime)

func text(data: PrimitiveTextData) -> void:
	if not _debug_mode:
		return
	
	var _buffer_instance: BufferData = _buffer.get_instance()
	if not _buffer_instance: 
		printerr("No buffer instance available")
		return
	
	var _text_mesh: TextMesh = TextMesh.new()
	_text_mesh.font_size = data.font_size
	_text_mesh.text = data.text
	_text_mesh.depth = 0.01
	
	var _mesh_instance: MeshInstance3D = _set_mesh(_buffer_instance.object, _text_mesh, data.position, data.rotation, data.color)
	_mesh_instance.material_override.billboard_mode = data.billboard
	_set_debug_data(_buffer_instance.uid, _mesh_instance, data.lifetime)
