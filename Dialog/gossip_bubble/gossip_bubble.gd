extends Control


@onready var camera: Camera2D = get_node("/root/Camera")
@onready var balloon: MarginContainer = %Balloon
@onready var balloon_bg: NinePatchRect = %BalloonBG
@onready var dialogue_label: DialogueLabel = %DialogueLabel

## The dialogue resource
var resource: DialogueResource

## Potential balloon positions
var balloon_positions: Array[Marker2D] = []

## Temporary game states
var temporary_game_states: Array = []

## See if we are waiting for the player
var is_waiting_for_input: bool = false

## See if we are running a long mutation and should hide the balloon
var will_hide_balloon: bool = false

## The current line
var dialogue_line: DialogueLine:
	set(next_dialogue_line):
		is_waiting_for_input = false

		# The dialogue has finished so close the balloon
		if not next_dialogue_line:
			queue_free()
			return

		dialogue_line = next_dialogue_line

		dialogue_label.hide()
		dialogue_label.dialogue_line = dialogue_line

		# Find best position for this balloon
		set_balloon_position(find_valid_balloon_positions(balloon_positions)[0])

		# Show our balloon
		balloon.show()
		will_hide_balloon = false

		dialogue_label.show()
		if not dialogue_line.text.is_empty():
			dialogue_label.type_out()
			await dialogue_label.finished_typing

		# Wait for input
		if dialogue_line.time != "":
			var time = dialogue_line.text.length() * 0.02 if dialogue_line.time == "auto" else dialogue_line.time.to_float()
			await get_tree().create_timer(time).timeout
			next(dialogue_line.next_id)
		else:
			is_waiting_for_input = true
			balloon.focus_mode = Control.FOCUS_ALL
			balloon.grab_focus()
	get:
		return dialogue_line


func _ready() -> void:
	balloon.hide()
	Engine.get_singleton("DialogueManager").mutated.connect(_on_mutated)


# func _unhandled_input(_event: InputEvent) -> void:
	# Only the balloon is allowed to handle input while it's showing
	# get_viewport().set_input_as_handled()


## Start some dialogue
func start(dialogue_resource: DialogueResource, title: String, potential_positions: Array[Marker2D] = [], extra_game_states: Array = []) -> void:
	temporary_game_states =  [self] + extra_game_states
	is_waiting_for_input = false
	resource = dialogue_resource
	balloon_positions = potential_positions
	self.dialogue_line = await resource.get_next_dialogue_line(title, temporary_game_states)


## Go to the next line
func next(next_id: String) -> void:
	self.dialogue_line = await resource.get_next_dialogue_line(next_id, temporary_game_states)


### Helpers

# Returns a list of valid positions for the balloon to be so that it doesn't fall out of the viewport
func find_valid_balloon_positions(potential_positions: Array[Marker2D]) -> Array[Dictionary]:
	var valid_positions: Array[Dictionary]
	
	# var current_top_left = self.get_rect().position
	# var current_bottom_right = self.get_rect().end
	# print(self.position)
	var new_balloon_position_top = self.position + potential_positions[0].global_position
	var new_balloon_position_bottom = self.position + potential_positions[1].global_position

	var top_left_position = new_balloon_position_top
	var top_right_position = Vector2(new_balloon_position_top.x + (-self.position.x), new_balloon_position_top.y)
	var bottom_left_position = Vector2(new_balloon_position_bottom.x, new_balloon_position_bottom.y + (-self.position.y))
	var bottom_right_position = Vector2(new_balloon_position_bottom.x + (-self.position.x), new_balloon_position_bottom.y + (-self.position.y))

	# TODO: refactor to extend from the position variables above
	var top_left_corner = new_balloon_position_top
	var top_right_corner = Vector2(new_balloon_position_top.x + 2*(-self.position.x), new_balloon_position_top.y)
	var bottom_left_corner = Vector2(new_balloon_position_bottom.x, new_balloon_position_bottom.y + 2*(-self.position.y))
	var bottom_right_corner = Vector2(new_balloon_position_bottom.x + 2*(-self.position.x), new_balloon_position_bottom.y + 2*(-self.position.y))

	# print("top left ", top_left_position, " ", top_left_corner)
	# print("top right ", top_right_position, " ", top_right_corner)
	# print("bottom left ", bottom_left_position, " ", bottom_left_corner)
	# print("bottom right ", bottom_right_position, " ", bottom_right_corner)
	
	var top_left_metadata = {
		"texture": "res://assets/ui/speech_bubble_top_left.png",
		"grow_direction": GROW_DIRECTION_BEGIN,
		"position": top_left_position,
	}
	var top_right_metadata = {
		"texture": "res://assets/ui/speech_bubble_top_right.png",
		"grow_direction": GROW_DIRECTION_BEGIN,
		"position": top_right_position,
	}
	var bottom_left_metadata = {
		"texture": "res://assets/ui/speech_bubble_bottom_left.png",
		"grow_direction": GROW_DIRECTION_END,
		"position": bottom_left_position,
	}
	var bottom_right_metadata = {
		"texture": "res://assets/ui/speech_bubble_bottom_right.png",
		"grow_direction": GROW_DIRECTION_END,
		"position": bottom_right_position,
	}
	
	if is_position_valid(top_left_corner):
		valid_positions.append(top_left_metadata)
	if is_position_valid(top_right_corner):
		valid_positions.append(top_right_metadata)
	if is_position_valid(bottom_left_corner):
		valid_positions.append(bottom_left_metadata)
	if is_position_valid(bottom_right_corner):
		valid_positions.append(bottom_right_metadata)

	# print(valid_positions)
	return valid_positions


## Check if position falls within the viewport
func is_position_valid(global_position: Vector2) -> bool:
	# TODO: Viewport size will change when scaling the window, don't rely on it
	var camera_rect = Rect2(Vector2(camera.get_screen_center_position() - Vector2(get_viewport().size/2)), get_viewport().size)
	return camera_rect.has_point(global_position)


## Takes a dict with scale data and a position and sets the balloon to that location
func set_balloon_position(global_position: Dictionary) -> void:
	balloon.grow_vertical = global_position["grow_direction"]
	balloon_bg.texture = load(global_position["texture"])
	self.set_global_position(global_position["position"])


### Signals

func _on_mutated(_mutation: Dictionary) -> void:
	is_waiting_for_input = false
	will_hide_balloon = true
	get_tree().create_timer(0.1).timeout.connect(func():
		if will_hide_balloon:
			will_hide_balloon = false
			balloon.hide()
	)
