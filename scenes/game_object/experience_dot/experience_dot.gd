extends Node2D

@onready var area2D = $Area2D as Area2D

func _ready():
	area2D.area_entered.connect(on_area_entered)


func on_area_entered(other_area: Area2D):
	GameEvents.emit_experience_dot_collected(1)
	queue_free()
	
