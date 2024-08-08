extends Sprite2D

var support_unit_instance_id

func _ready():
	print("TargetMark is ready", support_unit_instance_id)

func _on_area_2d_body_entered(body:CharacterBody2D) -> void:
	# TODO: fixme => instance id is not matching
	print(body.get_instance_id())
	if body.get_instance_id() == support_unit_instance_id:
		queue_free()
