extends CanvasLayer


func change_scene(targetScene: String) -> void:
	$AnimationPlayer.play("Dissolve")
	await $AnimationPlayer.animation_finished
	get_tree().change_scene_to_file(targetScene)
	$AnimationPlayer.play_backwards("Dissolve")
