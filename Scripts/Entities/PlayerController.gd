extends Node


onready var controller = self.get_node("..")

# Called when the node enters the scene tree for the first time.
func _ready():
	HUD.register_energy_bar(controller, "energy_level")


func _process(delta: float) -> void:
	self._move()


func _move() -> void:
	var forward := -Input.get_action_strength("forward")
	var backward := Input.get_action_strength("backward")
	var front_dir = forward + backward
	
	var left := -Input.get_action_strength("left")
	var right := Input.get_action_strength("right")
	var sideways_dir = left + right
	controller.move(front_dir, sideways_dir)


func _input(event: InputEvent) -> void:
	if Input.get_mouse_mode() != Input.MOUSE_MODE_CAPTURED:
		return;

	if event is InputEventMouseMotion:
		var x_rotation = -event.relative.y * Settings.mouse_sensitivity
		var y_rotation = -event.relative.x * Settings.mouse_sensitivity
		controller.turn(x_rotation, y_rotation)

	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT:
			if event.pressed:
				controller.start_shooting_left()
			else:
				controller.stop_shooting_left()
		if event.button_index == BUTTON_RIGHT:
			if event.pressed:
				controller.start_shooting_right()
			else:
				controller.stop_shooting_right()

