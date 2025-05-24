@tool
extends EditorPlugin

const AUTOLOAD_NAME: String = "DrawDebug3D"

func _enter_tree() -> void:
	if not ProjectSettings.has_setting("addons/DrawDebug/buffer_size"):
		ProjectSettings.set_setting("addons/DrawDebug/buffer_size", 128)
		ProjectSettings.set_initial_value("addons/DrawDebug/buffer_size", 128)
		
		ProjectSettings.add_property_info({
			"name": "addons/DrawDebug/buffer_size",
			"type": TYPE_INT,
			"hint": PROPERTY_HINT_RANGE,
			"hint_string": "128,2048,1",
		})
	
	if not ProjectSettings.has_setting("addons/DrawDebug/instance_visibility_range"):
		ProjectSettings.set_setting("addons/DrawDebug/instance_visibility_range", 0.0)
		ProjectSettings.set_initial_value("addons/DrawDebug/instance_visibility_range", 0.0)
		
		ProjectSettings.add_property_info({
			"name": "addons/DrawDebug/instance_visibility_range",
			"type": TYPE_FLOAT,
			"hint": PROPERTY_HINT_RANGE,
			"hint_string": "0.0,2048.0,1.0",
		})
		
	_save_config()
	print("test")

func _enable_plugin():
	add_autoload_singleton(AUTOLOAD_NAME, "res://addons/drawdebug3d/script/DrawDebug3D.gd")

func _disable_plugin():
	_save_config()
	
	remove_autoload_singleton(AUTOLOAD_NAME)

func _save_config() -> void:
	ProjectSettings.save()
