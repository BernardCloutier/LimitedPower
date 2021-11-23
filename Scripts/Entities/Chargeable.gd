class_name Chargeable
extends RigidBody


export(NodePath) var ChargeIndicator
export(float, 0.0, 5.0) var charging_factor = 1.0

var energy_level: float = 0


func _ready() -> void:
	$MeshInstance/Display0.texture = $MeshInstance/Viewport.get_texture()
	$MeshInstance/Display1.texture = $MeshInstance/Viewport.get_texture()
	$MeshInstance/Display2.texture = $MeshInstance/Viewport.get_texture()
	$MeshInstance/Display3.texture = $MeshInstance/Viewport.get_texture()


func charge(energy: float) -> void:
	self.energy_level = min(self.energy_level + energy, 1.0)
	self.get_node(self.ChargeIndicator).value = self.energy_level
