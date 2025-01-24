@tool
extends Polygon2D

# Number of sides for the circle (default is high for smoothness)
@export var circle_sides: int = 24
# Radius of the circle
@export var radius: float = 50.0
# Duration of the transition
@export var morph_duration: float = 2.0

# Internal variables
var current_shape: Array = [] : set = _on_current_shape_updated
var target_shape: Array = []
var morph_progress: float = 0.0
var morphing: bool = false

@onready var collision_shape = $CollisionPolygon2D


func _ready():
	# Start with a circle shape
	current_shape = generate_circle_points(circle_sides, radius)
	init()

func init(sides: int = 3):
	target_shape = generate_polygon_points(radius, sides)
	current_shape = interpolate_shapes(current_shape, target_shape, 1.0)

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_accept"):
		start_morph_to_circle()

func generate_circle_points(sides: int, radius: float) -> Array:
	var points = []
	for i in range(sides):
		var angle = (2 * PI / sides) * i
		points.append(Vector2(radius * cos(angle), radius * sin(angle)))
	return points

func generate_polygon_points(radius: float, sides: int = 3) -> Array:
	var points = []
	for i in range(sides):  # Triangle has 3 vertices
		var angle = (2 * PI / sides) * i - PI / 2  # Ensure one vertex is at the top
		points.append(Vector2(radius * cos(angle), radius * sin(angle)))
	return points

func start_morph_to_circle():
	target_shape = generate_circle_points(circle_sides, radius)
	morph_progress = 0.0
	morphing = true

func _process(delta):
	if morphing:
		morph_progress += delta / morph_duration
		if morph_progress >= 1.0:
			morph_progress = 1.0
			morphing = false
		
		# Interpolate between the circle and the triangle
		current_shape = interpolate_to_circle(current_shape, target_shape, morph_progress)

func morph_to_circle(morph_progress: int):
	var target_shape = generate_circle_points(circle_sides, radius)
	current_shape = interpolate_to_circle(current_shape, target_shape, morph_progress)

func interpolate_shapes(shape1: Array, shape2: Array, t: float) -> Array:
	var result = []
	
	for p1 in shape1:
		var min_distance = INF
		var closest_point = null
		for p2 in shape2:
			var distance = p2.distance_to(p1)
			if distance < min_distance:
				closest_point = p2
				min_distance = distance
		result.append(p1.lerp(closest_point, t))
	
	return result

func interpolate_to_circle(shape1: Array, shape2: Array, t: float) -> Array:
	var result = []
	
	for i in range(shape1.size()):
		var p1 = shape1[i]
		var p2 = shape2[i]
		result.append(p1.lerp(p2, t))
	
	return result

func _on_current_shape_updated(shape: Array):
	polygon = shape
	collision_shape.polygon = shape
	current_shape = shape
