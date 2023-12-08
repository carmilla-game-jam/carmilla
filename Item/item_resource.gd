extends Resource

class_name ItemResource

@export var texture: Texture2D
@export var hframes: int = 6
@export var vframes: int = 4
@export var frame: int = 0

@export var is_collidable: bool = false
@export var is_sprite_visible: bool = false

@export var conversation_resource: DialogueResource
@export var conversation_title: String = "start"
