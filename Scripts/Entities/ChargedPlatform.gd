class_name ChargePlatform
extends KinematicBody


export(NodePath) var start
export(NodePath) var end
export(float) var speed: float = 1.0
export(Curve) var easing_curve: Curve

onready var start_pos: Vector3 = get_node(start).transform.origin
onready var end_pos: Vector3 = get_node(end).transform.origin

var _energy := 0.0
var _target_position := start_pos

var passengers = []


func set_position_percent(percent: float) -> void:
	var delta_pos = percent * (end_pos - start_pos)
	self._target_position = start_pos + delta_pos

func _process(delta: float) -> void:
	var distance_to_target = self.transform.origin.distance_to(self._target_position)
	if distance_to_target > 0.0001:
		var percentage = start_pos.distance_to(self._target_position) / (start_pos.distance_to(end_pos))
		var dist = self.easing_curve.interpolate(percentage) 
		var dist_vec = min(dist, distance_to_target) * self.transform.origin.direction_to(self._target_position)
		self.transform.origin += dist_vec * speed * delta
