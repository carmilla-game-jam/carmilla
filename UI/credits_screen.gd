extends Control

func _ready():
	$VBoxContainer/BackButton.grab_focus()

func _on_credits_button_button_up():
	SceneTransition.change_scene("title")
