@tool
extends EditorPlugin

const AUTOLOAD_NAME: String = "DrawDebug3D"

func _enter_tree() -> void:
	if not ProjectSettings.has_setting("addons/DrawDebug/buffer_size"):
		ProjectSettings.set("addons/DrawDebug/buffer_size", 512)
		
		ProjectSettings.add_property_info({
			"name": "addons/DrawDebug/buffer_size",
			"type": TYPE_INT,
			"hint": PROPERTY_HINT_RANGE,
			"hint_string": "64, 2048, 64",
			"usage": PROPERTY_USAGE_DEFAULT,
		})
		
		ProjectSettings.save()


func _enable_plugin():
	add_autoload_singleton(AUTOLOAD_NAME, "res://addons/drawdebug3d/script/DrawDebug3D.gd")

func _disable_plugin():
	remove_autoload_singleton(AUTOLOAD_NAME)
