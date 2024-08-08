extends Node2D

@export var background_color: Color

@onready var parent_character = get_parent()
@onready var progress_bar: ProgressBar = $ProgressBar
@onready var attack_indicator: Sprite2D = $AttackIndicator


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	progress_bar.self_modulate = background_color
	progress_bar.value =  parent_character.HEALTH
	progress_bar.max_value =  parent_character.HEALTH

func _process(_delta: float) -> void:
	attack_indicator.visible = !parent_character.damage_timer.is_stopped()
	progress_bar.value =  parent_character.HEALTH
