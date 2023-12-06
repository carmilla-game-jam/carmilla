extends Node2D

var dialog_resource: DialogueResource
var dialog_start: String

var balloon_node

func open_dialog_box() -> void:
	print("collided opened")

	# Check if we have a dialog file
	print(dialog_resource)
	if dialog_resource:
		balloon_node = DialogueManager.show_example_dialogue_balloon(dialog_resource, dialog_start)

func close_dialog_box() -> void:
	if is_instance_valid(balloon_node):
		balloon_node.queue_free()

func show_dialogue_balloon(resource: DialogueResource, title: String = "", valid_positions: Array[Marker2D] = [], extra_game_states: Array = []) -> Node:
	var balloon = Balloons.conversation_bubble_scene.instantiate()
	self.add_child(balloon)
	balloon.start(resource, title, valid_positions, extra_game_states)
	return balloon
