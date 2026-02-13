extends Node2D

class_name UnitSelectionManager

var selected_units: Array[Unit] = []


func _ready() -> void:
	Events.on_strategy_change_request.connect(set_strategy_for_selected)


func _exit_tree() -> void:
	Events.on_strategy_change_request.disconnect(set_strategy_for_selected)


func _unhandled_input(event: InputEvent) -> void:
	var is_left_click: bool = event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT

	if not is_left_click:
		return

	var clicked_unit = _get_clicked_unit()

	if clicked_unit:
		_handle_unit_click(clicked_unit)
	else:
		clear_selection()


func _get_clicked_unit() -> Unit:
	var space_state = get_world_2d().direct_space_state
	var query = PhysicsPointQueryParameters2D.new()
	query.position = get_global_mouse_position()
	query.collide_with_areas = true
	query.collision_mask = 1
	var result = space_state.intersect_point(query)

	if result.size() > 0:
		var parent = result[0].collider.get_parent()
		if parent is Unit:
			return parent

	return null


func _handle_unit_click(unit: Unit) -> void:
	if Input.is_key_pressed(KEY_SHIFT):
		_toggle_unit_selection(unit)
	else:
		clear_selection()
		select_unit(unit)


func _toggle_unit_selection(unit: Unit) -> void:
	if unit in selected_units:
		unselect_unit(unit)
	else:
		select_unit(unit)


func select_unit(unit: Unit) -> void:
	if unit not in selected_units:
		selected_units.append(unit)
		unit.update_selection(true)
		unit.tree_exiting.connect(_on_unit_destroyed.bind(unit))


func unselect_unit(unit: Unit) -> void:
	if unit in selected_units:
		selected_units.erase(unit)
		unit.tree_exiting.disconnect(_on_unit_destroyed)
		unit.update_selection(false)


func clear_selection() -> void:
	for unit in selected_units:
		unit.tree_exiting.disconnect(_on_unit_destroyed)
		unit.update_selection(false)
	selected_units.clear()


func set_strategy_for_selected(strategy_type: StrategyComponent.StrategyType) -> void:
	for unit in selected_units:
		var strategy_component: StrategyComponent = unit.get_node_or_null("%StrategyComponent")
		if strategy_component:
			strategy_component.set_strategy(strategy_type)


func _on_unit_destroyed(unit: Unit) -> void:
	selected_units.erase(unit)
