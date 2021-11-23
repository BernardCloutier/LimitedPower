extends Node

signal fov_changed(value)


var music_volume_db: float = 1.0 setget _set_music_volume_db
var effects_volume_db: float = 1.0 setget _set_effects_volume_db
var mouse_sensitivity: float = 0.008 setget _set_mouse_sensitivity
var fov: float = 85 setget _set_fov

var _config: ConfigFile


func _ready() -> void:
	_config = ConfigFile.new()
	var err = _config.load("user://settings.cfg")
	if err == OK: # If not, something went wrong with the file loading
		if not _config.has_section_key("audio", "music"):
			_config.set_value("audio", "music", 1.0)
		self.music_volume_db = linear2db(_config.get_value("audio", "music", 1.0))

		if not _config.has_section_key("audio", "effects"):
			_config.set_value("audio", "effects", 1.0)
		self.effects_volume_db = linear2db(_config.get_value("audio", "effects", 1.0))

		if not _config.has_section_key("input", "mouse_sensitivity"):
			_config.set_value("input", "mouse_sensitivity", 0.008)
		self.mouse_sensitivity = _config.get_value("input", "mouse_sensitivity", 0.008)

		if not _config.has_section_key("graphics", "fov"):
			_config.set_value("graphics", "fov", 85)
		self.fov = _config.get_value("graphics", "fov", 85)
	else: # create default configs
		_config.set_value("audio", "music", 1.0)
		_config.set_value("audio", "effects", 1.0)
		_config.set_value("input", "mouse_sensitivity", 0.008)
		_config.set_value("graphics", "fov", 85)
		var _err =_config.save("user://settings.cfg")
		print(_err)


func _exit_tree() -> void:
	var _err = _config.save("user://settings.cfg")


func _set_music_volume_db(value: float) -> void:
	music_volume_db = value
	_config.set_value("audio", "music", db2linear(music_volume_db))
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Music"), music_volume_db)


func _set_effects_volume_db(value: float) -> void:
	effects_volume_db = value
	_config.set_value("audio", "effects", db2linear(effects_volume_db))
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Effects"), effects_volume_db)


func _set_mouse_sensitivity(value: float) -> void:
	mouse_sensitivity = value
	_config.set_value("input", "mouse_sensitivity", mouse_sensitivity)


func _set_fov(value: float) -> void:
	fov = value
	_config.set_value("graphics", "fov", fov)
	emit_signal("fov_changed", fov)
