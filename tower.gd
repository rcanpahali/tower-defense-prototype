extends Sprite2D

@onready var hit_timer: Timer = $HitTimer

var enemy_list: Array[CharacterBody2D] = []

func _on_tower_area_body_entered(body: CharacterBody2D) -> void:
	if body.is_in_group("enemy"):
		if hit_timer.is_stopped():
			hit_timer.start()
		enemy_list.push_back(body)

func _on_tower_area_body_exited(body: CharacterBody2D) -> void:
	var index = enemy_list.find(body)
	if index != -1:
		enemy_list.remove_at(index)
		
func _on_hit_timer_timeout() -> void:
	if enemy_list.size() > 0:
		var target_enemy = enemy_list[0]
		if is_instance_valid(target_enemy):
			tick_damage(target_enemy)

func tick_damage(enemy: CharacterBody2D):
	if enemy.has_method("take_damage"):
		enemy.take_damage(30)
