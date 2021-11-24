class_name EnergyReserve
extends Node

signal energy_level_changed(new_value)

var energy_level: float = 1.0


func _ready():
	HUD.register_energy_bar(self, "energy_level")


func add_energy(amount: float) -> void:
	self.energy_level = min(self.energy_level + amount, 1.0)
	emit_signal("energy_level_changed", self.energy_level)


func request_energy(amount: float) -> float:
	var new_energy_level = max(self.energy_level - amount, 0.0)
	var energy_diff = self.energy_level - new_energy_level
	self.energy_level = new_energy_level
	emit_signal("energy_level_changed", self.energy_level)
	return energy_diff


func has_energy() -> bool:
	return self.energy_level > 0
