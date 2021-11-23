class_name CharacterController
extends KinematicEntity

export(PackedScene) var HandScene
export(float, 0.0, 3.0) var EnergyDrainSpeed = 0.2

onready var _harness := $Harness
onready var _head_pivot := $Harness/HeadPivot
onready var _raycast := $Harness/HeadPivot/RayCast
onready var _left_hand_pos := $Harness/HeadPivot/LeftHandPos
onready var _right_hand_pos := $Harness/HeadPivot/RightHandPos

var _left_hand: Hand 
var _right_hand: Hand
var _left_charge_target: Chargeable
var _right_charge_target: Chargeable

var energy_level: float = 1.0


func _ready() -> void:
	self._left_hand = HandScene.instance()
	self._right_hand = HandScene.instance()
	self.add_child(self._left_hand)
	self.add_child(self._right_hand)
	
	self._left_hand.copy_transform(self._left_hand_pos)
	self._right_hand.copy_transform(self._right_hand_pos)


func _process(delta: float) -> void:
	if !self.is_on_floor():
		self.stop_shooting()

	if self._raycast.is_colliding():
		var dist = (self._raycast.get_collision_point() - self._left_hand.global_transform.origin).length()
		var target = self._raycast.get_collision_point()
		self._left_hand.target = target
		self._right_hand.target = target
		
		var object = self._raycast.get_collider()
		if object is Chargeable:
			if self._left_hand.is_shooting():
				self._left_charge_target = object
			if self._right_hand.is_shooting():
				self._right_charge_target = object
	else:
		self.stop_shooting()
	
	# TODO: If both hands, charge even faster
	if self._left_hand.is_shooting():
		var energy = self.EnergyDrainSpeed * delta;
		self.energy_level -= energy
		if self._left_charge_target:
			self._left_charge_target.charge(energy)
	if self._right_hand.is_shooting():
		var energy = self.EnergyDrainSpeed * delta;
		self.energy_level -= energy
		if self._right_charge_target:
			self._right_charge_target.charge(energy)
	self.energy_level = max(self.energy_level, 0)

	if !self._has_energy():
		self.stop_shooting()


func move(forward: float, sideways: float) -> void:
	if self._is_shooting():
		self._movement_dir = Vector3.ZERO
		return

	var dir = Vector3.ZERO
	dir += forward * self._harness.global_transform.basis.z
	dir += sideways * self._head_pivot.global_transform.basis.x
	self._movement_dir = dir.normalized()


func turn(x_rotation: float, y_rotation: float) -> void:
	self._harness.rotate_y(y_rotation)
	self._head_pivot.rotate_x(x_rotation)
	self._head_pivot.rotation.x = clamp(self._head_pivot.rotation.x, self.min_head_angle, self.max_head_angle)


func start_shooting_left() -> void:
	if self._can_shoot():
		return

	self._left_hand.shoot()


func stop_shooting_left() -> void:
	self._left_hand.stop_shooting()
	self._left_charge_target = null


func start_shooting_right() -> void:
	if self._can_shoot():
		return

	self._right_hand.shoot()


func stop_shooting_right() -> void:
	self._right_hand.stop_shooting()
	self._right_charge_target = null


func stop_shooting() -> void:
	self.stop_shooting_left()
	self.stop_shooting_right()


func recharge(energy: float):
	self.energy_level = min(self.energy_level + energy, 1.0)


func _has_energy() -> bool:
	return self.energy_level > 0.0


func _is_shooting() -> bool:
		return self._left_hand.is_shooting() or self._right_hand.is_shooting()


func _can_shoot() -> bool:
	return !self._has_energy() or !self.is_on_floor()


func _on_Recharger_body_entered(body):
	pass # Replace with function body.
