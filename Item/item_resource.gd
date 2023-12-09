extends Resource

class_name ItemResource

@export var id: int
@export var is_collidable: bool = false
@export var is_sprite_visible: bool = false

@export_group("Texture")
@export var name: String
@export var texture: Texture2D
@export var hframes: int = 6
@export var vframes: int = 4
@export var frame: int = 0

@export_group("Dialogue")
@export var conversation_resource: DialogueResource
@export var conversation_title: String = "start"
