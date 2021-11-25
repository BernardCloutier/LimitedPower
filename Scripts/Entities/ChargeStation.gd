class_name DrainingChargeStation
extends DrainingChargeable

onready var charge_target: ChargePlatform = get_node("../PlatformGroup/Platform")


func on_energy_changed2(new_energy_level: float, _old_energy_level: float) -> void:
	charge_target.set_position_percent(new_energy_level / self.max_energy_level)
