extends Node

const SPAWN_RADIUS = 375

@export var basic_enemy_scene: PackedScene
@export var wizard_enemy_scene: PackedScene
@export var arena_time_manager: ArenaTimeManager

@onready var timer: Timer = $Timer

var base_spawn_time = 0
var enemy_table = WeightedTable.new()

func _ready():
	enemy_table.add_item(basic_enemy_scene, 10)
	base_spawn_time = timer.wait_time
	timer.timeout.connect(on_timer_timeout)
	arena_time_manager.arena_difficulty_increased.connect(on_arena_difficulty_increased)


func get_spawn_position():
	var player = get_tree().get_first_node_in_group("player") as Node2D
	if (player == null):
		return Vector2.ZERO
	
	var number_of_rotation = 4
	var spawn_position = Vector2.ZERO
	var random_direction = Vector2.RIGHT.rotated(randf_range(0, TAU))
	
	for i in number_of_rotation:
		spawn_position = player.global_position + (random_direction * SPAWN_RADIUS)

		var physics_ray_query_parameters = PhysicsRayQueryParameters2D.create(
			player.global_position, spawn_position, 1)
		
		var intersect_ray_result = get_tree().root.world_2d.direct_space_state.intersect_ray(
			physics_ray_query_parameters)
		var does_it_not_intersect = intersect_ray_result.is_empty()
		
		if (does_it_not_intersect):
			break
		else:
			var ninety_degrees_in_rad = deg_to_rad(90)
			random_direction = random_direction.rotated(ninety_degrees_in_rad)
	
	return spawn_position


func on_timer_timeout():
	timer.start()
	
	var player = get_tree().get_first_node_in_group("player") as Node2D
	if (player == null):
		return
	
	#Cria inimigo
	var enemy_scene = enemy_table.pick_item()
	var enemy = enemy_scene.instantiate() as Node2D
	#Pega o nó pai, que nesse caso vai ser a main e adiciona um inimigo
	
	var entities_layer = get_tree().get_first_node_in_group("entities_layer")
	entities_layer.add_child(enemy)
	enemy.global_position = get_spawn_position()


func on_arena_difficulty_increased(arena_difficulty: int):
	var time_off = (.1 / 12) * arena_difficulty
	time_off = min(time_off, .7)
	timer.wait_time = base_spawn_time - time_off
	
	if (arena_difficulty == 6):
		print("entrou aqui >>>>>>>>>>>")
		enemy_table.add_item(wizard_enemy_scene, 20)
	

