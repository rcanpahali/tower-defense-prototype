extends Node2D

const ENEMY = preload("res://enemy.tscn")
const SUPPORT = preload("res://support.tscn")

@onready var WORLD = get_tree().get_first_node_in_group("world")

@onready var support_button: Button = $CanvasLayer/Deployment/SupportButton
@onready var enemy_button: Button = $CanvasLayer/Deployment/EnemyButton
@onready var label: Label = $CanvasLayer/Deployment/Label

@export_enum("enemy", "support") var deployment_type = ""

func _process(delta: float) -> void:
	if deployment_type == "support":
		label.text = "Deploy Support Units"
	elif deployment_type == "enemy":
		label.text = "Deploy Enemy Units"
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
		new_support.global_position = get_global_mouse_position()
		WORLD.add_child(new_support)
