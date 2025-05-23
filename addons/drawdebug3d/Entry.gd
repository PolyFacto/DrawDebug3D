@tool
extends EditorPlugin

const AUTOLOAD_NAME: String = "DrawDebug3D"

func _enable_plugin():
	if not ProjectSettings.has_setting("addons/DrawDebug/buffer_size"):
		ProjectSettings.set("addons/DrawDebug/buffer_size", 128)
		
		ProjectSettings.add_property_info({
			"name": "addons/DrawDebug/buffer_size",
			"type": TYPE_INT,
			"hint": PROPERTY_HINT_RANGE,
			"hint_string": "128, 2048, 64",
			"usage": PROPERTY_USAGE_DEFAULT,
		})
		
		ProjectSettings.save()
	
	if not ProjectSettings.has_setting("addons/DrawDebug/instance_visibility_range"):
		ProjectSettings.set("addons/DrawDebug/instance_visibility_range", 0.0)
		
		ProjectSettings.add_property_info({
			"name": "addons/DrawDebug/instance_visibility_range",
			"type": TYPE_FLOAT,
			"hint": PROPERTY_HINT_RANGE,
			"hint_string": "0.0, 2048.0, 1.0",
			"usage": PROPERTY_USAGE_DEFAULT,
		})
		
		ProjectSettings.save()
	
	add_autoload_singleton(AUTOLOAD_NAME, "res://addons/drawdebug3d/script/DrawDebug3D.gd")

func _disable_plugin():
	ProjectSettings.save()
	
	remove_autoload_singleton(AUTOLOAD_NAME)
