extends Node2D

@export var dialog_resource: DialogueResource
@export var dialog_start: String = "start"

var balloon_node

func open_dialog_box() -> void:
	print("collided opened")
	balloon_node = show_dialogue_balloon(dialog_resource, dialog_start, [$GossipBubbleUpMarker2D, $GossipBubbleDownMarker2D])

func close_dialog_box() -> void:
	if is_instance_valid(balloon_node):
		balloon_node.queue_free()

func show_dialogue_balloon(resource: DialogueResource, title: String = "", valid_positions: Array[Marker2D] = [], extra_game_states: Array = []) -> Node:
	var balloon = Balloons.gossip_bubble_scene.instantiate()
	self.add_child(balloon)
	balloon.start(resource, title, valid_positions, extra_game_states)
	return balloon
