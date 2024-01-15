extends CharacterBody2D

class_name Player

const MAX_SPEED = 125
const ACCELERATION_SMOOTHING = 25

@onready var damage_interval_timer: Timer = $DamageIntervalTimer
@onready var health_component: HealthComponent = $HealthComponent
@onready var collision_area: Area2D = $CollisionArea2D
@onready var progress_bar: ProgressBar = $HealthBar
@onready var abilities: Node = $Abilities
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var visuals: Node2D = $Visuals

var number_colliding_bodies = 0


func _ready():
	collision_area.body_entered.connect(on_body_entered)
	collision_area.body_exited.connect(on_body_exited)
	damage_interval_timer.timeout.connect(on_damage_interval_timer_timout)
	health_component.health_changed.connect(on_health_changed)
	GameEvents.ability_upgrades_added.connect(on_ability_upgrade_added)
	update_health_display()


func _process(delta):
	var movement_vector = get_movement_vector()
	var direction = movement_vector.normalized()
	var target_velocity = direction * MAX_SPEED
	
	velocity = velocity.lerp(target_velocity, 1 - exp(-delta * ACCELERATION_SMOOTHING))
	
	move_and_slide()
	
	#if(movement_vector.x != 0 || movement_vector.y != 0):
		#animation_player.play("walk")
	#else:
		#animation_player.play("RESET")
	animation_player.play("RESET")
	
	var move_sign = sign(movement_vector.x)
	if (Input.is_action_just_pressed("move_left")):
		visuals.scale = Vector2(-1, 1)
	if (Input.is_action_just_pressed("move_right")):
		visuals.scale = Vector2.ONE


func get_movement_vector():
	var x_movement = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	var y_movement = Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
	
	return Vector2(x_movement, y_movement)


func check_deal_damage():
	if (number_colliding_bodies == 0 || !damage_interval_timer.is_stopped()):
		return
	
	health_component.damage(1)
	damage_interval_timer.start()
	print(health_component.current_health)


func update_health_display():
	progress_bar.value = health_component.get_health_percente()
	


func on_ability_upgrade_added(upgrade: AbilityUpgrade, current_upgrades: Dictionary):
	if not upgrade is Ability:
		return
	
	var ability = upgrade as Ability
	abilities.add_child(ability.ability_controller_scene.instantiate())


func on_body_entered(other_body: Node2D):
	number_colliding_bodies += 1
	check_deal_damage()


func on_body_exited(ohter_body: Node2D):
	number_colliding_bodies -= 1


func on_damage_interval_timer_timout():
	check_deal_damage()


func on_health_changed():
	update_health_display()
