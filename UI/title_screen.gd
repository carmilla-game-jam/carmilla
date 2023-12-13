extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_start_button_button_up():
	SceneTransition.change_scene("res://Main/main.tscn")


func _on_credits_button_button_up():
	SceneTransition.change_scene("res://UI/credits_screen.tscn")
