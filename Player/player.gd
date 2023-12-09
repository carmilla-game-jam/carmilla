extends CharacterBody2D

@export var SPEED = 75
@onready var input_buffer = [Vector2.ZERO]
@onready var input_buffer_readout = Vector2()
@onready var camera: Camera2D = get_node("/root/Camera")
@onready var animation_tree: AnimationTree = $AnimationTree
@onready var state_machine: AnimationNodeStateMachinePlayback = animation_tree["parameters/playback"]


func handle_input() -> void:
	if Input.is_action_just_pressed("right"):
		input_buffer.append(Vector2.RIGHT)
	elif Input.is_action_just_pressed("left"):
		input_buffer.append(Vector2.LEFT)
	elif Input.is_action_just_pressed("up"):
		input_buffer.append(Vector2.UP)
	elif Input.is_action_just_pressed("down"):
		input_buffer.append(Vector2.DOWN)

	if !Input.is_action_pressed("right"):
		input_buffer.erase(Vector2.RIGHT)
	if !Input.is_action_pressed("left"):
		input_buffer.erase(Vector2.LEFT)
	if !Input.is_action_pressed("up"):
		input_buffer.erase(Vector2.UP)
	if !Input.is_action_pressed("down"):
		input_buffer.erase(Vector2.DOWN)

	input_buffer_readout = input_buffer[-1]
	velocity = input_buffer_readout * SPEED

	animation_tree.set("parameters/conditions/idle", velocity == Vector2.ZERO)
	animation_tree.set("parameters/conditions/is_moving", velocity != Vector2.ZERO)
	# print(input_buffer)
	
	if(velocity != Vector2.ZERO):
		animation_tree["parameters/Idle/blend_position"] = velocity.normalized()
		animation_tree["parameters/Walk/blend_position"] = velocity.normalized()

	if Input.is_action_just_pressed("interact"):
		pass
		
		
func handle_sus_area() -> void:
	# TODO: if overlapping with sus zone then decrease bar
	pass


func _unhandled_input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("ui_accept"):
		var actionables = $DirectionMarker2D/ActionableArea2D.get_overlapping_areas()
		if actionables.size() > 0:
			actionables[0].get_parent().open_dialog_box()
			return

func _physics_process(delta) -> void:
	camera.position = position
	handle_input()
	handle_sus_area()
	move_and_slide()


func _on_hearing_area_2d_area_entered(area) -> void:
	area.get_parent().open_dialog_box()


func _on_hearing_area_2d_area_exited(area) -> void:
	area.get_parent().close_dialog_box()


func _on_sus_area_2d_area_entered(area) -> void:
	area.get_parent().close_dialog_box()
