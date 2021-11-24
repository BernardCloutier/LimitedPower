class_name MagneticPathway
extends Spatial

export(float, 0, 15) var EnergyDrainSpeed := 0.2

var energy_source: EnergyReserve


func _process(delta: float) -> void:
	if self.energy_source:
		var _energy = self.energy_source.request_energy(self.EnergyDrainSpeed * delta)
