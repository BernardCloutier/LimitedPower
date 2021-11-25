class_name CharacterController
extends KinematicEntity

export(PackedScene) var HandScene
export(float, 0.0, 3.0) var EnergyDrainSpeed = 0.2
export(float) var initial_energy_level := 0

onready var _energy_reserve := $EnergyReserve
onready var _platform_raycast := $PlatformRayCast
onready var _harness := $Harness
onready var _head_pivot := $Harness/HeadPivot
onready var _raycast := $Harness/HeadPivot/RayCast
onready var _left_hand_pos := $Harness/HeadPivot/LeftHandPos
onready var _right_hand_pos := $Harness/HeadPivot/RightHandPos

onready var checkpoint: Vector3 = get_node("..").global_transform.origin

var _left_hand: ElectricHand 
var _right_hand: ElectricHand


func _ready() -> void:
	self._left_hand = HandScene.instance()
	self._right_hand = HandScene.instance()
	self.add_child(self._left_hand)
	self.add_child(self._right_hand)
	
	self._left_hand.energy_source = self._energy_reserve
	self._right_hand.energy_source = self._energy_reserve
	self._left_hand.copy_transform(self._left_hand_pos)
	self._right_hand.copy_transform(self._right_hand_pos)
	self._energy_reserve.energy_level = self.initial_energy_level


func _process(delta):
	if self.global_transform.origin.y < -5:
		self.global_transform.origin = self.checkpoint


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
	if self._raycast.is_colliding():
		var object = self._raycast.get_collider()
		if object is Chargeable:
			self._left_hand.shoot(object)


func stop_shooting_left() -> void:
	self._left_hand.stop_shooting()


func start_shooting_right() -> void:
	if self._raycast.is_colliding():
		var object = self._raycast.get_collider()
		if object is Chargeable:
			self._right_hand.shoot(object)


func stop_shooting_right() -> void:
	self._right_hand.stop_shooting()


func stop_shooting() -> void:
	self.stop_shooting_left()
	self.stop_shooting_right()


func leave_gravity_field() -> void:
	self._platform_raycast.leave_gravity_field()


func recharge(energy: float):
	self._energy_reserve.add_energy(energy)


func _has_energy() -> bool:
	return self._energy_reserve.has_energy()


func _is_shooting() -> bool:
	return self._left_hand.is_shooting() or self._right_hand.is_shooting()


func _on_EnergyReserve_energy_level_changed(new_value):
	if new_value < 0.0001:
		self.stop_shooting()
		self.leave_gravity_field()
