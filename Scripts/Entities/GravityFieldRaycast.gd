extends RayCast

onready var controller: CharacterController = get_node("..")

var _magnetic_pathway: MagneticPathway
var _moving_platform: ChargePlatform


func _process(delta: float) -> void:
	if self.is_colliding():
		var collider = self.get_collider()
		if collider is MagneticPath:
			var ground_normal = self.get_collision_normal()
			var my_quat = self.global_transform.basis.get_rotation_quat()
			var my_z = self.global_transform.basis.z
			var ground_z = (my_z - my_z.dot(ground_normal) * ground_normal).normalized()
			var cross = ground_normal.cross(ground_z).normalized()
			controller.target_rotation = Quat(Basis(cross, ground_normal, ground_z))
			
			self._magnetic_pathway = collider.pathway
			self._magnetic_pathway.energy_source = controller._energy_reserve
		if collider is ChargePlatform:
			self._moving_platform = collider
			if !_moving_platform.passengers.has(controller):
				_moving_platform.passengers.push_back(controller)
	else:
		if self._magnetic_pathway:
			self.leave_gravity_field()
		if self._moving_platform:
			_moving_platform.passengers.erase(controller)
			self._moving_platform = null


func leave_gravity_field() -> void:
	if self._magnetic_pathway:
		self._magnetic_pathway.energy_source = null
		self._magnetic_pathway = null
		controller.target_rotation = Quat(Vector3.UP, 0)
