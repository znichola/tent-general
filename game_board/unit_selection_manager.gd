extends Node2D

class_name UnitSelectionManager

var selected_units: Array[Unit] = []


func _ready() -> void:
	Events.on_strategy_change_request.connect(set_strategy_for_selected)


func _exit_tree() -> void:
	Events.on_strategy_change_request.disconnect(set_strategy_for_selected)


func _unhandled_input(event: InputEvent) -> void:
	var is_left_click: bool = event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT
	var is_right_click: bool = event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_RIGHT

	if is_left_click:
		var clicked_unit = _get_clicked_unit()

		if clicked_unit:
			_handle_unit_click(clicked_unit)
		else:
			clear_selection()
	elif is_right_click and selected_units.size() > 0:
		_handle_move_command()


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


func set_strategy_for_selected(strategy_type: StrategyComponent.StrategyType, target_position: Vector2 = Vector2.ZERO, target_unit: Unit = null) -> void:
	for unit in selected_units:
		var strategy_component: StrategyComponent = unit.get_node_or_null("%StrategyComponent")
		if strategy_component:
			strategy_component.set_strategy(strategy_type, target_position, target_unit)


func _handle_move_command() -> void:
	var clicked_unit = _get_clicked_unit()

	if clicked_unit and selected_units.size() > 0:
		var first_selected = selected_units[0]
		if not first_selected.is_valid_target(clicked_unit):
			# Clicked on friendly unit, just move to position
			var target_position = get_global_mouse_position()
			set_strategy_for_selected(StrategyComponent.StrategyType.MOVE, target_position, null)
		else:
			# Clicked on enemy unit, attack it
			set_strategy_for_selected(StrategyComponent.StrategyType.ATTACK_TARGET, Vector2.ZERO, clicked_unit)
	else:
		# Clicked on ground, move to position
		var target_position = get_global_mouse_position()
		set_strategy_for_selected(StrategyComponent.StrategyType.MOVE, target_position, null)


func _on_unit_destroyed(unit: Unit) -> void:
	selected_units.erase(unit)
