extends Node

class player_constants:
	var gravity := 49.0
	var gravity_max_velocity := 75.0
	var ground_acceleration := 85.0
	var ground_max_velocity := 20.0
	var air_acceleration := 20.0
	var air_max_velocity := 25.0


onready var player := player_constants.new()

func _ready() -> void:
	pass
#	Console.add_command('player_air_accel', self, 'set_player_air_accel')\
#		.set_description('Sets player air acceleration')\
#		.add_argument('value', TYPE_REAL)\
#		.register()
#	Console.add_command('player_ground_accel', self, 'set_player_ground_accel')\
#		.set_description('Sets player ground acceleration')\
#		.add_argument('value', TYPE_REAL)\
#		.register()

func set_player_air_accel(value: float) -> void:
	player.air_acceleration = value

func set_player_ground_accel(value: float) -> void:
	player.ground_acceleration = value
