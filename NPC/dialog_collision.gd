extends Area2D

@export var dialog_resource: DialogueResource
@export var dialog_start: String = "start"

var balloon_node

func open_dialog_box() -> void:
	balloon_node = DialogueManager.show_example_dialogue_balloon(dialog_resource, dialog_start)

func close_dialog_box() -> void:
	if is_instance_valid(balloon_node):
		balloon_node.queue_free()
