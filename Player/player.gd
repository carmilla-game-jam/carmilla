extends CharacterBody2D

@export var SPEED = 75
@export var sus_decrease_rate_minor = 10
@export var sus_decrease_rate_major = 50
@onready var input_buffer = [Vector2.ZERO]
@onready var input_buffer_readout = Vector2()
@onready var camera: Camera2D = get_node("/root/Camera")
@onready var animation_tree: AnimationTree = $AnimationTree
@onready var state_machine: AnimationNodeStateMachinePlayback = animation_tree["parameters/playback"]

var is_cat_mode: bool = false
var in_sus_zone_minor: bool
var in_sus_zone_major: bool

func _ready():
	$HearingArea2D.monitoring = false
	$HearingArea2D.monitorable = false
	$HearingArea2D/CollisionShape2D.disabled = true
	$SusArea2D.monitoring = false
	$SusArea2D.monitorable = false
	$SusArea2D/CollisionShape2D.disabled = true
	is_cat_mode = false

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


func handle_sus_area(delta) -> void:
	# TODO: if overlapping with sus zone then decrease bar
	if is_cat_mode:
		if in_sus_zone_major:
			State.state["sus"]["level"] -= sus_decrease_rate_major * delta
		elif in_sus_zone_minor:
			State.state["sus"]["level"] -= sus_decrease_rate_minor * delta


func _unhandled_input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("cat_mode_toggle"):
		print("cat mode toggle")
		toggle_cat_mode()
	
	if Input.is_action_just_pressed("ui_accept"):
		var actionables = $DirectionMarker2D/ActionableArea2D.get_overlapping_areas()
		if actionables.size() > 0:
			actionables[0].get_parent().open_dialog_box()
			return

func _physics_process(delta) -> void:
	camera.position = position
	handle_input()
	handle_sus_area(delta)
	move_and_slide()

func toggle_cat_mode() -> void:
	if !is_cat_mode:
		$HearingArea2D.monitoring = true
		$HearingArea2D.monitorable = true
		$HearingArea2D/CollisionShape2D.disabled = false
		$SusArea2D.monitoring = true
		$SusArea2D.monitorable = true
		$SusArea2D/CollisionShape2D.disabled = false
		is_cat_mode = true
		# TODO: Add in circle visibility toggle too
	else:
		$HearingArea2D.monitoring = false
		$HearingArea2D.monitorable = false
		$HearingArea2D/CollisionShape2D.disabled = true
		$SusArea2D.monitoring = false
		$SusArea2D.monitorable = false
		$SusArea2D/CollisionShape2D.disabled = true
		is_cat_mode = false

func _on_hearing_area_2d_area_entered(area) -> void:
	area.get_parent().open_dialog_box()
	in_sus_zone_minor = true


func _on_hearing_area_2d_area_exited(area) -> void:
	area.get_parent().close_dialog_box()
	in_sus_zone_minor = false


func _on_sus_area_2d_area_entered(area) -> void:
	area.get_parent().close_dialog_box()
	in_sus_zone_major = true


func _on_sus_area_2d_area_exited(area) -> void:
	in_sus_zone_major = false
