@tool
extends EditorPlugin

const AUTOLOAD_NAME: String = "DrawDebug3D"

func _enable_plugin():
	add_autoload_singleton(AUTOLOAD_NAME, "res://addons/drawdebug3d/script/DrawDebug3D.gd")

func _disable_plugin():
	remove_autoload_singleton(AUTOLOAD_NAME)
