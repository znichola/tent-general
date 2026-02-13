@tool
extends Polygon2D

class_name Markers

@export_group("References")
@export var sigil: Polygon2D


func _ready() -> void:
	_update_color()


func _notification(what: int) -> void:
	if Engine.is_editor_hint() and what == NOTIFICATION_EDITOR_PRE_SAVE:
		_update_color()


func _update_color() -> void:
	var parent = get_parent()
	if not parent:
		return

	if parent is Unit:
		var team_color: Color = Unit.TEAM_COLORS.get(parent.team_name, Color.HOT_PINK)
		color = team_color

		# Set sigil to a darker shade
		if sigil:
			sigil.color = team_color.darkened(0.2)
