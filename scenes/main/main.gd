extends Node

@export var end_screen_scene: PackedScene 

@onready var player: Player = $%Player

func _ready():
	player.health_component.died.connect(on_player_died)


func on_player_died():
	var end_screen_instance = end_screen_scene.instantiate() as EndScene
	add_child(end_screen_instance)
	end_screen_instance.set_defeat()
