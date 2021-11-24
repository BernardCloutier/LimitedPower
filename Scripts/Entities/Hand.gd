class_name Hand
extends Spatial

export(PackedScene) var ElectricArcScene
export(int, 0, 16) var NumArcs = 8

var _copy_transform: Spatial
var energy_source: EnergyReserve
var energy_drain_speed: float
var target_position: Vector3 setget _set_target_position
var _charge_target: Chargeable

var _arcs := []
var _is_shooting: bool = false


func _ready() -> void:
	for _i in range(0, NumArcs):
		var arc = self.ElectricArcScene.instance()
		self._arcs.push_back(arc)
		self.add_child(arc)


func _process(delta: float) -> void:
	if self._copy_transform and !self.is_shooting():
		self.global_transform = self._copy_transform.global_transform
	
	if self.is_shooting():
		var energy_amount = self.energy_drain_speed * delta;
		if self._charge_target:
			if self._charge_target.is_receiving_charge():
				var energy = self.energy_source.request_energy(energy_amount)
				self._charge_target.charge(energy)
			else:
				var energy = self._charge_target.decharge(energy_amount)
				self.energy_source.add_energy(energy)
			if !self._charge_target.has_charge():
				self.stop_shooting()


func copy_transform(node: Spatial) -> void:
	self._copy_transform = node


func shoot(chargeable: Chargeable) -> void:
	self._charge_target = chargeable
	self._is_shooting = true
	for arc in self._arcs:
		arc.is_enabled = true
	$Audio.play(0)


func stop_shooting() -> void:
	self._is_shooting = false
	for arc in self._arcs:
		arc.is_enabled = false
	if self._charge_target:
		if self._charge_target is Battery:
			self._charge_target.toggle()
		self._charge_target = null
	$Audio.stop()


func is_shooting() -> bool:
	return self._is_shooting


func _set_target_position(new_target: Vector3) -> void:
	for arc in self._arcs:
#		arc.target_dist = (new_target - self.global_transform.origin).length()
		arc.target = new_target
