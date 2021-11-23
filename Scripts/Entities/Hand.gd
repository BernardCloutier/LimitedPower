class_name Hand
extends Spatial

export(PackedScene) var ElectricArcScene
export(int, 0, 16) var NumArcs = 8

var _copy_transform: Spatial
var target_position: Vector3 setget _set_target
var target: Chargeable

var _arcs := []
var _is_shooting: bool = false


func _ready() -> void:
	for _i in range(0, NumArcs):
		var arc = self.ElectricArcScene.instance()
		self._arcs.push_back(arc)
		self.add_child(arc)


func _process(delta: float) -> void:
	if self._copy_transform and !self._is_shooting:
		self.global_transform = self._copy_transform.global_transform


func copy_transform(node: Spatial) -> void:
	self._copy_transform = node


func shoot() -> void:
	self._is_shooting = true
	for arc in self._arcs:
		arc.is_enabled = true


func stop_shooting() -> void:
	self._is_shooting = false
	for arc in self._arcs:
		arc.is_enabled = false


func is_shooting() -> bool:
	return self._is_shooting


func _set_target(new_target: Vector3) -> void:
	for arc in self._arcs:
		arc.target_dist = (new_target - self.global_transform.origin).length()
