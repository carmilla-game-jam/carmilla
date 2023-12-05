extends MarginContainer


@onready var balloon: NinePatchRect = %Balloon
@onready var character_label: RichTextLabel = %CharacterLabel
@onready var dialogue_label: DialogueLabel = %DialogueLabel
@onready var responses_menu: DialogueResponsesMenu = %ResponsesMenu

## The dialogue resource
var resource: DialogueResource

## Valid balloon positions
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

		character_label.visible = not dialogue_line.character.is_empty()
		character_label.text = tr(dialogue_line.character, "dialogue")

		dialogue_label.hide()
		dialogue_label.dialogue_line = dialogue_line

		responses_menu.hide()
		responses_menu.set_responses(dialogue_line.responses)

		# Show our balloon
		balloon.show()
		will_hide_balloon = false

		dialogue_label.show()
		if not dialogue_line.text.is_empty():
			dialogue_label.type_out()
			await dialogue_label.finished_typing

		# Wait for input
		if dialogue_line.responses.size() > 0:
			balloon.focus_mode = Control.FOCUS_NONE
			responses_menu.show()
		elif dialogue_line.time != "":
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


func _unhandled_input(_event: InputEvent) -> void:
	# Only the balloon is allowed to handle input while it's showing
	get_viewport().set_input_as_handled()


## Start some dialogue
func start(dialogue_resource: DialogueResource, title: String, potential_positions: Array[Marker2D] = [], extra_game_states: Array = []) -> void:
	temporary_game_states =  [self] + extra_game_states
	is_waiting_for_input = false
	resource = dialogue_resource
	balloon_positions = potential_positions
	set_balloon_position(find_valid_balloon_positions(balloon_positions).pick_random())
	$Balloon.pivot_offset = $Balloon.size/2
	$Balloon.scale.x = -1
	self.dialogue_line = await resource.get_next_dialogue_line(title, temporary_game_states)


## Go to the next line
func next(next_id: String) -> void:
	self.dialogue_line = await resource.get_next_dialogue_line(next_id, temporary_game_states)


### Helpers

# Returns a list of valid positions for the balloon to be so that it doesn't fall out of the viewport
func find_valid_balloon_positions(potential_positions: Array[Marker2D]) -> Array[Vector2]:
	var valid_positions: Array[Vector2]
	
	# var current_top_left = self.get_rect().position
	# var current_bottom_right = self.get_rect().end
	print(self.position)
	print(self.global_position)
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
	
	print("top left ", top_left_position, " ", top_left_corner)
	print("top right ", top_right_position, " ", top_right_corner)
	print("bottom left ", bottom_left_position, " ", bottom_left_corner)
	print("bottom right ", bottom_right_position, " ", bottom_right_corner)
	
	if is_position_valid(top_left_corner):
		valid_positions.append(top_left_position)
	if is_position_valid(top_right_corner):
		valid_positions.append(top_right_position)
	if is_position_valid(bottom_left_corner):
		valid_positions.append(bottom_left_position)
	if is_position_valid(bottom_right_corner):
		valid_positions.append(bottom_right_position)

	print(valid_positions)
	# return [new_balloon_position_top, new_balloon_position_bottom]
	return valid_positions


## Check if position falls within the viewport
func is_position_valid(global_position: Vector2) -> bool:
	return get_viewport().get_visible_rect().has_point(global_position)

## Takes a global position and sets the balloon to that location
func set_balloon_position(global_position: Vector2) -> void:
	self.set_global_position(global_position)
	print(global_position)

### Signals


func _on_mutated(_mutation: Dictionary) -> void:
	is_waiting_for_input = false
	will_hide_balloon = true
	get_tree().create_timer(0.1).timeout.connect(func():
		if will_hide_balloon:
			will_hide_balloon = false
			balloon.hide()
	)


func _on_balloon_gui_input(event: InputEvent) -> void:
	# If the user clicks on the balloon while it's typing then skip typing
	if dialogue_label.is_typing and event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.is_pressed():
		get_viewport().set_input_as_handled()
		dialogue_label.skip_typing()
		return

	if not is_waiting_for_input: return
	if dialogue_line.responses.size() > 0: return

	# When there are no response options the balloon itself is the clickable thing
	get_viewport().set_input_as_handled()

	if event is InputEventMouseButton and event.is_pressed() and event.button_index == 1:
		next(dialogue_line.next_id)
	elif event.is_action_pressed("ui_accept") and get_viewport().gui_get_focus_owner() == balloon:
		next(dialogue_line.next_id)


func _on_responses_menu_response_selected(response: DialogueResponse) -> void:
	next(response.next_id)
