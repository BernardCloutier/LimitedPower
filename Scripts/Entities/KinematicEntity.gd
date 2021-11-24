class_name KinematicEntity
extends KinematicBody

export(float, -1.55, 0) var min_head_angle = -1.4
export(float, 0, 1.55) var max_head_angle = 1.4
export(float) var ground_friction: float = 8
export(float) var ground_sprint_factor: float = 2
export(float) var wall_friction: float = 2

onready var _gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity")
onready var _move_handler := BunnyHopMovement.new()
onready var target_basis: Basis = Basis(Vector3.UP, 0) setget _set_target_basis

export var gravity_dir: Vector3 = Vector3.DOWN
var _movement_dir := Vector3.ZERO
var _velocity := Vector3.ZERO


func _physics_process(delta: float) -> void:
	if self.target_basis != null:
		self.global_transform.basis.x = lerp(self.global_transform.basis.x, self.target_basis.x, delta * 2)
		self.global_transform.basis.y = lerp(self.global_transform.basis.y, self.target_basis.y, delta * 2)
		self.global_transform.basis.z = lerp(self.global_transform.basis.z, self.target_basis.z, delta * 2)
	
	var ground_modifier := 1.0
	var new_velocity := _move_handler.move(
		self._movement_dir,
		self._velocity,
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
		-gravity_dir,
		false,		# stop_on_slope
		4,			# max_slides
		0.785398, 	# floor_max_angle
		false		# infinite_inertia
	)


func _get_gravity_pull(delta: float) -> Vector3:
	var gravity_pull := self._gravity * delta * self.gravity_dir
	if is_on_floor():
		# Apply gravity parallel to surface normal to avoid sliding
		var floor_normal := get_floor_normal()
		gravity_pull = gravity_pull.dot(floor_normal) / floor_normal.length_squared() * floor_normal
	return gravity_pull


func _set_target_basis(new_basis: Basis) -> void:
	target_basis = new_basis


func _notification(what) -> void:
	if what == NOTIFICATION_PREDELETE:
		_move_handler.free()
