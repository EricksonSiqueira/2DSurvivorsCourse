extends Node2D

@export var health_component: HealthComponent
@export var sprite: Sprite2D

@onready var gpu_particles_2: GPUParticles2D = $GPUParticles2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _ready():
	health_component.died.connect(on_died)
	gpu_particles_2.texture = sprite.texture


func on_died():
	if (owner == null || not owner is Node2D):
		return null
	
	var spawn_position = owner.global_position
	
	var entities_layer = get_tree().get_first_node_in_group("entities_layer")
	get_parent().remove_child(self)
	entities_layer.add_child(self)
	global_position = spawn_position
	animation_player.play("default")
