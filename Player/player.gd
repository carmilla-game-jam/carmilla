extends CharacterBody2D

@export var SPEED = 75
@export var sus_decrease_rate_minor = 10
@export var sus_decrease_rate_major = 50
@onready var input_buffer = [Vector2.ZERO]
@onready var input_buffer_readout = Vector2()
@onready var sus_area_buffer_minor = []
@onready var sus_area_buffer_major = []
@onready var camera: Camera2D = get_node("/root/Camera")
@onready var animation_tree: AnimationTree = $AnimationTree
@onready var state_machine: AnimationNodeStateMachinePlayback = animation_tree["parameters/playback"]

func _ready():
	camera.enabled = true

func handle_input() -> void:

	if !Input.is_action_pressed("right"):
		input_buffer.erase(Vector2.RIGHT)
	if !Input.is_action_pressed("left"):
		input_buffer.erase(Vector2.LEFT)
	if !Input.is_action_pressed("up"):
		input_buffer.erase(Vector2.UP)
	if !Input.is_action_pressed("down"):
		input_buffer.erase(Vector2.DOWN)

	if Input.is_action_just_pressed("interact"):
		pass


func update_animations() -> void:
	input_buffer_readout = input_buffer[-1]
	velocity = input_buffer_readout * SPEED

	animation_tree.set("parameters/conditions/idle", velocity == Vector2.ZERO)
	animation_tree.set("parameters/conditions/is_moving", velocity != Vector2.ZERO)
	
	if(velocity != Vector2.ZERO):
		animation_tree["parameters/Idle/blend_position"] = velocity.normalized()
		animation_tree["parameters/Walk/blend_position"] = velocity.normalized()


func handle_sus_area(delta) -> void:
	if State.state["sus"]["enabled"]:
		if !sus_area_buffer_major.is_empty():
			State.decrease_sus_bar(sus_decrease_rate_major * delta)
		elif !sus_area_buffer_minor.is_empty():
			State.decrease_sus_bar(sus_decrease_rate_minor * delta)


func _unhandled_input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("right"):
		input_buffer.append(Vector2.RIGHT)
	elif Input.is_action_just_pressed("left"):
		input_buffer.append(Vector2.LEFT)
	elif Input.is_action_just_pressed("up"):
		input_buffer.append(Vector2.UP)
	elif Input.is_action_just_pressed("down"):
		input_buffer.append(Vector2.DOWN)


	if Input.is_action_just_pressed("cat_mode_toggle"):
		toggle_cat_mode()

	if Input.is_action_just_pressed("interact"):
		var actionables = $DirectionMarker2D/ActionableArea2D.get_overlapping_areas()
		if actionables.size() > 0:
			actionables[0].get_parent().open_dialog_box()
			return

func _physics_process(delta) -> void:
	camera.position = position
	handle_input()
	update_animations()
	handle_sus_area(delta)
	move_and_slide()
	
	print(sus_area_buffer_major)
	print(sus_area_buffer_minor)

func toggle_cat_mode() -> void:
	if !State.state["sus"]["enabled"]:
		$HearingArea2D.monitoring = true
		$HearingArea2D.monitorable = true
		$HearingArea2D/CollisionShape2D.disabled = false
		$HearingArea2D/Sprite2D.visible = true
		sus_area_buffer_minor.append($HearingArea2D.get_overlapping_areas())
		$SusArea2D.monitoring = true
		$SusArea2D.monitorable = true
		$SusArea2D/CollisionShape2D.disabled = false
		$SusArea2D/Sprite2D.visible = true
		sus_area_buffer_minor.append($SusArea2D.get_overlapping_areas())
		State.enable_cat_mode()
		
	else:
		$HearingArea2D.monitoring = false
		$HearingArea2D.monitorable = false
		$HearingArea2D/CollisionShape2D.disabled = true
		$HearingArea2D/Sprite2D.visible = false
		sus_area_buffer_minor.clear()
		$SusArea2D.monitoring = false
		$SusArea2D.monitorable = false
		$SusArea2D/CollisionShape2D.disabled = true
		$SusArea2D/Sprite2D.visible = false
		sus_area_buffer_major.clear()
		State.disable_cat_mode()


func _on_hearing_area_2d_area_entered(area) -> void:
	area.get_parent().open_dialog_box()
	sus_area_buffer_minor.append(area)


func _on_hearing_area_2d_area_exited(area) -> void:
	area.get_parent().close_dialog_box()
	sus_area_buffer_minor.erase(area)


func _on_sus_area_2d_area_entered(area) -> void:
	area.get_parent().close_dialog_box()
	sus_area_buffer_major.append(area)


func _on_sus_area_2d_area_exited(area) -> void:
	sus_area_buffer_major.erase(area)
