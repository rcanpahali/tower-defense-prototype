extends CharacterBody2D

const SPEED = 300.0
var HEALTH = 100

var enemies: Array[CharacterBody2D] = []

func _physics_process(delta: float) -> void:
	if enemies.size() > 0:
		move_to_enemy(delta)
		
func move_to_enemy(delta: float):
	var direction = self.global_position.direction_to(enemies[0].global_position)
	velocity = direction * SPEED
	move_and_slide()	

func _on_area_2d_body_entered(body: CharacterBody2D) -> void:
	if body.is_in_group("enemy"):
		enemies.push_back(body)

func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.is_in_group("enemy"):
		var remove_at = enemies.find(body)
		if remove_at != -1:
			enemies.remove_at(remove_at)
