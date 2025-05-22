class_name PrimitiveTextData extends PrimitiveData

var position: Vector3
var rotation: Vector3
var text: String
var font_size: int
var h_alignment: HorizontalAlignment
var v_alignment: VerticalAlignment
var uppercase: bool
var billboard: BaseMaterial3D.BillboardMode


func _init(position: Vector3 = Vector3.ZERO, rotation: Vector3 = Vector3.ZERO, text: String = "Hello World!", font_size: int = 24, h_alignment: HorizontalAlignment = HORIZONTAL_ALIGNMENT_CENTER, v_alignment: VerticalAlignment = VERTICAL_ALIGNMENT_CENTER, uppercase: bool = false, billboard: BaseMaterial3D.BillboardMode = BaseMaterial3D.BILLBOARD_DISABLED, color: Color = Color.RED, lifetime: float = 3.0) -> void:
	super._init(color, lifetime)
	
	self.position = position
	self.rotation = rotation
	self.text = text
	self.font_size = font_size
	self.h_alignment = h_alignment
	self.v_alignment = v_alignment
	self.uppercase = uppercase
	self.billboard = billboard
