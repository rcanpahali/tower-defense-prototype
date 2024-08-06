extends CharacterBody2D

const SPEED = 300.0
var HEALTH = 100

@onready var tower: CollisionShape2D = get_tree().get_first_node_in_group("tower")

func _ready() -> void:
	print(tower)

func _physics_process(delta: float) -> void:
	move_to_tower(delta)

func move_to_tower(delta: float):
	var direction = self.global_position.direction_to(tower.global_position)
	velocity = direction * SPEED
	move_and_slide()
	if self.global_position.distance_to(tower.global_position) < 300:
		set_physics_process(false)

func take_damage(damage: float):
	HEALTH = HEALTH - damage
	if HEALTH < 0:
		self.queue_free()
