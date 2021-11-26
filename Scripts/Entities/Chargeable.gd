class_name Chargeable
extends KinematicBody

signal fully_charged
signal empty

export(NodePath) var ChargeIndicator
export(float, 0, 1) var initial_energy_percentage = 0
export(float, 0, 1) var max_energy_level = 1.0
export(float, 0.0, 5.0) var charging_speed = 1.0

var _consumers := 0
var _energy_level: float = 0


func _ready() -> void:
	self._energy_level = self.initial_energy_percentage * self.max_energy_level
	self.call_deferred("_on_energy_changed_internal", self._energy_level, 0)


func start_using() -> void:
	self._consumers += 1


func stop_using() -> void:
	self._consumers -= 1


func charge(energy: float) -> void:
	var old_energy_level = self._energy_level
	self._energy_level = min(old_energy_level + energy, self.max_energy_level)
	self._on_energy_changed_internal(self._energy_level, old_energy_level)


func decharge(energy: float) -> float:
	var old_energy_level = self._energy_level
	var new_energy_level = max(old_energy_level - energy, 0.0)
	var energy_delta = self._energy_level - new_energy_level
	self._energy_level = new_energy_level
	self._on_energy_changed_internal(new_energy_level, old_energy_level)
	return energy_delta


func has_charge() -> bool:
	return self._energy_level > 0.0001


func is_full() -> bool:
	return !self._energy_level < self.max_energy_level


func is_empty() -> bool:
	return !self.has_charge()


func is_receiving_charge() -> bool:
	return true


func _on_energy_changed_internal(new_energy_level: float, old_energy_level: float) -> void:
	self.get_node(self.ChargeIndicator).value = new_energy_level / self.max_energy_level
	if !self._energy_level < self.max_energy_level:
		emit_signal("fully_charged")
	if !self.has_charge():
		emit_signal("empty")
	self.on_energy_changed(new_energy_level, old_energy_level)


func on_energy_changed(_new_energy_level: float, _old_energy_level: float) -> void:
	pass
