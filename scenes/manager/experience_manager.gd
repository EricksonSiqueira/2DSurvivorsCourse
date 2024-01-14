extends Node

var current_exp = 0

func _ready():
	GameEvents.experience_dot_collected.connect(on_experience_dot_collected)
	

func increment_experience(number: float):
	current_exp += number
	print(current_exp)

func on_experience_dot_collected(number: float):
	increment_experience(number)