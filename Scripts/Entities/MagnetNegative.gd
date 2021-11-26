extends Position3D


export(float) var speed: float = 1.0

var enabled: bool = true setget _set_enabled



func _process(delta: float):
	if !self.enabled:
		return

	for body in $Area.get_overlapping_bodies():
		if body is Battery:
			body.global_transform.origin -= self.global_transform.basis.z.normalized() * delta * speed
			body.prevent_fall()


func _set_enabled(value: bool) -> void:
	if value != enabled:
		enabled = value
		$CPUParticles.visible = enabled
