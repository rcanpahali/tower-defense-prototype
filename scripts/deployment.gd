extends Node2D

const ENEMY = preload("res://scenes/enemy.tscn")
const SUPPORT = preload("res://scenes/support.tscn")
const SPAWN_MARKER = preload("res://scenes/spawn_marker.tscn")

@onready var WORLD = get_tree().get_first_node_in_group("world")
@onready var GAME_CAMERA = get_tree().get_first_node_in_group("camera")

@onready var label: Label = $CanvasLayer/Label
@onready var support_button: Button = $CanvasLayer/SupportButton
@onready var enemy_button: Button = $CanvasLayer/EnemyButton

@export_enum("enemy", "support") var deployment_type = ""

var support_spawn_position: Vector2 = Vector2.ZERO

func _process(_delta: float) -> void:
	if deployment_type == "support":
		label.text = "Deploy Support"
	elif deployment_type == "enemy":
		label.text = "Deploy Enemy"
	else:
		label.text = ""

func _on_support_button_pressed() -> void:
	if deployment_type != "support":
		deployment_type = "support"
	else:
		deployment_type = ""

func _on_enemy_button_pressed() -> void:
	if deployment_type != "enemy":
		deployment_type = "enemy"
	else:
		deployment_type = ""

func _unhandled_input(event: InputEvent) -> void:
		if event is InputEventMouseButton:
			if event.button_index == 1 && event.button_mask == 1:
				handle_deployment()

func handle_deployment():
	if deployment_type == "enemy":
		var new_enemy = ENEMY.instantiate()
		new_enemy.global_position = get_global_mouse_position()
		WORLD.add_child(new_enemy)
	if deployment_type == "support":
		var new_support = SUPPORT.instantiate()		
		new_support.global_position = support_spawn_position		
		var new_spawn_marker = create_spawn_marker(new_support.get_rid())	
		new_support.spawn_marker = new_spawn_marker
		WORLD.add_child(new_support)

func create_spawn_marker(support_unit_rid:RID):
	var spawn_marker = SPAWN_MARKER.instantiate()	
	spawn_marker.support_unit_rid = support_unit_rid
	spawn_marker.global_position = get_global_mouse_position()	
	WORLD.add_child(spawn_marker)
	return spawn_marker


func _on_option_button_item_selected(index:int) -> void:
	if index == 0:
		var castle_global_position = get_tree().get_first_node_in_group("castle").global_position
		support_spawn_position = castle_global_position
		GAME_CAMERA.global_position = castle_global_position
	if index == 1:
		var north_gate_global_position = get_tree().get_first_node_in_group("north_gate").global_position
		support_spawn_position = north_gate_global_position
		GAME_CAMERA.global_position = north_gate_global_position
	if index == 2:
		var south_gate_global_position = get_tree().get_first_node_in_group("south_gate").global_position
		support_spawn_position = south_gate_global_position	
		GAME_CAMERA.global_position = south_gate_global_position