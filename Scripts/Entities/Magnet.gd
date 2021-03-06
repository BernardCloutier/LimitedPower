extends DrainingChargeable

export(float) var rotate_speed = 1.0
export(float) var initial_rotation = 0

onready var positive = $Positive
onready var negative = $Negative

var _target_rotation = 180


func _ready() -> void:
	self._target_rotation = initial_rotation
	self.connect("empty", self, "_on_empty")


func _process(delta: float) -> void:
	if self.has_charge():
		positive.enabled = true
		negative.enabled = true
	else:
		positive.enabled = false
		negative.enabled = false

	var current_rotation = self.rotation_degrees
	current_rotation.y = lerp(current_rotation.y, self._target_rotation, self.rotate_speed * delta)
	self.rotation_degrees = current_rotation


func _on_empty() -> void:
	_target_rotation += 180.0
	if _target_rotation > 360.0:
		_target_rotation -= 360.0
