extends Sprite2D

var support_unit_rid:RID

func _on_area_2d_body_entered(body:CharacterBody2D) -> void:
	# remove the target spawn_marker when the support unit reaches the target
	if is_instance_valid(body):
		if body.get_rid() == support_unit_rid:
			self.queue_free()