extends Node2D

@onready var progress_bar: ProgressBar = $ProgressBar

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	progress_bar.value =  get_parent().HEALTH

func _process(delta: float) -> void:
	progress_bar.value =  get_parent().HEALTH
