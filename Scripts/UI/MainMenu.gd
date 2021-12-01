extends Control

export(NodePath) var StartButtonPath

onready var _start_button: Button = get_node(StartButtonPath)

var _is_game_started = false


func _ready():
	HUD.visible = false


func _on_StartButton_pressed():
	if !self._is_game_started:
		self._is_game_started = true
		GameManager.load_level(0)
		self._start_button.text = "   Resume   "
	self.visible = false
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	get_tree().paused = false
	HUD.visible = true


func _on_ExitButton_pressed():
	get_tree().quit()


func _unhandled_input(event):
	if event is InputEventKey:
		if event.scancode == KEY_ESCAPE:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
			self.visible = true
			get_tree().paused = true
