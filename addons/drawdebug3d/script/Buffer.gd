class_name Buffer extends Node

var _size: int
var _buffer: Array[BufferData]
var _available_instance_uid: Array[int]

func _init(_name: String, size: int) -> void:
	self._size = size
	
	name = _name
	_buffer.resize(self._size)

func get_instance() -> BufferData:
	var _buffer_instance: BufferData = null
	
	if _available_instance_uid.is_empty():
		return _buffer_instance
	
	var uid: int = _available_instance_uid.back()
	
	if _buffer[uid].available:
		_buffer[uid].available = false
		_buffer_instance = _buffer[uid]
	
	_available_instance_uid.pop_back()
	return _buffer_instance

func add_instance(uid: int, object: Node) -> void:
	var _instance: BufferData = BufferData.new(uid, object, true)
	
	_buffer[uid] = _instance
	_available_instance_uid.append(uid)
	add_child(_instance.object)

func set_instance_available(uid: int) -> void:
	_buffer[uid].available = true
	_available_instance_uid.append(uid)

func get_buffer_size() -> int:
	return _buffer.size()
