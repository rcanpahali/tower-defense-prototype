extends Node2D

@export var gate_name: String
@onready var label: Label = $Label

func _ready():
	label.text = gate_name
	