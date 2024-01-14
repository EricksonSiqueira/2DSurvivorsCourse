extends Node

signal experience_dot_collected(number: float)
signal ability_upgrades_added(upgrade: AbilityUpgrade, current_upgrades: Dictionary)

func emit_experience_dot_collected(number: float):
	experience_dot_collected.emit(number)


func emit_ability_upgrades_added(upgrade: AbilityUpgrade, current_upgrades: Dictionary):
	ability_upgrades_added.emit(upgrade, current_upgrades)
