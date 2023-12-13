extends Node2D

var dialog_resource: DialogueResource
var dialog_title: String
var dialog_portrait: Texture2D

var balloon_node

func open_dialog_box() -> void:
	# Check if we have a dialog file
	if dialog_resource:
		# TODO: Pull conversation dialog control into its own script so that it doesn't activate in non conversational cases
		State.enable_cat_mode()
		balloon_node = show_dialogue_balloon(dialog_resource, dialog_title, dialog_portrait)

func close_dialog_box() -> void:
	if is_instance_valid(balloon_node):
		State.disable_cat_mode()
		balloon_node.close_balloon()

func show_dialogue_balloon(resource: DialogueResource, title: String, portrait: Texture2D, extra_game_states: Array = []) -> Node:
	var balloon = Balloons.conversation_bubble_scene.instantiate()
	self.add_child(balloon)
	balloon.start(resource, title, portrait, extra_game_states)
	return balloon
