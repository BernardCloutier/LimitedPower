class_name DrainingChargeable
extends Chargeable

export(float, 0, 5.0) var ChargeHoldDuration = 0.5
export(float, 0, 5.0) var ChargeDrainSpeed = 0.5
export(float, -12, 0) var min_volume = -10
export(float, -10, 0) var max_volume = -2
export(float, 0, 2) var min_pitch = 0.8
export(float, 0, 5) var max_pitch = 2.4

onready var _audio = $Audio

var _charge_hold_timer: Timer
var _is_draining: bool = false;
var _is_fully_charged: bool = false;


func _ready() -> void:
	self._charge_hold_timer = Timer.new()
	self._charge_hold_timer.one_shot = true
	var _result = self._charge_hold_timer.connect("timeout", self, "_on_ChargeHoldTimer_timeout")
	self.add_child(self._charge_hold_timer)
	self._update_audio(self._energy_level)


func _process(delta: float) -> void:
	if self._is_draining_energy():
		var energy_amount = self.ChargeDrainSpeed * delta
		var energy = self.decharge(energy_amount)
		if energy < 0.0001:
			self._is_draining = false


func on_energy_changed(new_energy_level: float, old_energy_level: float) -> void:
	if new_energy_level > old_energy_level:
		self._charge_hold_timer.start(self.ChargeHoldDuration)
		self._is_draining = false
	self._update_audio(new_energy_level / self.max_energy_level)
	self.on_energy_changed2(new_energy_level, old_energy_level)


func is_full() -> bool:
	return false


func _update_audio(percent: float) -> void:
	self._audio.unit_db = min_volume + (max_volume - min_volume) * percent
	self._audio.pitch_scale = min_pitch + (max_pitch - min_pitch) * percent


func _is_draining_energy() -> bool:
	return !self._is_fully_charged and self._is_draining


func _on_ChargeHoldTimer_timeout() -> void:
	self._is_draining = true


func _on_fully_charged():
	self._is_fully_charged = true


func on_energy_changed2(new_energy_level: float, old_energy_level: float) -> void:
	pass
