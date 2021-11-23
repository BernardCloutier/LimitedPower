tool
class_name ElectricArc
extends ImmediateGeometry


export var segment_length = 1.0
export var amplitude = 2.0
export var min_timer_wait = 0.05
export var max_timer_wait = 0.25

onready var start = $Start
onready var end = $End
onready var particles = $CPUParticles
onready var random = RandomNumberGenerator.new()

var origin: Vector3 setget _set_origin
var target: Vector3 setget _set_target
var target_dist: float setget _set_target_dist
var is_enabled: bool = false setget _set_enable

var points = []

# Called when the node enters the scene tree for the first time.
func _ready():
	self.random.randomize()
	self._generate_points()


func _process(delta):
	if self.is_enabled:
		self._draw()


func _set_origin(new_origin: Vector3) -> void:
	self.start.transform.origin = new_origin


func _set_target(new_target: Vector3) -> void:
	self.end.transform.origin = new_target


func _set_target_dist(dist: float) -> void:
	self.end.transform.origin.z = -dist


func _set_enable(val: bool) -> void:
	is_enabled = val

	if is_enabled:
		particles.emitting = true
	else:
		clear()
		particles.emitting = false


func _generate_points():
	self.points.clear()

	var origin = self.start.transform.origin
	var vector = self.end.transform.origin - self.start.transform.origin
	var dir = vector.normalized()
	var total_length = vector.length()
	var num_segments = ceil(total_length / segment_length)
	
	self.points.push_back(origin)
	for i in range(1, num_segments):
		var point = origin + dir * segment_length * i
		point.x = self.random.randf() * self.amplitude - self.amplitude / 2.0
		point.y = self.random.randf() * self.amplitude - self.amplitude / 2.0
		
		self.points.push_back(point)

func _draw():
	clear()
	
	begin(Mesh.PRIMITIVE_LINE_STRIP)
	
	for point in self.points:
		set_normal(Vector3(0, 0, 1))
		set_uv(Vector2(0, 0))
		# Call last for each vertex, adds the above attributes.
		add_vertex(point)
	
	end()

func _on_Timer_timeout():
	self._generate_points()
	$Timer.wait_time = self.random.randf_range(min_timer_wait, max_timer_wait)
