extends StaticBody2D

@export var item_resource: ItemResource

func _ready() -> void:
	if item_resource.conversation_resource:
		$Actionable.set("dialog_resource", item_resource.conversation_resource)
		$Actionable.set("dialog_title", item_resource.conversation_title)
	$Sprite2D.texture = item_resource.texture
	$Sprite2D.hframes = item_resource.hframes
	$Sprite2D.vframes = item_resource.vframes
	$Sprite2D.frame = item_resource.frame
