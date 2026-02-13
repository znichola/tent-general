extends Node2D

class_name Unit

enum TeamName {
	YELLOW,
	GREEN,
}

const TEAM_COLORS = {
	TeamName.YELLOW: Color("#D5A04C"),
	TeamName.GREEN: Color("#127c57"),
}

@export var team_name: TeamName = TeamName.YELLOW

@export_group("References")
@export var selection_sprite: Polygon2D = null


func _ready() -> void:
	selection_sprite.visible = false


func update_selection(selected: bool) -> void:
	selection_sprite.visible = selected


func is_valid_target(target: Unit) -> bool:
	if not target:
		return false

	if target.team_name == team_name:
		return false

	# Add other validation checks here later

	return true


func get_team_color() -> Color:
	return TEAM_COLORS.get(team_name, Color.WHITE)
