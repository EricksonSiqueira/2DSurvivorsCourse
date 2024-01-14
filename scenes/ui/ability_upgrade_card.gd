extends PanelContainer

class_name AbilityUpgradeCard

@onready var name_label: Label = $%NameLabel
@onready var description_label: Label = $%DescriptionLabel

func set_ability_upgrade(upgrade: AbilityUpgrade):
	name_label.text = upgrade.resource_name
	description_label.text = upgrade.description


