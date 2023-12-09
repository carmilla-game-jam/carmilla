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
	var collision_shape = RectangleShape2D.new()
	collision_shape.size.x = item_resource.collision_area_x
	collision_shape.size.y = item_resource.collision_area_y
	$CollisionShape2D.shape = collision_shape
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
