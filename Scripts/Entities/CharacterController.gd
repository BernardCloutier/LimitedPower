class_name CharacterController
extends KinematicEntity

export(PackedScene) var ElectricArcScene
export(float, 0.0, 3.0) var EnergyDrainSpeed = 0.2

onready var _head_pivot := $HeadPivot
onready var _raycast := $HeadPivot/RayCast
onready var _left_hand := $HeadPivot/LeftHand
onready var _right_hand := $HeadPivot/RightHand

var energy_level: float = 1.0

var _left_arcs := []
var _right_arcs := []

var _is_shooting_left: bool = false
var _is_shooting_right: bool = false

func _ready() -> void:
	for _i in range(0, 8):
		var left_arc = self.ElectricArcScene.instance()
		self._left_arcs.push_back(left_arc)
		self._left_hand.add_child(left_arc)
		
		var right_arc = self.ElectricArcScene.instance()
		self._right_arcs.push_back(right_arc)
		self._right_hand.add_child(right_arc)


func _process(delta: float) -> void:
	if self._raycast.is_colliding():
		var dist = (self._raycast.get_collision_point() - self._left_hand.global_transform.origin).length()
		for arc in self._left_arcs:
			arc.target_dist = dist
	
	if _is_shooting_left:
		self.energy_level -= self.EnergyDrainSpeed * delta
	if _is_shooting_right:
		self.energy_level -= self.EnergyDrainSpeed * delta
	self.energy_level = max(self.energy_level, 0)

	if !self._has_energy():
		self.stop_shooting_left()
		self.stop_shooting_right()


func move(forward: float, sideways: float) -> void:
	var dir = Vector3.ZERO
	dir += forward * self.global_transform.basis.z
	dir += sideways * self._head_pivot.global_transform.basis.x
	self._movement_dir = dir.normalized()


func turn(x_rotation: float, y_rotation: float) -> void:
	self.rotate_y(y_rotation)
	self._head_pivot.rotate_x(x_rotation)
	self._head_pivot.rotation.x = clamp(self._head_pivot.rotation.x, self.min_head_angle, self.max_head_angle)


func start_shooting_left() -> void:
	if !self._has_energy():
		return

	self._is_shooting_left = true
	for arc in self._left_arcs:
		arc.is_enabled = true


func stop_shooting_left() -> void:
	self._is_shooting_left = false
	for arc in self._left_arcs:
		arc.is_enabled = false



func start_shooting_right() -> void:
	if !self._has_energy():
		return

	self._is_shooting_right = true
	for arc in self._right_arcs:
		arc.is_enabled = true


func stop_shooting_right() -> void:
	self._is_shooting_right = false
	for arc in self._right_arcs:
		arc.is_enabled = false


func recharge(energy: float):
	self.energy_level = min(self.energy_level + energy, 1.0)


func _has_energy() -> bool:
	return self.energy_level > 0.0


func _on_Recharger_body_entered(body):
	pass # Replace with function body.
