extends Control


export(NodePath) var EnergyBarPath

onready var _energy_bar: TextureProgress = get_node(EnergyBarPath)


class Property:
	var object: Node
	var property_path: NodePath
	
	func _init(_object, _prop_path):
		object = _object
		property_path = _prop_path
	
	func get_prop():
		return object.get_indexed(property_path) 

var energy_property: Property


func register_energy_bar(node: Node, property: NodePath) -> void:
	energy_property = Property.new(node, property)
	if not node.is_connected("tree_exited", self, "_unregister_object"):
		var _err = node.connect("tree_exited", self, "_unregister_object", [node])


func _process(_delta: float) -> void:
	if energy_property != null:
		var energy_value = energy_property.get_prop()
		self._energy_bar.value = energy_value


func _unregister_object(node: Node) -> void:
	energy_property = null
