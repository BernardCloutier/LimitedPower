extends RayCast

onready var controller: CharacterController = get_node("..")

var _magnetic_pathway: MagneticPathway
var _moving_platform: ChargePlatform
var _is_in_gravity_field: bool = false


func _process(delta: float) -> void:
	if self.is_colliding():
		var collider = self.get_collider()
		if collider is MagneticPath:
			self._enter_gravity_field()
			var ground_normal = self.get_collision_normal()
			var my_quat = self.global_transform.basis.get_rotation_quat()
			var my_z = self.global_transform.basis.z
			var ground_z = (my_z - my_z.dot(ground_normal) * ground_normal).normalized()
			var cross = ground_normal.cross(ground_z).normalized()
			self.controller.target_rotation = Quat(Basis(cross, ground_normal, ground_z))
			
			self._magnetic_pathway = collider.pathway
			self._magnetic_pathway.energy_source = controller._energy_reserve
		if collider is ChargePlatform:
			self._moving_platform = collider
			self.controller.ground_velocity = self._moving_platform.velocity
#			if !_moving_platform.passengers.has(controller):
#				_moving_platform.passengers.push_back(controller)
		else:
			self.controller.ground_velocity = Vector3.ZERO
	else:
		if self._magnetic_pathway:
			self.leave_gravity_field()
		if self._moving_platform:
			_moving_platform.passengers.erase(controller)
			self._moving_platform = null


func _enter_gravity_field() -> void:
	if !self._is_in_gravity_field:
		self._is_in_gravity_field = true
		$Audio.play()


func leave_gravity_field() -> void:
	if self._magnetic_pathway:
		self._magnetic_pathway.energy_source = null
		self._magnetic_pathway = null
		controller.target_rotation = Quat(Vector3.UP, 0)

		self._is_in_gravity_field = false
		$Audio.stop()
