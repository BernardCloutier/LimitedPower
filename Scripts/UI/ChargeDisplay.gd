tool
extends Sprite3D


func _ready():
	self.texture = self.get_node("../Viewport").get_texture()
