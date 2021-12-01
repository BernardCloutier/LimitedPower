class_name Level
extends Spatial

export(NodePath) var player_spawn
export(PackedScene) var player: PackedScene
export(int) var next_level: int

onready var _spawn_point: Spatial = get_node(player_spawn)


func spawn_player() -> void:
	self._spawn_point.add_child(self.player.instance())



func _on_EndOfLevelArea_body_entered(body):
	GameManager.load_level(self.next_level)
