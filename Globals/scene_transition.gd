extends CanvasLayer


func change_scene(title: String) -> void:
	$AnimationPlayer.play("Dissolve")
	await $AnimationPlayer.animation_finished
	Camera.enabled = false
	Cutscenes.transitioning_target_scene = title
	get_tree().change_scene_to_file(Cutscenes.scenes[title]["scene_path"])
	$AnimationPlayer.play_backwards("Dissolve")
