extends Control


@export var dialog_resource: DialogueResource
@export var dialog_title: String
@export var next_scene: String

var balloon_node
var current_scene
# Called when the node enters the scene tree for the first time.
func _ready():
	current_scene = Cutscenes.transitioning_target_scene
	dialog_resource = Cutscenes.dialog_resource
	if Cutscenes.scenes[current_scene].has("dialog_title"):
		dialog_title = Cutscenes.scenes[current_scene]["dialog_title"]
	if Cutscenes.scenes[current_scene].has("next_scene"):
		next_scene = Cutscenes.scenes[current_scene]["next_scene"]["name"]
	$Background.texture = load(Cutscenes.scenes[current_scene]["bg"])

	if Cutscenes.scenes[current_scene]["dialog_title"]:
		balloon_node = show_dialogue_balloon(dialog_resource, dialog_title, null)

func show_dialogue_balloon(resource: DialogueResource, title: String, portrait: Texture2D, extra_game_states: Array = []) -> Node:
	var balloon = Balloons.conversation_bubble_scene.instantiate()
	self.add_child(balloon)
	balloon.start(resource, title, portrait, extra_game_states)
	return balloon
	
func _unhandled_input(event):
	# TODO: Fix input handler. Mouse click isn't working to progress to the next scene
	if next_scene && (event.is_action_pressed("ui_accept") || event is InputEventMouseButton && event.is_pressed() && event.button_index == 1):
		Cutscenes.transitioning_target_scene = next_scene
		SceneTransition.change_scene(Cutscenes.scenes[current_scene]["next_scene"]["scene_path"])
