extends OptionButton


# calls the parent to set the parameter
func _on_self_item_selected(index: int) -> void:
	(get_parent() as Parameter).set_param(index)
