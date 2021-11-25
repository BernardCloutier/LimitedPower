class_name ElectricHand
extends Spatial

export(PackedScene) var ElectricArcScene
export(int, 0, 16) var NumArcs = 8

var _copy_transform: Spatial
var energy_source: EnergyReserve
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
		self.update_arc_transforms()
		if self._charge_target:
			if self._charge_target.is_receiving_charge():
				if self._charge_target.is_full():
					self.stop_shooting()
				else:
					var energy_amount = self._charge_target.charging_speed * delta;
					var energy = self.energy_source.request_energy(energy_amount)
					self._charge_target.charge(energy)
			else:
				if !self.energy_source.is_full():
					var charge_amount = self._charge_target.decharge_speed * delta;
					var missing_amount = self.energy_source.MAX_ENERGY - self.energy_source.energy_level
					var requested_amount = min(charge_amount, missing_amount)
					var energy = self._charge_target.decharge(requested_amount)
					self.energy_source.add_energy(energy)
				if !self._charge_target.has_charge():
					self.stop_shooting()


func copy_transform(node: Spatial) -> void:
	self._copy_transform = node


func update_arc_transforms() -> void:
	self.look_at(self._charge_target.global_transform.origin, self.global_transform.basis.y)
	var dist_to_target = (self._charge_target.global_transform.origin - self.global_transform.origin).length()
	for arc in self._arcs:
		arc.target_dist = dist_to_target


func shoot(chargeable: Chargeable) -> void:
	self._charge_target = chargeable
	self._charge_target.start_using()
	self._is_shooting = true
	for arc in self._arcs:
		arc.is_enabled = true
	$Audio.play(0)


func stop_shooting() -> void:
	self._is_shooting = false
	for arc in self._arcs:
		arc.is_enabled = false
	if self._charge_target:
		self._charge_target.stop_using()
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
