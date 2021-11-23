extends PathFollow


export(float, 0.0, 15.0) var speed: float = 5.0

onready var timer = $Timer
onready var sprite = $Sprite3D
onready var particles = $CPUParticles


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var offset_delta = delta * speed
	if timer.is_stopped() and self.unit_offset + offset_delta > 1.0:
		timer.start()
		sprite.visible = false
		particles.emitting = false
	elif self.unit_offset < 1.0:
		self.unit_offset += offset_delta


func _on_Timer_timeout() -> void:
	self.unit_offset = 0
	sprite.visible = true
	particles.emitting = true
