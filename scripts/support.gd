extends CharacterBody2D

@onready var damage_timer: Timer = $DamageTimer

const SPEED = 250.0
const DAMAGE = 50.0
var HEALTH = 1000

var moving_enemies: Array[CharacterBody2D] = []
var hitbox_targets : Array[CharacterBody2D] = []

func _physics_process(delta: float) -> void:
	if moving_enemies.size() > 0: #always attack the closest enemy unit
		move_to_enemy(delta)
		if damage_timer.is_stopped():
			damage_timer.start()
		
func move_to_enemy(delta: float):
	var direction = self.global_position.direction_to(moving_enemies[0].global_position)
	velocity = direction * SPEED
	move_and_slide()	

func _on_area_2d_body_entered(body: CharacterBody2D) -> void:
	if body.is_in_group("enemy"):
		moving_enemies.push_back(body)

func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.is_in_group("enemy"):
		var remove_at = moving_enemies.find(body)
		if remove_at != -1:
			moving_enemies.remove_at(remove_at)
			if moving_enemies.size() == 0:
				damage_timer.stop()

func take_damage(damage: float):
	HEALTH = HEALTH - damage
	if HEALTH < 0:
		self.queue_free()

############# ATTACK TO ENEMY UNITS #############

func _on_damage_timer_timeout() -> void:
	if hitbox_targets.size() > 0:
		var hitbox_target = hitbox_targets[0]
		if is_instance_valid(hitbox_target):
			tick_damage(hitbox_target)

func tick_damage(hitbox_target: CharacterBody2D):
	if hitbox_target.has_method("take_damage"):
		hitbox_target.take_damage(50.0)

func _on_hit_box_body_entered(body: CharacterBody2D) -> void:
	if body.is_in_group("enemy"):
		hitbox_targets.push_back(body)

func _on_hit_box_body_exited(body: CharacterBody2D) -> void:
	if body.is_in_group("enemy"):
		var remove_at = hitbox_targets.find(body)
		if remove_at != -1:
			hitbox_targets.remove_at(remove_at)
