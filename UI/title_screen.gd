extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	$VBoxContainer/StartButton.grab_focus()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_start_button_button_up():
	Cutscenes.transitioning_target_scene = "opening"
	SceneTransition.change_scene("res://UI/cutscenes/cutscene.tscn")


func _on_credits_button_button_up():
	SceneTransition.change_scene("res://UI/credits_screen.tscn")
