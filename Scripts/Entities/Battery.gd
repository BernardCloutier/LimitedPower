class_name Battery
extends Chargeable


export(Material) var ChargeMaterial
export(Material) var DechargeMaterial
export(float, -12, 0) var min_volume = -8
export(float, -10, 0) var max_volume = -2
export(float, 0, 2) var min_pitch = 0.8
export(float, 0, 5) var max_pitch = 2.4

onready var _audio = $Audio
onready var _head = $Head

var _is_receiving_charge = true


func _ready() -> void:
	self._update_indicator_material(self._is_receiving_charge)
	self._update_audio(self._energy_level)



func toggle() -> void:
	if self._consumers == 0:
		self._is_receiving_charge = !self._is_receiving_charge
		self._update_indicator_material(self._is_receiving_charge)


func is_receiving_charge() -> bool:
	return self._is_receiving_charge


func on_energy_changed(new_energy_charge: float, _old_energy_level: float) -> void:
	self._update_audio(new_energy_charge)


func _update_indicator_material(is_charging: bool) -> void:
	if is_charging:
		self._head.material_override = self.ChargeMaterial
	else:
		self._head.material_override = self.DechargeMaterial


func _update_audio(percent: float) -> void:
	self._audio.unit_db = min_volume + (max_volume - min_volume) * percent
	self._audio.pitch_scale = min_pitch + (max_pitch - min_pitch) * percent
