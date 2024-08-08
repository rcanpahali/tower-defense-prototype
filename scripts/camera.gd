extends Camera2D

@export var camera_speed: float = 2000.0
@export var zoom_speed: float = 0.05
@export var min_zoom: float = 0.1
@export var max_zoom: float = 5.0

func _ready() -> void:
	zoom = clamp(zoom, Vector2(min_zoom, min_zoom), Vector2(max_zoom, max_zoom))

func _process(delta: float) -> void:
	var movement: Vector2 = get_input_direction()
	move_camera(movement, delta)

func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("esc"):
		get_tree().quit()
	handle_zoom(event)

func get_input_direction() -> Vector2:
	var direction_x = Input.get_action_strength("d") - Input.get_action_strength("a")
	var direction_y = Input.get_action_strength("s") - Input.get_action_strength("w")
	return Vector2(direction_x, direction_y)

func move_camera(movement: Vector2, delta: float) -> void:
	global_position += movement.normalized() * camera_speed * delta

func zoom_in() -> void:
	var new_zoom = zoom - Vector2(zoom_speed, zoom_speed)
	zoom = clamp(new_zoom, Vector2(min_zoom, min_zoom), Vector2(max_zoom, max_zoom))

func zoom_out() -> void:
	var new_zoom = zoom + Vector2(zoom_speed, zoom_speed)
	zoom = clamp(new_zoom, Vector2(min_zoom, min_zoom), Vector2(max_zoom, max_zoom))

func clamp(value: Vector2, min_value: Vector2, max_value: Vector2) -> Vector2:
	return Vector2(
		clampf(value.x, min_value.x, max_value.x),
		clampf(value.y, min_value.y, max_value.y)
	)

func handle_zoom(event: InputEvent) -> void:	
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_WHEEL_UP:
			zoom_out()
		elif event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
			zoom_in()
