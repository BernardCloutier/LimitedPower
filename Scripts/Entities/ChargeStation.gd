class_name DrainingChargeStation
extends DrainingChargeable

onready var charge_target: ChargePlatform= get_node("../PlatformGroup/Platform")


func on_energy_changed2(new_energy_level: float, old_energy_level: float) -> void:
	charge_target.add_energy(new_energy_level - old_energy_level)
