extends StaticBody2D

signal item_destroyed

@export var item_resource: ItemResource

var id: int

func _ready() -> void:
	id = item_resource.id
	if item_resource.conversation_resource:
		$Actionable.set("dialog_resource", item_resource.conversation_resource)
		$Actionable.set("dialog_title", item_resource.conversation_title)
	if !item_resource.is_collidable:
		$CollisionShape2D.disabled = true
	if !item_resource.is_sprite_visible:
		$Sprite2D.visible = false
	$Sprite2D.texture = item_resource.texture
	$Sprite2D.hframes = item_resource.hframes
	$Sprite2D.vframes = item_resource.vframes
	$Sprite2D.frame = item_resource.frame
	
	State.item_destroyed.connect(destroy)

func destroy(item_id: int):
	if item_id == id:
		print("destroyed")
		self.queue_free()
