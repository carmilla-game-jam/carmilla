extends Resource

class_name NPCResource

@export var texture: Texture2D
@export var hframes: int = 8
@export var vframes: int = 19
@export var frame: int = 0

@export var gossip_resource: DialogueResource
@export var gossip_title: String = "start"

@export var conversation_resource: DialogueResource
@export var conversation_title: String = "start"
