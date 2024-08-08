extends Sprite2D

@onready var damage_timer: Timer = $DamageTimer
@onready var tower_fire: Sprite2D = $TowerFire

var enemy_list: Array[CharacterBody2D] = []

func _on_tower_area_body_entered(body: CharacterBody2D) -> void:
	if body.is_in_group("enemy"):
		if damage_timer.is_stopped():			
			damage_timer.start()
		enemy_list.push_back(body)

func _on_tower_area_body_exited(body: CharacterBody2D) -> void:
	if body.is_in_group("enemy"):
		var index = enemy_list.find(body)
		if index != -1:
			enemy_list.remove_at(index)
		
func _on_damage_timer_timeout() -> void:
	if enemy_list.size() > 0:
		var target_enemy = enemy_list[0]
		if is_instance_valid(target_enemy):
			tick_damage(target_enemy)

func tick_damage(enemy: CharacterBody2D):
	if enemy.has_method("take_damage"):
		run_fire_animation()
		enemy.take_damage(30)

func run_fire_animation():
	tower_fire.visible = true
	await get_tree().create_timer(0.3).timeout
	tower_fire.visible = false
