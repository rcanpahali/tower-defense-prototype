extends Node2D

@onready var progress_bar: ProgressBar = $ProgressBar
@export var background_color: Color

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	progress_bar.self_modulate = background_color
	progress_bar.value =  get_parent().HEALTH
	progress_bar.max_value =  get_parent().HEALTH

func _process(delta: float) -> void:
	progress_bar.value =  get_parent().HEALTH
