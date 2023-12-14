extends MarginContainer


# On click or tab toggle visibility
func _unhandled_input(event):
	if event.is_action_pressed("instructions_toggle"):
		self.visible = !self.visible
