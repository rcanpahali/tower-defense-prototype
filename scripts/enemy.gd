extends CharacterBody2D

const SPEED = 150.0
const DAMAGE = 50.0
var HEALTH = 1500

@onready var tower: CollisionShape2D = get_tree().get_first_node_in_group("tower")
@onready var damage_timer: Timer = $DamageTimer

var target_position: Vector2 = Vector2.ZERO 

# the below lists may be improved by using only one dictionary e.g. Dict[CharacterBody2D, inRange: fasle]
var moving_targets: Array[CharacterBody2D] = []
var hitbox_targets : Array[CharacterBody2D] = []

func _ready() -> void:
	target_position = tower.global_position

func _process(_delta: float) -> void:
	if moving_targets.size() > 0: # always attack the closest support unit
		if damage_timer.is_stopped():
			damage_timer.start()
		target_position = moving_targets[0].global_position

func _physics_process(delta: float) -> void:
	move_to_target(delta)

func move_to_target(_delta: float):
	if self.global_position.distance_to(target_position) > 100:
		var direction = self.global_position.direction_to(target_position)
		velocity = direction * SPEED
		move_and_slide()

func _on_area_2d_body_entered(body: CharacterBody2D) -> void:
	if body.is_in_group("support"):
		moving_targets.push_back(body)

func _on_area_2d_body_exited(body: CharacterBody2D) -> void:
	if body.is_in_group("support"):
		var remove_at = moving_targets.find(body)
		if remove_at != -1:
			moving_targets.remove_at(remove_at)
			if moving_targets.size() == 0:
				damage_timer.stop()
				target_position = tower.global_position # start moving forward to tower

func take_damage(damage: float):
	HEALTH = HEALTH - damage
	if HEALTH < 0:
		self.queue_free()

############# ATTACK TO SUPPORT UNITS #############

func _on_damage_timer_timeout() -> void:
	if hitbox_targets.size() > 0:
		var hitbox_target = hitbox_targets[0]
		if is_instance_valid(hitbox_target):
			tick_damage(hitbox_target)

func tick_damage(hitbox_target: CharacterBody2D):
	if hitbox_target.has_method("take_damage"):
		hitbox_target.take_damage(DAMAGE)

func _on_hit_box_body_entered(body: CharacterBody2D) -> void:
	if body.is_in_group("support"):
		hitbox_targets.push_back(body)

func _on_hit_box_body_exited(body: CharacterBody2D) -> void:
	if body.is_in_group("support"):
		var remove_at = hitbox_targets.find(body)
		if remove_at != -1:
			hitbox_targets.remove_at(remove_at)
