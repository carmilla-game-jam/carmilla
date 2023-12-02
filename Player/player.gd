extends CharacterBody2D

@export var SPEED = 75
@onready var input_buffer = [Vector2.ZERO]
@onready var input_buffer_readout = Vector2()
@onready var animation_tree: AnimationTree = $AnimationTree
@onready var state_machine: AnimationNodeStateMachinePlayback = animation_tree["parameters/playback"]

# TODO: erase all elements in the array with a certain value
func erase_all(input_buffer: Array, vector: Vector2) -> Array:
	return []

func handle_input():
	if Input.is_action_just_pressed("ui_right"):
		input_buffer.append(Vector2.RIGHT)
	elif Input.is_action_just_pressed("ui_left"):
		input_buffer.append(Vector2.LEFT)
	elif Input.is_action_just_pressed("ui_up"):
		input_buffer.append(Vector2.UP)
	elif Input.is_action_just_pressed("ui_down"):
		input_buffer.append(Vector2.DOWN)

	if Input.is_action_just_released("ui_right"):
		input_buffer.erase(Vector2.RIGHT)
	elif Input.is_action_just_released("ui_left"):
		input_buffer.erase(Vector2.LEFT)
	elif Input.is_action_just_released("ui_up"):
		input_buffer.erase(Vector2.UP)
	elif Input.is_action_just_released("ui_down"):
		input_buffer.erase(Vector2.DOWN)

	input_buffer_readout = input_buffer[-1]
	velocity = input_buffer_readout * SPEED

	animation_tree.set("parameters/conditions/idle", velocity == Vector2.ZERO)
	animation_tree.set("parameters/conditions/is_moving", velocity != Vector2.ZERO)
	print(input_buffer)
	
	if(velocity != Vector2.ZERO):
		animation_tree["parameters/Idle/blend_position"] = velocity.normalized()
		animation_tree["parameters/Walk/blend_position"] = velocity.normalized()

func _physics_process(delta):
	handle_input()
	move_and_slide()
