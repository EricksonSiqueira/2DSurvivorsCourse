extends Node

signal experience_dot_collected(number: float)

func emit_experience_dot_collected(number: float):
	experience_dot_collected.emit(number)
