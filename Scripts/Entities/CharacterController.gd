class_name CharacterController
extends KinematicEntity

export(PackedScene) var HandScene
export(float, 0.0, 3.0) var EnergyDrainSpeed = 0.2

onready var _energy_reserve := $EnergyReserve
onready var _ground_raycast := $GroundRayCast
onready var _harness := $Harness
onready var _head_pivot := $Harness/HeadPivot
onready var _raycast := $Harness/HeadPivot/RayCast
onready var _left_hand_pos := $Harness/HeadPivot/LeftHandPos
onready var _right_hand_pos := $Harness/HeadPivot/RightHandPos

var _left_hand: Hand 
var _right_hand: Hand
var _left_charge_target: Chargeable
var _right_charge_target: Chargeable
var _magnetic_pathway: MagneticPathway


func _ready() -> void:
	self._left_hand = HandScene.instance()
	self._right_hand = HandScene.instance()
	self.add_child(self._left_hand)
	self.add_child(self._right_hand)
	
	self._left_hand.energy_source = self._energy_reserve
	self._right_hand.energy_source = self._energy_reserve
	self._left_hand.energy_drain_speed = self.EnergyDrainSpeed
	self._right_hand.energy_drain_speed = self.EnergyDrainSpeed
	self._left_hand.copy_transform(self._left_hand_pos)
	self._right_hand.copy_transform(self._right_hand_pos)


func _process(_delta: float) -> void:
	if !self.is_on_floor():
		self.stop_shooting()
	if self._ground_raycast.is_colliding():
		var collider = self._ground_raycast.get_collider()
		if collider is MagneticPath:
			self.target_basis = collider.global_transform.basis.orthonormalized()
			self._magnetic_pathway = collider.pathway
			self._magnetic_pathway.energy_source = self._energy_reserve
			self.gravity_dir = (self.target_basis * Vector3.DOWN).normalized()
			print("Gravity: ", self.gravity_dir)
	else:
		if self._magnetic_pathway:
			self._magnetic_pathway.energy_source = null
			self._magnetic_pathway = null
			self.gravity_dir = Vector3.DOWN
			self.target_basis = Basis(Vector3.UP, 0)



func update_movement(forward: float, sideways: float) -> void:
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
	if !self._can_shoot():
		return

	if self._raycast.is_colliding():
		var target = self._raycast.get_collision_point()
		self._left_hand.target_position = target
		
		var object = self._raycast.get_collider()
		if object is Chargeable:
			self._left_hand.shoot(object)


func stop_shooting_left() -> void:
	self._left_hand.stop_shooting()


func start_shooting_right() -> void:
	if !self._can_shoot():
		return

	if self._raycast.is_colliding():
		var target = self._raycast.get_collision_point()
		self._right_hand.target_position = target
		
		var object = self._raycast.get_collider()
		if object is Chargeable:
			self._right_hand.shoot(object)


func stop_shooting_right() -> void:
	self._right_hand.stop_shooting()


func stop_shooting() -> void:
	self.stop_shooting_left()
	self.stop_shooting_right()


func recharge(energy: float):
	self._energy_reserve.add_energy(energy)


func _has_energy() -> bool:
	return self._energy_reserve.has_energy()


func _is_shooting() -> bool:
	return self._left_hand.is_shooting() or self._right_hand.is_shooting()


func _can_shoot() -> bool:
	return self.is_on_floor()


func _on_EnergyReserve_energy_level_changed(new_value):
	if new_value < 0.0001:
		self.stop_shooting()
