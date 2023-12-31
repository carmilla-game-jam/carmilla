extends Node2D

var dialog_resource: DialogueResource
var dialog_title: String

var balloon_node

func area_entered() -> void:
	open_dialog_box()

func area_exited() -> void:
	close_dialog_box()

func open_dialog_box() -> void:
	# Check if we have a dialog file
	if dialog_resource:
		balloon_node = show_dialogue_balloon(dialog_resource, dialog_title, [$GossipBubbleUpMarker2D, $GossipBubbleDownMarker2D])

func close_dialog_box() -> void:
	if is_instance_valid(balloon_node):
		balloon_node.queue_free()

func show_dialogue_balloon(resource: DialogueResource, title: String = "", valid_positions: Array[Marker2D] = [], extra_game_states: Array = []) -> Node:
	var balloon = Balloons.gossip_bubble_scene.instantiate()
	self.add_child(balloon)
	balloon.start(resource, title, valid_positions, extra_game_states)
	return balloon
