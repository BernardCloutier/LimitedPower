tool
class_name ElectricArc
extends ImmediateGeometry


#export var segment_length = 1.0
export(int, 0, 25) var num_segments = 15
export var amplitude = 2.0
export var min_timer_wait = 0.05
export var max_timer_wait = 0.25
export var start_enabled: bool = false

onready var _start = $Start
onready var _end = $End
onready var _particles = $CPUParticles
onready var _random = RandomNumberGenerator.new()

var target_dist: float setget _set_target_dist
var is_enabled: bool = false setget _set_enable

var points = []

# Called when the node enters the scene tree for the first time.
func _ready():
	self._random.randomize()
	self._generate_points()
	self._set_enable(self.start_enabled)


func _process(_delta):
	if self.is_enabled:
		self._draw()


func _set_target_dist(dist: float) -> void:
	self._end.transform.origin.z = -dist
	self._particles.transform.origin.z = -dist / 2.0
	self._particles.emission_box_extents.z = dist / 2.0


func _set_enable(val: bool) -> void:
	is_enabled = val

	if is_enabled:
		self._particles.emitting = true
	else:
		clear()
		self._particles.emitting = false


func _generate_points():
	self.points.clear()

	var origin = self._start.transform.origin
	var vector = self._end.transform.origin - self._start.transform.origin
	var dir = vector.normalized()
	var total_length = vector.length()
#	var num_segments = ceil(total_length / segment_length)
	var segment_length = total_length / self.num_segments
	
	self.points.push_back(origin)
	for i in range(1, self.num_segments - 1):
		var point = origin + dir * segment_length * i
		point.x = self._random.randf() * self.amplitude - self.amplitude / 2.0
		point.y = self._random.randf() * self.amplitude - self.amplitude / 2.0
		
		self.points.push_back(point)
	
	self.points.push_back(self._end.transform.origin)

func _draw():
	clear()
	
	begin(Mesh.PRIMITIVE_LINE_STRIP)
	set_color(Color.yellow)
	
	for point in self.points:
#		set_normal(Vector3(0, 0, 1))
#		set_uv(Vector2(0, 0))
		# Call last for each vertex, adds the above attributes.
		add_vertex(point)
	
	end()


func _on_Timer_timeout():
	self._generate_points()
	$Timer.wait_time = self._random.randf_range(min_timer_wait, max_timer_wait)
