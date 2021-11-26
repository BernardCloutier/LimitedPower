class_name Battery
extends Chargeable

export(float) var decharge_speed: float = 3.0
export(Material) var ChargeMaterial
export(Material) var DechargeMaterial
export(float, -12, 0) var min_volume = -8
export(float, -10, 0) var max_volume = -2
export(float, 0, 2) var min_pitch = 0.8
export(float, 0, 5) var max_pitch = 2.4
export(bool) var is_receiving_charge = true

onready var _audio = $Audio
onready var _head = $Head

var _is_receiving_charge = true
var _can_fall = true
var _velocity := Vector3.ZERO
var _initial_position: Vector3


func _ready() -> void:
	$PreventFall.connect("timeout", self, "_on_prevent_fall_timeout")
	self._initial_position = self.global_transform.origin
	self._is_receiving_charge = self.is_receiving_charge


func _process(delta) -> void:
	if self._can_fall:
		self._velocity.y += -9.8 * delta
	self._velocity = move_and_slide(self._velocity, self.global_transform.basis.y)
	if self.global_transform.origin.y < -10:
		self.global_transform.origin = self._initial_position
		var old_energy_level = self._energy_level
		self._energy_level = self.initial_energy_percentage * self.max_energy_level
		self._on_energy_changed_internal(self._energy_level, old_energy_level)


func toggle() -> void:
	if self._consumers == 0:
		self._is_receiving_charge = !self._is_receiving_charge
		self._update_indicator_material(self._is_receiving_charge)


func is_receiving_charge() -> bool:
	return self._is_receiving_charge


func on_energy_changed(new_energy_charge: float, _old_energy_level: float) -> void:
	self._update_indicator_material(self._is_receiving_charge)
	self._update_audio(new_energy_charge)


func prevent_fall() -> void:
	self._can_fall = false
	$PreventFall.start()


func _update_indicator_material(is_charging: bool) -> void:
	if is_charging:
		self._head.material_override = self.ChargeMaterial
	else:
		self._head.material_override = self.DechargeMaterial


func _update_audio(percent: float) -> void:
	self._audio.unit_db = min_volume + (max_volume - min_volume) * percent
	self._audio.pitch_scale = min_pitch + (max_pitch - min_pitch) * percent


func _on_prevent_fall_timeout() -> void:
	self._can_fall = true
