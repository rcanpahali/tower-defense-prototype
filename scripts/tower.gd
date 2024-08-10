extends Sprite2D

@onready var damage_timer: Timer = $DamageTimer
@onready var tower_fire: Sprite2D = $TowerFire
@onready var progress_bar: ProgressBar = $ProgressBar

var enemy_list: Array[CharacterBody2D] = []

const DAMAGE = 200.0
const SELF_DAMAGE = 100.0
var HEALTH = 10000.0

var attacking_enemies_list: Array[CharacterBody2D] = []

func _ready() -> void:
	progress_bar.max_value = HEALTH
	progress_bar.value = HEALTH

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
	# calculate self damage
	if attacking_enemies_list.size() > 0:		
		take_self_damage()

func tick_damage(enemy: CharacterBody2D):
	if enemy.has_method("take_damage"):
		run_fire_animation()
		enemy.take_damage(DAMAGE)

func run_fire_animation():
	tower_fire.visible = true
	await get_tree().create_timer(0.3).timeout
	tower_fire.visible = false

########## TAKE DAMAGE ##########

func _on_hurt_box_body_entered(body:CharacterBody2D) -> void:
	if body.is_in_group("enemy"):
		attacking_enemies_list.push_back(body)

func _on_hurt_box_body_exited(body:Node2D) -> void:
	if body.is_in_group("enemy"):
		var index = attacking_enemies_list.find(body)
		if index != -1:
			attacking_enemies_list.remove_at(index)

func take_self_damage():			
	HEALTH = HEALTH - (SELF_DAMAGE * attacking_enemies_list.size())
	progress_bar.value = HEALTH
	if HEALTH < 0:
		self.queue_free()
		get_tree().paused = true