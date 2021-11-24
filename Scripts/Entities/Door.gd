extends Spatial


onready var _anim = $AnimationPlayer

var _is_opened: bool = false


func _on_DoorBody_fully_charged():
	if !self._is_opened:
		self._is_opened = true
		self._anim.play("Open")
