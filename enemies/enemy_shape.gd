extends Polygon2D

# Number of sides for the circle (default is high for smoothness)
var circle_sides: int = 24
# Radius of the circle
var radius: float = 16
# Duration of the transition
var morph_duration: float = 0.2

# Internal variables
var current_shape: Array = []
var target_shape: Array = []
var morph_progress: float = 0.0
var morphing: bool = false

signal shape_changed(shape)


func _ready():
	# Start with a circle shape
	current_shape = generate_circle_points(circle_sides, radius)
	init()

func init(sides: int = 3):
	target_shape = generate_polygon_points(radius, sides)
	current_shape = interpolate_shapes(current_shape, target_shape, 1.0)
	polygon = current_shape
	shape_changed.emit(polygon)

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

func _process(delta):
	if morphing:
		morph_progress += delta / morph_duration
		if morph_progress >= 1.0:
			morph_progress = 1.0
			morphing = false
			current_shape = polygon
		
		# Interpolate between the circle and the triangle
		polygon = interpolate_to_circle(current_shape, target_shape, morph_progress)
		shape_changed.emit(polygon)

func morph_to_circle(progress: float):
	if morphing:
		current_shape = target_shape
		polygon = target_shape
		shape_changed.emit(polygon)
	var final_shape = generate_circle_points(circle_sides, radius)
	target_shape = interpolate_to_circle(current_shape, final_shape, progress)
	morph_progress = 0.0
	morphing = true

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
