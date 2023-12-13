@tool
extends CharacterBody2D

@export var npc_resource: NPCResource

func _ready() -> void:
	if npc_resource.gossip_resource:
		$Gossip.set("dialog_resource", npc_resource.gossip_resource)
		$Gossip.set("dialog_title", npc_resource.gossip_title)
	if npc_resource.conversation_resource:
		$Conversation.set("dialog_resource", npc_resource.conversation_resource)
		$Conversation.set("dialog_title", npc_resource.conversation_title)
		if npc_resource.portrait:
			$Conversation.set("dialog_portrait", npc_resource.portrait)
	$Sprite2D.texture = npc_resource.texture
	$Sprite2D.hframes = npc_resource.hframes
	$Sprite2D.vframes = npc_resource.vframes
	$Sprite2D.frame = npc_resource.frame
