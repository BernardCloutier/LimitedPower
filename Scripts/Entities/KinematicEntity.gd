class_name KinematicEntity
extends KinematicBody

export(Curve) var gravity_shift_curve: Curve
export(float, -1.55, 0) var min_head_angle = -1.4
export(float, 0, 1.55) var max_head_angle = 1.4
export(float) var ground_friction: float = 8
export(float) var ground_sprint_factor: float = 2
export(float) var wall_friction: float = 2
export(float) var gravity_shift_speed: float = 2.0

onready var _move_handler := BunnyHopMovement.new()
onready var target_rotation: Quat = Quat(Vector3.UP, 0) setget _set_target_rotation

var ground_velocity := Vector3.ZERO

var _movement_dir := Vector3.ZERO
var _velocity := Vector3.ZERO


func _physics_process(delta: float) -> void:
	if self.target_rotation != null:
		var rot_delta = self.gravity_shift_speed * delta
		var rotation_quat = self.global_transform.basis.get_rotation_quat()
		var angle = min(rotation_quat.angle_to(self.target_rotation), 1.0)
		var smooth_delta = self.gravity_shift_curve.interpolate(angle)
		self.global_transform.basis = Basis(rotation_quat.slerp(self.target_rotation, rot_delta * smooth_delta))
	
	var ground_modifier := 1.0
	var new_velocity := _move_handler.move(
		self._movement_dir,
		self._velocity + self.ground_velocity,
		self.ground_friction,
		ground_modifier,
		is_on_floor(),
		delta
	)
	
	new_velocity += self._get_gravity_pull(delta)
	
	# cap falling velocity
	new_velocity.y = max(new_velocity.y, -Globals.player.gravity_max_velocity)
	self._velocity = move_and_slide(
		new_velocity,
		self._get_up_dir(),
		false,		# stop_on_slope
		4,			# max_slides
		0.785398, 	# floor_max_angle
		false		# infinite_inertia
	)


func _get_up_dir() -> Vector3:
	return self.global_transform.basis.y


func _get_gravity_dir() -> Vector3:
	return -self._get_up_dir()


func _get_gravity_pull(delta: float) -> Vector3:
	var gravity_strength: float = ProjectSettings.get_setting("physics/3d/default_gravity")
	var gravity_pull := gravity_strength * delta * self._get_gravity_dir()
	if is_on_floor():
		# Apply gravity parallel to surface normal to avoid sliding
		var floor_normal := get_floor_normal()
		gravity_pull = gravity_pull.dot(floor_normal) / floor_normal.length_squared() * floor_normal
	return gravity_pull


func _set_target_rotation(new_rotation: Quat) -> void:
	target_rotation = new_rotation

