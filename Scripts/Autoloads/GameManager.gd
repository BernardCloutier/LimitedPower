extends Node


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
#	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	pass


func load_level(index: int) -> void:
	var current_level = self.get_child(0)
	if current_level:
		current_level.queue_free()

	if index > 2:
		var level = load("res://Scenes/Levels/EndScreen.tscn").instance()
		self.add_child(level)
		HUD.queue_free()
	else:
		var level: Level = load("res://Scenes/Levels/" + str(index) + ".tscn").instance()
		self.add_child(level)
		level.spawn_player()
