extends Resource

class_name ItemResource

@export var id: int
@export var name: String

@export_group("Texture")
@export var is_sprite_visible: bool = false
@export var texture: Texture2D
@export var hframes: int = 6
@export var vframes: int = 4
@export var frame: int = 0

@export_group("Collision")
@export var is_collidable: bool = false
@export var collision_area_x: float = 14
@export var collision_area_y: float = 14

@export_group("Dialogue")
@export var conversation_resource: DialogueResource
@export var conversation_title: String = "start"
